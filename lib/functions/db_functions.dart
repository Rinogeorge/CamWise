// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, duplicate_ignore, avoid_print

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rinosfirstproject/functions/model.dart';

ValueNotifier<List<Userdatamodel>> userListNotifier = ValueNotifier([]);
ValueNotifier<List<Categorymodel>> categoryListNotifier = ValueNotifier([]);
ValueNotifier<List<Productmodel>> productListNotifier = ValueNotifier([]);
late Box<Productmodel> cartBox;
ValueNotifier<List<Productmodel>> cartListNotifier = ValueNotifier([]);

Future<void> addproducts(Productmodel value, String categoryid) async {
  await IDGenerator2.initialize();
  final productBox = await Hive.openBox<Productmodel>('product_db');
  int id = IDGenerator2.generateUniqueID();
  value.id = id;
  value.categoryname = categoryid;
  final addedid = productBox.add(value);
  print('generated id: $id');

  // ignore: unnecessary_null_comparison
  if (addedid != null) {
    productListNotifier.value = [...productListNotifier.value, value];
    productListNotifier.notifyListeners();
  }
}

Future<void> getallproduct() async {
  final productBox = await Hive.openBox<Productmodel>('product_db');
  final categoryList = List<Productmodel>.from(productBox.values);
  productListNotifier.value = [...categoryList];
  productListNotifier.notifyListeners();
}

class IDGenerator {
  static const String _counterBoxKey = 'counterBoxKey';
  static late Box<int> _counterBox;

  static int _counter = 0;

  static Future<void> initialize() async {
    _counterBox = await Hive.openBox<int>(_counterBoxKey);
    _counter = _counterBox.get('counter') ?? 0;
  }

  static int generateUniqueID() {
    final generatedID = _counter++;
    _counterBox.put('counter', _counter);
    return generatedID;
  }
}

// User functions
Future<void> addSignUp(Userdatamodel value) async {
  // ignore: duplicate_ignore
  try {
    await IDGenerator.initialize();
    final chairDB = await Hive.openBox<Userdatamodel>('login_db');
    final idd = IDGenerator.generateUniqueID();
    value.id = idd;
    await chairDB.put(idd, value);
    userListNotifier.value.add(value);
    chairDB.close();
    // ignore: invalid_use_of_protected_member
    userListNotifier.notifyListeners();
  } catch (error) {
    print('Error adding user: $error');
  }
}

Future<void> getAll() async {
  try {
    final chairDB = await Hive.openBox<Userdatamodel>('login_db');

    userListNotifier.value.clear();
    userListNotifier.value.addAll(chairDB.values);
    // ignore: invalid_use_of_protected_member
    userListNotifier.notifyListeners();
  } catch (error) {
    print('Error retrieving users: $error');
  }
}



// Category functions
Future<void> addCategory(Categorymodel value) async {
  try {
    await IDGenerator.initialize();
    final categoryDB = await Hive.openBox<Categorymodel>('category_db');

    // Assign unique id to the Categorymodel object
    value.id = IDGenerator.generateUniqueID();

    await categoryDB.put(
        value.id, value); // Add the Categorymodel object to the database
    categoryListNotifier.value
        .add(value); // Add the Categorymodel object to the notifier list

    categoryDB.close();
    categoryListNotifier.notifyListeners(); // Notify listeners of the change
  } catch (error) {
    print('Error adding category: $error');
  }
}

Future<void> getAllCategories() async {
  try {
    final categoryDB = await Hive.openBox<Categorymodel>('category_db');
    categoryListNotifier.value.clear();
    categoryListNotifier.value.addAll(categoryDB.values);
    categoryDB.close();
    categoryListNotifier.notifyListeners();
  } catch (error) {
    print('Error retrieving categories: $error');
  }
}

Future<void> deletectgrs(int id) async {
  IDGenerator.initialize();
  final categoryDB = await Hive.openBox<Categorymodel>('category_db');

  // Check if the category with the given id exists
  await categoryDB.delete(id); // Delete the category with the given id
  await getAllCategories(); // Refresh category list
  categoryDB.close();
}

Future<void> updatectgrs(int id, Categorymodel updatedCategory) async {
  try {
    final categoryDB = await Hive.openBox<Categorymodel>('category_db');

    // Check if the category with the given id exists
    if (categoryDB.containsKey(id)) {
      await categoryDB.put(id, updatedCategory); // Update the category
      int index =
          categoryListNotifier.value.indexWhere((data) => data.id == id);
      if (index != -1) {
        categoryListNotifier.value[index] =
            updatedCategory; // Update the category in the notifier list
        // Notify listeners of the change
      }
      categoryListNotifier.notifyListeners();
    } else {
      print('Category with id $id does not exist');
    }
  } catch (error) {
    // ignore: avoid_print
    print('Error updating category: $error');
  }
}

class IDGenerator2 {
  static const String _counterBoxKey = 'counterBoxkey2';
  static late Box<int> _counterBox;
  static int _counter = 0;

  static Future<void> initialize() async {
    _counterBox = await Hive.openBox<int>(_counterBoxKey);
    _counter = _counterBox.get('counter') ?? 0;
  }

  static int generateUniqueID() {
    final generatedID = _counter++;
    _counterBox.put('counter', _counter);
    return generatedID;
  }
}


class IDGeneratorbill {
  static const String _counterBoxKey = 'counterBoxkey3';
  static late Box<int> _counterBox;
  static int _counter = 0;

  static Future<void> initialize() async {
    _counterBox = await Hive.openBox<int>(_counterBoxKey);
    _counter = _counterBox.get('counter') ?? 0;
  }

  static int generateUniqueID() {
    final generatedID = _counter++;
    _counterBox.put('counter', _counter);
    return generatedID;
  }
}
Future<void> editproduct(int id, Productmodel updatedData) async {
  final productBox = await Hive.openBox<Productmodel>('product_db');
  final existingData = productBox.get(id);

  if (existingData != null) {
    existingData.productname = updatedData.productname;
    existingData.description = updatedData.description;
    existingData.image = updatedData.image;
    existingData.sellingrate = updatedData.sellingrate;
    existingData.purchaserate = updatedData.purchaserate;
    existingData.stock = updatedData.stock;
    existingData.categoryname = updatedData.categoryname;

    // Update the product in the Hive box
    productBox.put(id, existingData);

    // Update the product in the productListNotifier
    int index = productListNotifier.value.indexWhere((data) => data.id == id);
    if (index != -1) {
      productListNotifier.value[index] = existingData;
      productListNotifier.notifyListeners();
    }
  }
}

Future<void> deleteproduct(int id) async {
  final productBox = await Hive.openBox<Productmodel>('product_db');
  await productBox.delete(id);
 
  await productBox.close();
}

// Function to search products by name
Future<List<Productmodel>> searchProducts(String query) async {
  final productBox = await Hive.openBox<Productmodel>('product_db');
  final allProducts = productBox.values.toList();

  // Filter the products based on the search query
  final filteredProducts = allProducts.where((product) {
    return product.productname!.toLowerCase().contains(query.toLowerCase());
  }).toList();

  return filteredProducts;
}

Future<void> initCartBox() async {
  cartBox = await Hive.openBox<Productmodel>('cart_db');
  loadCartItems();
}

void loadCartItems() {
  cartListNotifier.value = cartBox.values.toList();
  cartListNotifier.notifyListeners(); // Notify listeners after loading cart items
}
class UserDataService {
  Future<Userdatamodel?> retrieveUserData() async {
    final box = Hive.box<Userdatamodel>('create_account');
    if (box.isNotEmpty) {
      // Assuming you want the first user or modify logic accordingly
      return box.getAt(0);
    }
    return null;
  }

}
 
final grandTotalNotifier = ValueNotifier<double>(0);
final dailyRevenueNotifier = ValueNotifier<double>(0);
final weeklyRevenueNotifier = ValueNotifier<double>(0);
final monthlyRevenueNotifier = ValueNotifier<double>(0);

void updateGrandTotal(Box<InvoiceModel> invoiceBox) {
  double newTotal = invoiceBox.values.fold(
    0.0,
    (sum, invoice) => sum + (invoice.totalAmount ?? 0),
  );
  grandTotalNotifier.value = newTotal;
}


void updateDailyRevenue(Box<InvoiceModel> invoiceBox) {
  final now = DateTime.now();
  double dailyTotal = 0.0;

  for (var invoice in invoiceBox.values) {
    final invoiceDate = invoice.purchaseDate; // Assuming `date` is a `DateTime` in `InvoiceModel`
    if (invoiceDate != null && isSameDay(invoiceDate, now)) {
      dailyTotal += invoice.totalAmount ?? 0;
    }
  }

  dailyRevenueNotifier.value = dailyTotal;
}

void updateWeeklyRevenue(Box<InvoiceModel> invoiceBox) {
  final now = DateTime.now();
  double weeklyTotal = 0.0;

  for (var invoice in invoiceBox.values) {
    final invoiceDate = invoice.purchaseDate; // Assuming `date` is a `DateTime` in `InvoiceModel`
    if (invoiceDate != null && isSameWeek(invoiceDate, now)) {
      weeklyTotal += invoice.totalAmount ?? 0;
    }
  }

  weeklyRevenueNotifier.value = weeklyTotal;
}

void updateMonthlyRevenue(Box<InvoiceModel> invoiceBox) {
  final now = DateTime.now();
  double monthlyTotal = 0.0;

  for (var invoice in invoiceBox.values) {
    final invoiceDate = invoice.purchaseDate; // Assuming `date` is a `DateTime` in `InvoiceModel`
    if (invoiceDate != null && isSameMonth(invoiceDate, now)) {
      monthlyTotal += invoice.totalAmount ?? 0;
    }
  }

  monthlyRevenueNotifier.value = monthlyTotal;
}

// Helper functions
bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
}

bool isSameWeek(DateTime date, DateTime reference) {
  final firstDayOfWeek = reference.subtract(Duration(days: reference.weekday - 1));
  final lastDayOfWeek = firstDayOfWeek.add(Duration(days: 6));
  return date.isAfter(firstDayOfWeek.subtract(Duration(seconds: 1))) &&
         date.isBefore(lastDayOfWeek.add(Duration(seconds: 1)));
}

bool isSameMonth(DateTime date1, DateTime date2) {
  return date1.year == date2.year && date1.month == date2.month;
}
