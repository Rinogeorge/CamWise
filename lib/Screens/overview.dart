import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rinosfirstproject/functions/db_functions.dart';
import 'package:rinosfirstproject/functions/model.dart';
import 'package:rinosfirstproject/widgets/revenue_card.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  @override
  void initState() {
    super.initState();

    // Open Hive box and update all revenue metrics after the widget tree is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final invoiceBox = Hive.box<InvoiceModel>('invoiceBox');
      updateAllRevenues(invoiceBox);
    });
  }

  /// Updates all revenue metrics (daily, weekly, monthly, and grand total)
  void updateAllRevenues(Box<InvoiceModel> invoiceBox) {
    updateDailyRevenue(invoiceBox);
    updateWeeklyRevenue(invoiceBox);
    updateMonthlyRevenue(invoiceBox);
    updateGrandTotalRevenue();
  }

  /// Updates the grand total revenue
  void updateGrandTotalRevenue() {
    double grandTotal = dailyRevenueNotifier.value +
        weeklyRevenueNotifier.value +
        monthlyRevenueNotifier.value;

    grandTotalNotifier.value = grandTotal;
  }

  /// Updates the daily revenue
  void updateDailyRevenue(Box<InvoiceModel> invoiceBox) {
    final now = DateTime.now();
    double dailyTotal = 0.0;

    for (var invoice in invoiceBox.values) {
      final invoiceDate = invoice.purchaseDate;
      if (invoiceDate != null && isSameDay(invoiceDate, now)) {
        dailyTotal += invoice.totalAmount ?? 0;
      }
    }

    dailyRevenueNotifier.value = dailyTotal;
  }

  /// Updates the weekly revenue
  void updateWeeklyRevenue(Box<InvoiceModel> invoiceBox) {
    final now = DateTime.now();
    double weeklyTotal = 0.0;

    for (var invoice in invoiceBox.values) {
      final invoiceDate = invoice.purchaseDate;
      if (invoiceDate != null && isSameWeek(invoiceDate, now)) {
        weeklyTotal += invoice.totalAmount ?? 0;
      }
    }

    weeklyRevenueNotifier.value = weeklyTotal;
  }

  /// Updates the monthly revenue
  void updateMonthlyRevenue(Box<InvoiceModel> invoiceBox) {
    final now = DateTime.now();
    double monthlyTotal = 0.0;

    for (var invoice in invoiceBox.values) {
      final invoiceDate = invoice.purchaseDate;
      if (invoiceDate != null && isSameMonth(invoiceDate, now)) {
        monthlyTotal += invoice.totalAmount ?? 0;
      }
    }

    monthlyRevenueNotifier.value = monthlyTotal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overview rrr'),
        centerTitle: true,
        backgroundColor:  Color(0xFF4AAEE7),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildPieChart(),
            const SizedBox(height: 20),
            _buildRevenueCards(),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          ValueListenableBuilder(
            valueListenable: grandTotalNotifier,
            builder: (context, grandTotal, child) {
              return ValueListenableBuilder(
                valueListenable: dailyRevenueNotifier,
                builder: (context, dailyRevenue, child) {
                  return ValueListenableBuilder(
                    valueListenable: weeklyRevenueNotifier,
                    builder: (context, weeklyRevenue, child) {
                      return ValueListenableBuilder(
                        valueListenable: monthlyRevenueNotifier,
                        builder: (context, monthlyRevenue, child) {
                          return PieChart(
                            PieChartData(
                              sections: [
                                _buildPieChartSection(
                                  value: dailyRevenue,
                                  color: Colors.red,
                                  title: 'Daily',
                                ),
                                _buildPieChartSection(
                                  value: weeklyRevenue,
                                  color: Colors.green,
                                  title: 'Weekly',
                                ),
                                _buildPieChartSection(
                                  value: monthlyRevenue,
                                  color: Colors.blue,
                                  title: 'Monthly',
                                ),
                                _buildPieChartSection(
                                  value: grandTotal,
                                  color: Colors.orange,
                                  title: 'Total',
                                ),
                              ],
                              centerSpaceRadius: 90,
                              centerSpaceColor:
                                  const Color.fromARGB(255, 124, 186, 187),
                              sectionsSpace: 1,
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
          const Center(
            child: Text(
              "Revenue Distribution",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueCards() {
    return Column(
      children: [
        buildRevenueCard(
          title: 'Total Revenue:',
          valueNotifier: grandTotalNotifier,
          color: const Color.fromARGB(255, 247, 216, 183),
          textColor: const Color.fromARGB(255, 153, 96, 17),
        ),
        const SizedBox(height: 10),
        buildRevenueCard(
          title: 'Daily Revenue:',
          valueNotifier: dailyRevenueNotifier,
          color: const Color.fromARGB(255, 254, 192, 189),
          textColor: const Color.fromARGB(255, 146, 34, 21),
        ),
        const SizedBox(height: 10),
        buildRevenueCard(
          title: 'Weekly Revenue:',
          valueNotifier: weeklyRevenueNotifier,
          color: const Color.fromARGB(255, 207, 251, 187),
          textColor: const Color.fromARGB(255, 39, 134, 30),
        ),
        const SizedBox(height: 10),
        buildRevenueCard(
          title: 'Monthly Revenue:',
          valueNotifier: monthlyRevenueNotifier,
          color: Colors.blue[100],
          textColor: Colors.blue,
        ),
      ],
    );
  }

  /// Builds a section for the pie chart
  PieChartSectionData _buildPieChartSection({
    required double value,
    required Color color,
    required String title,
  }) {
    return PieChartSectionData(
      value: value,
      color: color,
      title: title,
      radius: 50,
      titleStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  /// Checks if two dates are on the same day
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Checks if a date is in the same week as a reference date
  bool isSameWeek(DateTime date, DateTime reference) {
    final firstDayOfWeek = reference.subtract(Duration(days: reference.weekday - 1));
    final lastDayOfWeek = firstDayOfWeek.add(Duration(days: 6));
    return date.isAfter(firstDayOfWeek.subtract(const Duration(seconds: 1))) &&
        date.isBefore(lastDayOfWeek.add(const Duration(seconds: 1)));
  }

  /// Checks if two dates are in the same month
  bool isSameMonth(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month;
  }

  /// Debugs invoices in the Hive box
  void debugInvoices(Box<InvoiceModel> invoiceBox) {
    for (var invoice in invoiceBox.values) {
      print('Invoice ID: ${invoice.id}, Date: ${invoice.purchaseDate}, Amount: ${invoice.totalAmount}');
    }
  }
}
