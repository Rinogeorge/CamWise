import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rinosfirstproject/Screens/edit_products.dart';
import 'package:rinosfirstproject/functions/model.dart';

class StockDetails extends StatefulWidget {
  StockDetails({super.key}); // Removed const

  @override
  _OutOfStockPageState createState() => _OutOfStockPageState();
}

class _OutOfStockPageState extends State<StockDetails> {
  late Future<List<Productmodel>> products;

  @override
  void initState() {
    super.initState();
    products = fetchProducts();
  }
  Future<List<Productmodel>> fetchProducts() async {
    final productBox = await Hive.openBox<Productmodel>('product_db');
    return productBox.values.where((product) => product.stock! <= 5).toList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          " Stock Updates",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Productmodel>>(
        future: products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final productList = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: productList.length,
              itemBuilder: (context, index) {
                final product = productList[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8.0),
                    leading: product.image != null && product.image!.isNotEmpty
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
                            color:
                                product.stock == 0 ? Colors.red : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.green),
                          onPressed: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Myeditproducts(
                                  categoryid: product.categoryname ?? '',
                                  data: product,
                                ),
                              ),
                            );
                            setState(() {
                              products = fetchProducts();
                            });
                          },
                        ),
                       
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text("No out-of-stock products found."),
            );
          }
        },
      ),
    );
  }
}
