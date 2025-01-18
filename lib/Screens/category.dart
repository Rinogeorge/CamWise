import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rinosfirstproject/Screens/add_category.dart';
import 'package:rinosfirstproject/Screens/edit_category.dart';
import 'package:rinosfirstproject/Screens/products.dart';
import 'package:rinosfirstproject/functions/db_functions.dart';
import 'package:rinosfirstproject/functions/model.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => CategoriesPageState();
}

class CategoriesPageState extends State<CategoriesPage> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  List<Categorymodel> filteredCategories(
      List<Categorymodel> categoryList, String query) {
    return categoryList
        .where((category) =>
            category.categoryname.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4AAEE7),
        title: const Text(
          'Categories',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
  Padding(
  padding: const EdgeInsets.all(12.0),
  child: Container(
    decoration: BoxDecoration(
      color: const Color(0xFFF0F4F8), // Light background color similar to the image
      borderRadius: BorderRadius.circular(30), // More rounded corners for the search bar
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3), // Light shadow for the search bar
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3), // Shadow position
        ),
      ],
    ),
    child: TextFormField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: 'Search Categories',
        hintStyle: const TextStyle(color: Colors.grey),
        border: InputBorder.none, // Removing the border
        prefixIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF4AAEE7), // Circle background for the icon
            ),
            child: const Icon(Icons.search, color: Colors.white),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20), // More padding for the input text
      ),
      onChanged: (value) {
        setState(() {});
      },
    ),
  ),
),

          Expanded(
            child: ValueListenableBuilder(
              valueListenable: categoryListNotifier,
              builder: (BuildContext context, List<Categorymodel> categoryList,
                  Widget? child) {
                List<Categorymodel> displayedCategories =
                    filteredCategories(categoryList, searchController.text);

                if (displayedCategories.isEmpty) {
                  return const Center(
                    child: Text(
                      'No categories found',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: displayedCategories.length,
                  itemBuilder: (context, index) {
                    final category = displayedCategories[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Myproduct(
                              productListNotifier: productListNotifier,
                              data: category,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(15)),
                                child: Image.file(
                                  File(category.imagepath),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(                                   
                                    child: Text(
                                      category.categoryname,
                                      style: const TextStyle(
                                          
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Color(0xFF4AAEE7)),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => Myeditctgry(
                                                category: category,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.redAccent),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    "Delete Category"),
                                                content: const Text(
                                                    "Are you sure you want to delete this category?"),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      if (category.id != null) {
                                                        await deletectgrs(
                                                            category.id!);
                                                        Navigator.of(context)
                                                            .pop();
                                                      } else {
                                                        print(
                                                            'Category ID is null');
                                                      }
                                                    },
                                                    child: const Text("Delete"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4AAEE7),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const MyAddnewcatgrs()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
