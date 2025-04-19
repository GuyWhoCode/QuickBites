import 'package:flutter/material.dart';
import 'package:quickbites/pages/search/search_bar.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.fromLTRB(0.0, 60.0, 0.0, 0.0),
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: RestaurantSearchBar(),
      ),
    );
  }
}
