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
                        if (authProvider.currentUser == null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AuthPage(),
                            ),
                          );
                          return; // Add return to prevent further execution if user is not logged in
                        }

                        final newRestaurant = Restaurant(
                          name: widget.restaurantName,
                          address: widget.address,
                          photoID: widget.photoID,
                          addedAt: DateTime.now().millisecondsSinceEpoch,
                        );
                        authProvider.addFavoriteRestaurant(newRestaurant);

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
