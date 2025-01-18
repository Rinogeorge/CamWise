import 'package:flutter/material.dart';
import 'package:rinosfirstproject/functions/cart_db.dart';
import 'package:rinosfirstproject/functions/model.dart';

class ProductSearchDelegate extends SearchDelegate {
  final Function(Productmodel) onSearch;

  ProductSearchDelegate({required this.onSearch});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, color: Colors.black),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.black),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.blue, // Customize primary color
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontSize: 14, color: Colors.green),
        ),
      ),
      child: FutureBuilder<List<Productmodel>>(
        future: ProductDatabase.searchProductsByName(query),
        builder: (BuildContext context, AsyncSnapshot<List<Productmodel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found', style: TextStyle(color: Colors.grey)));
          }

          final searchResults = snapshot.data!;

          return ListView.builder(
            itemCount: searchResults.length,
            itemBuilder: (BuildContext context, int index) {
              final product = searchResults[index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(product.image ?? 'https://via.placeholder.com/150'),
                  ),
                  title: Text(
                    product.productname ?? 'Unnamed Product',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(
                    '₹ ${product.sellingrate ?? 0}',
                    style: const TextStyle(fontSize: 14, color: Colors.green),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_shopping_cart, color: Colors.blue),
                    onPressed: () {
                      onSearch(product);
                      close(context, null);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.blue, // Customize primary color
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontSize: 14, color: Colors.green),
        ),
      ),
      child: FutureBuilder<List<Productmodel>>(
        future: ProductDatabase.getAllProducts(),
        builder: (BuildContext context, AsyncSnapshot<List<Productmodel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found', style: TextStyle(color: Colors.grey)));
          }

          final suggestions = snapshot.data!
              .where((product) => product.productname!.toLowerCase().contains(query.toLowerCase()))
              .toList();

          return ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (BuildContext context, int index) {
              final product = suggestions[index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(product.image ?? 'https://via.placeholder.com/150'),
                  ),
                  title: Text(
                    product.productname ?? 'Unnamed Product',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(
                    '₹ ${product.sellingrate ?? 0}',
                    style: const TextStyle(fontSize: 14, color: Colors.green),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_shopping_cart, color: Colors.blue),
                    onPressed: () {
                      onSearch(product);
                      close(context, null);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
