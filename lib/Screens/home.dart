import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rinosfirstproject/Screens/edit_products.dart';
import 'package:rinosfirstproject/functions/model.dart';
import 'package:intl/intl.dart';
import 'package:rinosfirstproject/Screens/cartpage.dart';
import 'package:rinosfirstproject/Screens/notification.dart';
import 'package:rinosfirstproject/Screens/overview.dart';
import 'package:rinosfirstproject/Screens/sell_details.dart';
import 'package:rinosfirstproject/functions/db_functions.dart';
import 'package:rinosfirstproject/widgets/homewidgets.dart'; // <-- Ensure this import is added

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final String formattedDate =
        DateFormat('dd MMMM yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationPage()),
            ),
            icon: const Icon(Icons.notifications_none, color: Colors.black87),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfitSection(formattedDate),
              const SizedBox(height: 24),
              _buildActionButtons(context),
              const SizedBox(height: 24),
              _buildProductCards(),
              const SizedBox(height: 24),
              _buildStockUpdates(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfitSection(String formattedDate) {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4AAEE7), Color(0xFF148DD2)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            formattedDate,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Profit',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 4),
              ValueListenableBuilder<double>(
                valueListenable: grandTotalNotifier,
                builder: (context, grandTotal, child) {
                  return Text(
                    '₹ ${grandTotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildActionButton(
                context, 'Sell Details', Icons.shopping_bag_outlined, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SellDetailsPage()));
            }, Colors.green),
            buildActionButton(context, 'Cart', Icons.shopping_cart_outlined,
                () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CartPage()));
            }, Colors.orange),
            buildActionButton(context, 'Overview', Icons.analytics_outlined,
                () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OverviewPage()));
            }, Colors.blue),
          ],
        ),
      ],
    );
  }

  Widget _buildProductCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Product Insights',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ValueListenableBuilder<Map<String, dynamic>>(
                valueListenable: mostSellingProductNotifier,
                builder: (context, mostSellingProduct, child) {
                  return _buildProductCard(
                    'Most Selling Product',
                    mostSellingProduct['name'] ?? 'N/A',
                    mostSellingProduct['quantity'] ?? 0,
                    Colors.blue,
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ValueListenableBuilder<Map<String, dynamic>>(
                valueListenable: leastSellingProductNotifier,
                builder: (context, leastSellingProduct, child) {
                  return _buildProductCard(
                    'Least Selling Product',
                    leastSellingProduct['name'] ?? 'N/A',
                    leastSellingProduct['quantity'] ?? 0,
                    Colors.red,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProductCard(
      String title, String product, int quantity, Color color) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Product: $product',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Sold Quantity: $quantity',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStockUpdates(BuildContext context) {
    return FutureBuilder<List<Productmodel>>(
      future: fetchProducts(), // Fetch the stock updates
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final productList = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Stock Updates',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: productList.length,
                itemBuilder: (context, index) {
                  final product = productList[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(8.0),
                      leading: product.image != null &&
                              product.image!.isNotEmpty
                          ? product.image!.startsWith('http')
                              ? Image.network(
                                  product.image!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image),
                                )
                              : Image.file(
                                  File(product.image!),
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image),
                                )
                          : const Icon(Icons.image, size: 50),
                      title: Text(
                        product.productname ?? "Unnamed Product",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4.0),
                          Text(
                            "Price: ${product.sellingrate ?? 0} Rs",
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            product.stock == 0
                                ? "Stock: Out of Stock"
                                : "Only ${product.stock} stock left",
                            style: TextStyle(
                              fontSize: 14.0,
                              color: product.stock == 0
                                  ? Colors.red
                                  : Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.green),
                        onPressed: () async {
                          final result = await Navigator.of(context)
                              .push(MaterialPageRoute(
                            builder: (context) => Myeditproducts(
                              categoryid: product.categoryname ?? '',
                              data: product,
                            ),
                          ));

                          if (result == true) {
                            // If the product was edited, refresh the stock updates
                            setState(() {
                              fetchProducts(); // Re-fetch the products to reflect changes
                            });
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        } else {
          return const Center(
            child: Text("No stock updates available."),
          );
        }
      },
    );
  }

  Future<List<Productmodel>> fetchProducts() async {
    final productBox = await Hive.openBox<Productmodel>('product_db');
    return productBox.values.where((product) => product.stock! <= 5).toList();
  }
}
