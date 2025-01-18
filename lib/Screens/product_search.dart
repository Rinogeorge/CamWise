
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
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Perform the search based on the product name
    return FutureBuilder<List<Productmodel>>(
      future: ProductDatabase.searchProductsByName(query),  
      builder: (BuildContext context, AsyncSnapshot<List<Productmodel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No products found'));
        }

        final searchResults = snapshot.data!;

        return ListView.builder(
          itemCount: searchResults.length,
          itemBuilder: (BuildContext context, int index) {
            final product = searchResults[index];

            return ListTile(
              title: Text(product.productname ?? 'Unnamed Product'),
              subtitle: Text('₹ ${product.sellingrate ?? 0}'),
              onTap: () {
                onSearch(product);  // Add to cart when tapped
                close(context, null);  // Close the search view
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Productmodel>>(
      future: ProductDatabase.getAllProducts(),  // You can show all products as suggestions if desired
      builder: (BuildContext context, AsyncSnapshot<List<Productmodel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No products found'));
        }

        final suggestions = snapshot.data!
            .where((product) => product.productname!.toLowerCase().contains(query.toLowerCase()))
            .toList();

        return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (BuildContext context, int index) {
            final product = suggestions[index];

            return ListTile(
              title: Text(product.productname ?? 'Unnamed Product'),
              subtitle: Text('₹ ${product.sellingrate ?? 0}'),
              onTap: () {
                onSearch(product);  // Add to cart when tapped
                close(context, null);  // Close the search view
              },
            );
          },
        );
      },
    );
  }
}

