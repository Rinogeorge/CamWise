import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rinosfirstproject/functions/db_functions.dart';
import 'package:rinosfirstproject/functions/model.dart';

class MyAddnewcatgrs extends StatefulWidget {
  const MyAddnewcatgrs({super.key});

  @override
  State<MyAddnewcatgrs> createState() => _MyAddnewcatgrsState();
}

class _MyAddnewcatgrsState extends State<MyAddnewcatgrs> {
  File? _image;
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4AAEE7), // Using the same color as the category page
        title: const Text(
          'Add Categories',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              _buildImagePicker(),
              const SizedBox(height: 30),
              _buildNameInput(),
              const SizedBox(height: 30),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _getImage,
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
          child: _image != null
              ? Image.file(
                  _image!,
                  width: 300,
                  height: 200,
                  fit: BoxFit.cover,
                )
              : Container(
                  color: Colors.grey[300],
                  width: 300,
                  height: 200,
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

  Widget _buildNameInput() {
    return SizedBox(
      width: 280,
      height: 50,
      child: TextFormField(
        controller: _nameController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Category Name',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Align(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          backgroundColor: const Color(0xFF4AAEE7),
          foregroundColor: Colors.white,
          onPressed: () {
            _savecategory();
            Navigator.pop(context);
          },
          shape: const CircleBorder(),
          child: const Icon(
            Icons.save,
            size: 28,
          ),
        ),
      ),
    );
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _savecategory() async {
    final name = _nameController.text;
    final image = _image?.path;
    if (image != null && name.isNotEmpty) {
      final category = Categorymodel(imagepath: image, categoryname: name);
      await addCategory(category);

      setState(() {
        _image = null;
        _nameController.clear();
      });
    }
  }
}
