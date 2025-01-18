import 'package:hive_flutter/hive_flutter.dart';
import '../functions/model.dart';

class CartDatabase {
  static const String _cartBoxName = 'cart_db';

  // Open the cart box
  static Future<Box<Productmodel>> _openCartBox() async {
    return await Hive.openBox<Productmodel>(_cartBoxName);
  }

  // Method to add a product to the cart
  static Future<void> addToCart(Productmodel product) async {
    final cartBox = await _openCartBox();
    cartBox.put(product.id, product);
  }

  static Future<List<Productmodel>> getCartProducts() async {
    final cartBox = await _openCartBox();
    return cartBox.values.toList();
  }

  static Future<void> updateProductQuantity(int productId, int quantity) async {
    final cartBox = await _openCartBox();
    final product = cartBox.get(productId);

    if (product != null) {
      product.stock = quantity;
      await cartBox.put(productId, product);
    }
  }

  static Future<void> deleteProductFromCart(int productId) async {
    final cartBox = await _openCartBox();
    await cartBox.delete(productId);
  }

  static Future<void> clearCart() async {
    final cartBox = await _openCartBox();
    await cartBox.clear();
  }

  static Future<List<Productmodel>> getAllProducts() async {
    final productBox = await Hive.openBox<Productmodel>('product_db');
    return productBox.values.toList();
  }

  static Future<List<Productmodel>> searchProductsByName(String query) async {
    final allProducts = await getAllProducts();
    return allProducts
        .where((product) =>
            product.productname!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}

class ProductDatabase {
  static Future<List<Productmodel>> getAllProducts() async {
    final productBox = await Hive.openBox<Productmodel>('product_db');
    print(productBox);
    return productBox.values.toList();
  }

  static Future<List<Productmodel>> searchProductsByName(String query) async {
    final allProducts = await getAllProducts(); 
    return allProducts
        .where((product) =>
            product.productname!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}

class CartDatabase1 {
  static final Map<int, int> _productQuantities = {};

  // adding a product to the cart
  static Future<void> addProductToCart(int productId, int quantity) async {
    _productQuantities[productId] =
        (_productQuantities[productId] ?? 0) + quantity;
  }

  // Define the getProductQuantity method
  static Future<int> getProductQuantity(int productId) async {
    return _productQuantities[productId] ?? 0;
  }

  // get all cart products
  static Future<List<Productmodel>> getCartProducts() async {
    return [];
  }
}

class CartRepository {
  Future<List<Productmodel>> getCartProducts() async {
    return await CartDatabase.getCartProducts();
  }

  Future<void> addToCart(Productmodel product) async {
    await CartDatabase.addToCart(product);
  }

  Future<void> removeFromCart(int productId) async {
    await CartDatabase.deleteProductFromCart(productId);
  }

  Future<void> updateQuantity(int productId, int quantity) async {
  }
}

class CartRepositorys {
  final Box<Productmodel> _cartBox = Hive.box<Productmodel>('cartBox');

  Future<List<Productmodel>> getCartProducts() async {
    return _cartBox.values.toList();
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    final product = _cartBox.get(productId);
    if (product != null) {
      product.stock = quantity; 
      await _cartBox.put(productId, product);
    }
  }

  Future<void> removeFromCart(int productId) async {
    await _cartBox.delete(productId);
  }

  Future<void> clearCart() async {
    await _cartBox.clear();
  }
}

class DatabaseHelper {
  static late Box<InvoiceModel> invoiceBox;

  // Initialize Hive
  static Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(
        InvoiceModelAdapter()); 
    invoiceBox = await Hive.openBox<InvoiceModel>('invoices');
  }

  // Save an invoice
  static Future<void> saveInvoice(InvoiceModel invoice) async {
    await invoiceBox.add(invoice);
  }

  // Get all invoices
  static List<InvoiceModel> getInvoices() {
    return invoiceBox.values.toList();
  }

  // Get the last invoice id and increment it
  static int getLastInvoiceId() {
    var invoices = getInvoices();
    if (invoices.isEmpty) {
      return 1; // Start with 1 for the first invoice
    }
    return invoices.last.id! + 1;
  }
}
