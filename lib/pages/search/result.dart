import 'package:flutter/material.dart';

class SearchResultBox extends StatelessWidget {
  final String restaurantName;
  final String address;
  final String placeID;

  SearchResultBox({
    super.key,
    required this.restaurantName,
    required this.address,
    required this.placeID,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(
                restaurantName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(address),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('Add'),
                  onPressed: () {
                    print('ADD Pressed');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
