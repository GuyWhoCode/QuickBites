import 'package:flutter/material.dart';
import './search_bar.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.all(60.0),
      child: Scaffold(
        body: Column(
          children: <Widget>[
            RestaurantSearchBar(),
            Expanded(
              child: Center(
                child: Text(
                  'Search Page',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
