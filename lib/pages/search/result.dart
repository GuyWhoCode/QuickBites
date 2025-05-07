import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickbites/image_cache.dart';
import 'package:quickbites/models/restaurant.dart';
import 'package:quickbites/pages/login/page.dart';
import 'package:quickbites/providers/auth_provider.dart';

class SearchResultBox extends StatefulWidget {
  final String restaurantName;
  final String address;
  final String photoID;
  final double rating;

  const SearchResultBox({
    super.key,
    required this.restaurantName,
    required this.address,
    required this.photoID,
    required this.rating,
  });

  @override
  State<SearchResultBox> createState() => _SearchResultBoxState();
}

class _SearchResultBoxState extends State<SearchResultBox> {
  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthStateProvider>();
    bool _isAdded = authProvider.checkExistingRestaurant(
      Restaurant(
        name: widget.restaurantName,
        address: widget.address,
        addedAt: DateTime.now().millisecondsSinceEpoch,
        photoID: widget.photoID,
      ),
    );

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
                Row(
                  children: [
                    Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      widget.rating!.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(), // This pushes the add button to the right
                _isAdded
                    ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                    )
                    : TextButton(
                      child: const Text('Add'),
                      onPressed: () async {
                        // ...existing onPressed code...
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
