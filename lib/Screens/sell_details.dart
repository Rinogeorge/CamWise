import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rinosfirstproject/functions/model.dart';
 // File where grandTotalNotifier is declared.

// Declare the ValueNotifiers for most and least selling products here
ValueNotifier<Map<String, dynamic>> mostSellingProductNotifier = ValueNotifier({});
ValueNotifier<Map<String, dynamic>> leastSellingProductNotifier = ValueNotifier({});

class SellDetailsPage extends StatefulWidget {
  const SellDetailsPage({super.key});

  @override
  _SellDetailsPageState createState() => _SellDetailsPageState();
}

class _SellDetailsPageState extends State<SellDetailsPage> {
  late Box<InvoiceModel> invoiceBox;

  TextEditingController searchController = TextEditingController();
  List<InvoiceModel> filteredInvoices = [];

  @override
  void initState() {
    super.initState();
    openInvoiceBox();
    searchController.addListener(_filterInvoices);
  }

  Future<void> openInvoiceBox() async {
    invoiceBox = await Hive.openBox<InvoiceModel>('invoiceBox');
    setState(() {
      filteredInvoices = invoiceBox.values.toList();
      _calculateMostAndLeastSellingProducts();
    });

    // Listen for changes in Hive box
    invoiceBox.watch().listen((_) {
      _filterInvoices();
      _calculateMostAndLeastSellingProducts();
    });
  }

  void _filterInvoices() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredInvoices = invoiceBox.values.where((invoice) {
        final customerName = invoice.customerName?.toLowerCase() ?? '';
        final customerPhone = invoice.customerPhone?.toLowerCase() ?? '';
        final amount = invoice.totalAmount?.toString() ?? '';
        return customerName.contains(query) ||
            customerPhone.contains(query) ||
            amount.contains(query);
      }).toList();

      _calculateMostAndLeastSellingProducts();
    });
  }

  void _calculateMostAndLeastSellingProducts() {
    final Map<String, int> productSales = {};

    // Calculate the total quantity sold for each product
    for (var invoice in filteredInvoices) {
      for (var product in invoice.products!) {
        productSales[product.productname!] =
            (productSales[product.productname!] ?? 0) + invoice.squantity!;
      }
    }

    // Find the most and least selling products
    if (productSales.isNotEmpty) {
      final mostSellingProduct = productSales.entries.reduce((a, b) => a.value > b.value ? a : b);
      final leastSellingProduct = productSales.entries.reduce((a, b) => a.value < b.value ? a : b);

      mostSellingProductNotifier.value = {
        'name': mostSellingProduct.key,
        'quantity': mostSellingProduct.value
      };

      leastSellingProductNotifier.value = {
        'name': leastSellingProduct.key,
        'quantity': leastSellingProduct.value
      };
    } else {
      mostSellingProductNotifier.value = {'name': 'No data available', 'quantity': 0};
      leastSellingProductNotifier.value = {'name': 'No data available', 'quantity': 0};
    }
  }

 void deleteInvoice(int index) {
    invoiceBox.deleteAt(index);
    _filterInvoices();
  }
  @override
  Widget build(BuildContext context) {
    final Map<String, List<InvoiceModel>> groupedInvoices = {};
    for (var invoice in filteredInvoices) {
      final key = '${invoice.customerName}-${invoice.customerPhone}';
      if (groupedInvoices.containsKey(key)) {
        groupedInvoices[key]!.add(invoice);
      } else {
        groupedInvoices[key] = [invoice];
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Details'),
        centerTitle: true,
        backgroundColor: const Color(0xFF4A8E4E),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search by name, phone ',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: groupedInvoices.entries.map((entry) {
                final customerInvoices = entry.value;
                double totalAmount = customerInvoices.fold(
                    0, (sum, invoice) => sum + (invoice.totalAmount ?? 0));

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              customerInvoices[0].customerName ??
                                  'Unknown Customer',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                int indexToDelete = invoiceBox.values
                                    .toList()
                                    .indexOf(customerInvoices[0]);
                                deleteInvoice(indexToDelete);
                              },
                            ),
                          ],
                        ),
                        Text(
                          'Phone: ${customerInvoices[0].customerPhone ?? 'N/A'}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black54),
                        ),
                        const Divider(thickness: 1, height: 20),
                        const Text(
                          'Purchased Items:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Column(
                          children: customerInvoices.map((invoice) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      invoice.products![0].productname ??
                                          'Unknown Product',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  Text(
                                    'Qty: ${invoice.squantity}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    '₹${invoice.totalAmount}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        const Divider(thickness: 1, height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Amount: ₹$totalAmount',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              ' Date: ${customerInvoices[0].purchaseDate.toString().split(' ')[0]}',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

          
          ),
        ],
      ), 
      
    );
  }
  
}
