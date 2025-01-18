// ignore_for_file: avoid_print
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rinosfirstproject/functions/db_functions.dart';
import 'package:rinosfirstproject/functions/model.dart';
import 'package:rinosfirstproject/widgets/textform.dart';
import 'package:rinosfirstproject/widgets/widget_addproduct.dart';

class Addproduct extends StatefulWidget {
  final String categoryname;

  const Addproduct({super.key, required this.categoryname});

  @override
  State<Addproduct> createState() => _AddproductState();
}

class Allproduct {
  static List<Productmodel> product = [];
}

class _AddproductState extends State<Addproduct> {
  String? selectedCategory;
  File? _imagee;

  final TextEditingController productnamecontroller = TextEditingController();
  final TextEditingController descriptioncontroller = TextEditingController();
  final TextEditingController sellingratecontroller = TextEditingController();
  final TextEditingController purchaseratecontroller = TextEditingController();
  final TextEditingController stockconteroller = TextEditingController();

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    getallproduct();

    _categories = [];
    _categories.add(widget.categoryname);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4AAEE7),
        title: const Text(
          'Add Product',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildImagePicker(),
                  const SizedBox(height: 20),
                  buildTextFormField(
                    controller: productnamecontroller,
                    labelText: 'Product name',
                  ),
                  const SizedBox(height: 20),
                  _buildCategoryDropdown(),
                  const SizedBox(height: 20),
                  buildTextFormField(
                    controller: descriptioncontroller,
                    labelText: 'Description',
                  ),
                  const SizedBox(height: 20),
                  buildTextFormField(
                    controller: sellingratecontroller,
                    labelText: 'Selling rate',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  buildTextFormField(
                    controller: purchaseratecontroller,
                    labelText: 'Purchase rate',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  buildTextFormField(
                    controller: stockconteroller,
                    labelText: 'Stock quantity',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 30),
                  _buildSaveButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: pickimage,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 6,
              spreadRadius: 2,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: _imagee != null
              ? Image.file(
                  _imagee!,
                  width: 300,
                  height: 170,
                  fit: BoxFit.cover,
                )
              : Container(
                  color: Colors.grey[300],
                  width: 300,
                  height: 170,
                  child: const Center(
                    child: Icon(
                      Icons.add_photo_alternate,
                      color: Colors.black54,
                      size: 50,
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return SizedBox(
      width: 340,
      child: DropdownButtonFormField<String>(
        value: selectedCategory,
        onChanged: (String? newValue) {
          setState(() {
            selectedCategory = newValue;
          });
        },
        items: _categories.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          labelText: 'Category name',
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a category';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: 300,
      child: ElevatedButton(
        onPressed: () {
          if (formkey.currentState!.validate()) {
            if (_imagee != null) {
              onsave();
              Navigator.pop(context);
            }
          }
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(Colors.black),
        ),
        child: const Text(
          'Save',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<void> pickimage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    print('"Image path: ${pickedFile.path}"');
    setState(() {
      _imagee = File(pickedFile.path);
    });
  }

  Future<void> onsave() async {
    final productName = productnamecontroller.text.trim();
    final category = widget.categoryname;
    final description = descriptioncontroller.text.trim();
    final sellingRate = sellingratecontroller.text.trim();
    final purchaseRate = purchaseratecontroller.text.trim();
    final stockquantity = stockconteroller.text.trim();

    if (productName.isEmpty ||
        category.isEmpty ||
        description.isEmpty ||
        sellingRate.isEmpty ||
        purchaseRate.isEmpty ||
        stockquantity.isEmpty) {
      return;
    }

    final data = Productmodel(
      image: _imagee?.path ?? '',
      productname: productName,
      categoryname: category,
      description: description,
      sellingrate: int.parse(sellingRate),
      purchaserate: int.parse(purchaseRate),
      stock: int.parse(stockquantity),
    );

    await addproducts(data, category);
    print('Product added successfully: $data');

    final notification = NotificationModel(
      title: 'New Product Added: $productName',
      timestamp: DateTime.now(),
      description: description,
    );

    var box = await Hive.openBox<NotificationModel>('notifications');
    await box.add(notification);

    setState(() {
      _imagee = null;
      productnamecontroller.clear();
      descriptioncontroller.clear();
      sellingratecontroller.clear();
      purchaseratecontroller.clear();
      stockconteroller.clear();
    });
  }
}
