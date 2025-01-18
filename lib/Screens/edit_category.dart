// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:io';


import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rinosfirstproject/functions/db_functions.dart';
import 'package:rinosfirstproject/functions/model.dart';
class Myeditctgry extends StatefulWidget {
  final Categorymodel category;

  const Myeditctgry({required this.category, super.key});

  @override
  State<Myeditctgry> createState() => _MyeditctgryState();
}

class _MyeditctgryState extends State<Myeditctgry> {
  File? _image;

  TextEditingController namecontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    namecontroller.text = widget.category.categoryname;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit category'),
          backgroundColor: Colors.blueAccent,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(26),
              child: Column(
                children: [
                  GestureDetector(
                      onTap: () {
                        editimageselect().then((selectedimage) {
                          if (selectedimage != null) {
                            setState(() {
                              _image = selectedimage;
                            });
                          }
                        });
                      },
                      child: _image != null
                          ? Image.file(
                              _image!,
                              width: 220,
                              height: 190,
                            )
                          : Image.file(
                              File(widget.category.imagepath),
                              width: 220,
                              height: 190,
                            )),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 50,
                    width: 220,
                    child: TextFormField(
                      controller: namecontroller,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Category name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'please enter name';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(35),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () async {
                              Categorymodel? updatedcategory =
                                  await updatecategory();
                              // ignore: unrelated_type_equality_checks
                              if (updatedcategory != Null) {
                                Navigator.pop(context);
                              }
                            },
                            icon: const Icon(
                              Icons.save,
                              size: 40,
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Future<File?> editimageselect() async {
    final picker = ImagePicker();
    final pickedfile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedfile != null) {
      return File(pickedfile.path);
    } else {
      print('No image selected');
      return null;
    }
  }

  Future<Categorymodel?> updatecategory() async {
    if (_image != null) {
      String imagePath = _image!.path;
      String categoryName = namecontroller.text.trim();

      Categorymodel updatedCategory = Categorymodel(
        id: widget.category.id,
        imagepath: imagePath,
        categoryname: categoryName,
      );

      try {
        await updatectgrs(widget.category.id!, updatedCategory);

        return updatedCategory;
      } catch (e) {
        print('Error updating category: $e');
        // Handle error and inform the user
        return null;
      }
    }
    // Return null if the image is not updated
    return null;
  }
}
