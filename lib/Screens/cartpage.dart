import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rinosfirstproject/Screens/product_search.dart';
import 'package:rinosfirstproject/Screens/sell_details.dart';
import 'package:rinosfirstproject/functions/cart_db.dart';
import '../functions/model.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<List<Productmodel>> cartProducts;
  final CartRepository cartRepository = CartRepository();
  final Map<int, int> cartQuantities = {};

  @override
  void initState() {
    super.initState();
    cartProducts = _getCartProducts();
  }

  Future<List<Productmodel>> _getCartProducts() async {
    List<Productmodel> products = await cartRepository.getCartProducts();
    for (var product in products) {
      cartQuantities[product.id!] = cartQuantities[product.id!] ?? 1;
    }
    return products;
  }

  void incrementQuantity(int productId, int maxStock) {
    setState(() {
      if ((cartQuantities[productId] ?? 0) < maxStock) {
        cartQuantities[productId] = (cartQuantities[productId] ?? 0) + 1;
        cartRepository.updateQuantity(productId, cartQuantities[productId]!);
      }
    });
  }

  void decrementQuantity(int productId) {
    setState(() {
      if ((cartQuantities[productId] ?? 0) > 1) {
        cartQuantities[productId] = (cartQuantities[productId] ?? 0) - 1;
        cartRepository.updateQuantity(productId, cartQuantities[productId]!);
      }
    });
  }

  void deleteProduct(int productId) {
    setState(() {
      cartQuantities.remove(productId);
      cartProducts = cartRepository.removeFromCart(productId).then(
            (_) => _getCartProducts(),
          );
    });
  }

  void addNotification(
      String title, String message, String customerName, double amount) async {
    try {
      final notificationBox =
          await Hive.openBox<NotificationModel>('notifications');
      final notification = NotificationModel(
        title: title,
        message: message,
        customerName: customerName,
        totalAmountSale: amount,
      );
      await notificationBox.add(notification);
    } catch (e) {
      print("Error adding notification: $e");
    }
  }

  // Checkout method - Prepare and navigate to SellDetailsPage with invoice data

Future<void> checkout() async {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Customer Details',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      prefixIcon: const Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      prefixIcon: const Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent.shade700,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: () async {
                          await _handleCheckout(
                            nameController.text.trim(),
                            phoneController.text.trim(),
                            context,
                          );
                        },
                        child: const Text(
                          'Done',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

Future<void> _handleCheckout(
    String customerName, String customerPhone, BuildContext context) async {
  // Input validation
  if (customerName.isEmpty || customerPhone.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please fill in all details'),
      ),
    );
    return;
  }

  Navigator.of(context).pop(); // Close dialog

  try {
    final cartProductsList = await cartProducts;

    if (cartProductsList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cart is empty'),
        ),
      );
      return;
    }

    // Prepare invoice data
    final invoiceModels = cartProductsList.map((product) {
      final quantity = cartQuantities[product.id!] ?? 1;
      return InvoiceModel(
        squantity: quantity,
        id: product.id,
        customerName: customerName,
        customerPhone: customerPhone,
        products: [product],
        amount: product.sellingrate?.toDouble() ?? 0.0,
        purchaseDate: DateTime.now(),
        totalAmount: (product.sellingrate?.toDouble() ?? 0.0) * quantity,
      );
    }).toList();

    // Save invoice data to the database
    final invoiceBox = await Hive.openBox<InvoiceModel>('invoiceBox');
    final productBox = await Hive.openBox<Productmodel>('product_db');

    for (var invoice in invoiceModels) {
      await invoiceBox.add(invoice);
    }

    for (var product in cartProductsList) {
      final quantity = cartQuantities[product.id!] ?? 1;
      final updatedProduct = productBox.get(product.id);

      if (updatedProduct != null) {
        updatedProduct.stock = (updatedProduct.stock ?? 0) - quantity;
        await productBox.put(updatedProduct.id, updatedProduct);
      }
    }

    // Clear the cart after saving
    await CartDatabase.clearCart();

    final totalAmount = invoiceModels.fold(
      0.0,
      (sum, invoice) => sum + (invoice.totalAmount ?? 0.0),
    );

    // Send a notification about the sale
    addNotification(
      'Sale Completed',
      'A sale was completed with customer: $customerName',
      customerName,
      totalAmount,
    );

    // Navigate with a slide animation
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SellDetailsPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  } catch (e) {
    if (kDebugMode) {
      print('Error during checkout: $e');
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Error: Unable to complete checkout'),
      ),
    );
  }
}



  double calculateTotalAmount(List<Productmodel> products) {
    double total = 0.0;
    for (var product in products) {
      final quantity = cartQuantities[product.id!] ?? 1;
      total += (product.sellingrate ?? 0) * quantity;
    }
    return total;
  }
bool isAnyProductOutOfStock(List<Productmodel> products) {
  for (var product in products) {
    if (product.stock == 0) {
      return true; // If any product is out of stock
    }
  }
  return false; // No products are out of stock
}
 

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text(
        'Your Cart',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 29),
      ),
      centerTitle: true,
      backgroundColor: Color(0xFF4AAEE7),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            showSearch(
              context: context,
              delegate: ProductSearchDelegate(
                onSearch: (product) {
                  // Only add the product to the cart if it's in stock
                  if (product.stock != null && product.stock! > 0) {
                    cartRepository.addToCart(product);
                    setState(() {
                      cartProducts = _getCartProducts();
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Product is out of stock')),
                    );
                  }
                },
              ),
            );
          },
        ),
      ],
    ),
    body: FutureBuilder<List<Productmodel>>(
      future: cartProducts,
      builder:
          (BuildContext context, AsyncSnapshot<List<Productmodel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Your cart is empty'));
        }

        final List<Productmodel> cartItems = snapshot.data!;

        return ListView.builder(
          itemCount: cartItems.length,
          itemBuilder: (BuildContext context, int index) {
            final product = cartItems[index];
            final int cartQuantity = cartQuantities[product.id!] ?? 1;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: product.image != null
                      ? Image.file(File(product.image!),
                          fit: BoxFit.cover, width: 50, height: 50)
                      : const Icon(Icons.image, size: 50),
                  title: Text(product.productname ?? 'Unnamed Product',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      product.stock == 0
                          ? const Text(
                              'Out of stock',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            )
                          : Text(
                              '₹ ${product.sellingrate ?? 0}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                      const SizedBox(height: 8),
                      if (product.stock !=
                          0) // Show quantity adjustment only if in stock
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, color: Colors.red),
                              onPressed: cartQuantity > 1
                                  ? () => decrementQuantity(product.id!)
                                  : null,
                            ),
                            Text(
                              '$cartQuantity',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, color: Colors.green),
                              onPressed: cartQuantity < (product.stock ?? 1)
                                  ? () =>
                                      incrementQuantity(product.id!, product.stock!)
                                  : null,
                            ),
                          ],
                        ),
                      const SizedBox(height: 8),
                      Text(
                        product.stock == 0
                            ? '' // No total amount for out-of-stock items
                            : 'Total: ₹ ${(product.sellingrate ?? 0) * cartQuantity}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteProduct(product.id!),
                  ),
                ),
              ),
            );
          },
        );
      },
    ),
    floatingActionButton: FutureBuilder<List<Productmodel>>(
      future: cartProducts,
      builder:
          (BuildContext context, AsyncSnapshot<List<Productmodel>> snapshot) {
        final isDisabled = snapshot.connectionState == ConnectionState.waiting ||
            snapshot.hasError ||
            (!snapshot.hasData || snapshot.data!.isEmpty) ||
            (snapshot.hasData && isAnyProductOutOfStock(snapshot.data!));

        return FloatingActionButton.extended(
          onPressed: isDisabled ? null : checkout,
          label: const Text('Buy Now'),
          icon: const Icon(Icons.shopping_cart_checkout),
          backgroundColor: isDisabled
              ? Colors.grey
              : const Color(0xFF6A8E4E),
        );
      },
    ),
    bottomNavigationBar: FutureBuilder<List<Productmodel>>(
      future: cartProducts,
      builder:
          (BuildContext context, AsyncSnapshot<List<Productmodel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        } else if (snapshot.hasError) {
          return const SizedBox();
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox();
        }

        final List<Productmodel> cartItems = snapshot.data!;
        final totalAmount = calculateTotalAmount(cartItems);

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                '₹ $totalAmount',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
        );
      },
    ),
  );
}
}