import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickbites/env_vars.dart';
import 'package:quickbites/image_cache.dart';

class SearchResultBox extends StatefulWidget {
  final String restaurantName;
  final String address;
  final String photoID;

  const SearchResultBox({
    super.key,
    required this.restaurantName,
    required this.address,
    required this.photoID,
  });

  @override
  State<SearchResultBox> createState() => _SearchResultBoxState();
}

class _SearchResultBoxState extends State<SearchResultBox> {
  bool _isAdded = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(
                widget.restaurantName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(widget.address),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                _isAdded
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : TextButton(
                      child: const Text('Add'),
                      onPressed: () async {
                        // var db = FirebaseFirestore.instance;
                        // // Create a new user with a first and last name
                        // final user = <String, dynamic>{
                        //   "first": "Ada",
                        //   "last": "Lovelace",
                        //   "born": 1815,
                        // };

                        // // Add a new document with a generated ID
                        // db
                        //     .collection("users")
                        //     .add(user)
                        //     .then(
                        //       (DocumentReference doc) =>
                        //           print('DocumentSnapshot added with ID: ${doc.id}'),
                        //     );
                        print('ADD Pressed');
                        await RestaurantImageCache.storeImage(widget.photoID);
                        setState(() {
                          _isAdded = true;
                        });
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
