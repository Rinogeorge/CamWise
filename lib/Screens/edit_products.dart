import 'dart:io';


import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rinosfirstproject/functions/db_functions.dart';
import 'package:rinosfirstproject/functions/model.dart';
import 'package:rinosfirstproject/widgets/textform.dart';
 

// ignore: must_be_immutable
class Myeditproducts extends StatefulWidget {
  final String categoryid; // Change the type to String
  final Productmodel data;

  const Myeditproducts({required this.categoryid, required this.data, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddproductState createState() => _AddproductState();
}

class _AddproductState extends State<Myeditproducts> {
  File? image;

  late TextEditingController productnamecontroller;
  late TextEditingController categorynaemcontroller;
  late TextEditingController descriptioncontroller;
  late TextEditingController sellingratecontroller;
  late TextEditingController purchaseratecontroller;
  late TextEditingController stockcontroller;

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();

    productnamecontroller =
        TextEditingController(text: widget.data.productname);
    descriptioncontroller =
        TextEditingController(text: widget.data.description);
    purchaseratecontroller =
        TextEditingController(text: widget.data.purchaserate.toString());
    categorynaemcontroller =
        TextEditingController(text: widget.data.categoryname);
    if (widget.data.stock == null) {
      stockcontroller = TextEditingController(text: '');
    } else {
      stockcontroller =
          TextEditingController(text: widget.data.stock.toString());
    }
    sellingratecontroller =
        TextEditingController(text: widget.data.sellingrate.toString());
    if (widget.data.image?.isNotEmpty == true) {
      image = File(widget.data.image!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit product'),
        backgroundColor:  Colors.blueAccent,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: GestureDetector(
                      onTap: addimage,
                      child: Container(
                        height: 200,
                        width: 200,
                        color: Colors.black,
                        child: image != null
                            ? Image.file(
                                image!,
                                fit: BoxFit.cover,
                              )
                            : null,
                      )),
                ),
                const SizedBox(height: 40),
                BuildTextFormField1(
                    controller: productnamecontroller,
                    labelText: 'Product name'),
                const SizedBox(height: 20),
                BuildTextFormField1(
                    controller: categorynaemcontroller,
                    labelText: 'Category name'),
                const SizedBox(height: 20),
                BuildTextFormField1(
                    controller: descriptioncontroller,
                    labelText: 'Description'),
                const SizedBox(height: 20),
                BuildTextFormField2(
                    controller: sellingratecontroller,
                    labelText: 'Selling Rate'),
                const SizedBox(height: 20),
                BuildTextFormField2(
                    controller: purchaseratecontroller,
                    labelText: 'Purchase Rate'),
                const SizedBox(
                  height: 20,
                ),
                BuildTextFormField2(
                    controller: stockcontroller, labelText: 'Stock quantity'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(50),
                      child: IconButton(
                          onPressed: () {
                            onsave();
                            
                          },
                          icon: const Icon(
                            Icons.save,
                            size: 40,
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addimage() async {
    final picker = ImagePicker();
    final pickedfile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedfile != null) {
      setState(() {
        image = File(pickedfile.path);
      });
    }
  }

 Future<void> onsave() async {
  final title = categorynaemcontroller.text.trim();
  final des = descriptioncontroller.text.trim();
  final pRate = purchaseratecontroller.text.trim();
  final sRate = sellingratecontroller.text.trim();
  final product = productnamecontroller.text.trim();
  final stock = stockcontroller.text.trim();

  if (title.isEmpty || des.isEmpty) {
    return;
  }
  final id = widget.data.id;
  if (id == null) {
    return;
  }
  final updatedproduct = Productmodel(
      image: image?.path ?? '',
      productname: product,
      categoryname: title,
      description: des,
      sellingrate: int.parse(sRate),
      purchaserate: int.parse(pRate),
      stock: int.parse(stock));
  editproduct(id, updatedproduct);
  
  // Pop and pass true to indicate the product was edited
  Navigator.pop(context, true);
}

}