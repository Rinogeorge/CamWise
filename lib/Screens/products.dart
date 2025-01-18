import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rinosfirstproject/Screens/add_product.dart';
import 'package:rinosfirstproject/Screens/cartpage.dart';
import 'package:rinosfirstproject/Screens/edit_products.dart';
import 'package:rinosfirstproject/Screens/product_details.dart';
import 'package:rinosfirstproject/functions/cart_db.dart';
import 'package:rinosfirstproject/functions/model.dart';

class Myproduct extends StatefulWidget {
  final ValueNotifier<List<Productmodel>> productListNotifier;
  final Categorymodel data;

  const Myproduct({
    required this.productListNotifier,
    super.key,
    required this.data,
  });

  @override
  State<Myproduct> createState() => _MyproductState();
}

class _MyproductState extends State<Myproduct> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getProductsByCategory(widget.data.categoryname);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4AAEE7),
        centerTitle: true,
        title: Text(
          widget.data.categoryname,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            color: Colors.white,
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const CartPage();
              }));
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 10),
            Expanded(
              child: ValueListenableBuilder<List<Productmodel>>(
                valueListenable: widget.productListNotifier,
                builder: (BuildContext context, List<Productmodel>? productList, Widget? child) {
                  if (productList?.isEmpty ?? true) {
                    return const Center(
                      child: Text(
                        'No products found',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    );
                  }
                  return _buildProductGrid(productList!);
                },
              ),
            ),
            const SizedBox(height: 10),
            _buildAddProductButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        labelText: 'Search products',
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (value) {
        updateProductList(value);
      },
    );
  }

  Widget _buildProductGrid(List<Productmodel> productList) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: productList.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildProductCard(productList[index]);
      },
    );
  }

  Widget _buildProductCard(Productmodel product) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Productdetail(data: product);
                    },
                  );
                },
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                  child: Image.file(
                    File(product.image ?? ''),
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (product.stock == 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Out of Stock',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.productname ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  product.stock! > 0
                      ? '₹ ${product.sellingrate}'
                      : 'Out of stock',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: product.stock! > 0 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blueAccent),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Myeditproducts(
                        categoryid: widget.data.categoryname,
                        data: product,
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () {
                  _showDeleteConfirmationDialog(product);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.add_shopping_cart,
                  color: product.stock! > 0 ? Colors.orange : Colors.grey,
                ),
                onPressed: product.stock! > 0
                    ? () {
                        CartDatabase.addToCart(product).then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Added to cart')),
                          );
                        }).catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Failed to add to cart')),
                          );
                        });
                      }
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddProductButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: FloatingActionButton(
        backgroundColor: const Color(0xFF4AAEE7),
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Addproduct(
                categoryname: widget.data.categoryname,
              ),
            ),
          );
        },
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          size: 28,
        ),
      ),
    );
  }

  Future<void> getProductsByCategory(String categoryname) async {
    List<Productmodel> products = await fetchProductsByCategory(categoryname);
    widget.productListNotifier.value = products;
  }

  Future<List<Productmodel>> fetchProductsByCategory(String categoryname) async {
    final productBox = await Hive.openBox<Productmodel>('product_db');
    final productList = productBox.values
        .where((product) => product.categoryname == categoryname)
        .toList();
    return productList;
  }

  void updateProductList(String query) {
    if (query.isEmpty) {
      getProductsByCategory(widget.data.categoryname);
    } else {
      final List<Productmodel> filteredList = widget.productListNotifier.value
          .where((product) => product.productname!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      widget.productListNotifier.value = filteredList;
    }
  }

void _showDeleteConfirmationDialog(Productmodel product) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Open the Hive box
              final productBox = await Hive.openBox<Productmodel>('product_db');

              // Log all products before deletion
              print('Products before deletion: ${productBox.values.toList()}');

              // Perform deletion
              await productBox.delete(product.id);

              // Log all products after deletion
              print('Products after deletion: ${productBox.values.toList()}');

              // Update the ValueNotifier value directly
              widget.productListNotifier.value = List.from(widget.productListNotifier.value
                  .where((p) => p.id != product.id));

              // Close the dialog
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}


}
