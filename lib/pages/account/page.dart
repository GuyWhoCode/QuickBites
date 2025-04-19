import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickbites/image_cache.dart';
import 'package:quickbites/pages/login/page.dart';
import 'package:quickbites/providers/auth_provider.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthStateProvider>();

    if (authProvider.currentUser == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthPage()),
      );
    }

    return Card(
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            const Icon(Icons.account_circle, size: 100, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              "Account",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                authProvider.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthPage()),
                );
              },
              child: const Text("Logout"),
            ),
            const SizedBox(height: 16),
            Text(
              "My Saved Restaurants",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child:
                  authProvider.currentUser?.favoriteRestaurants.isEmpty ?? true
                      ? const Center(child: Text('No restaurants added yet!'))
                      : ListView.builder(
                        itemCount:
                            authProvider
                                .currentUser
                                ?.favoriteRestaurants
                                .length ??
                            0,
                        itemBuilder: (context, index) {
                          final restaurant =
                              authProvider
                                  .currentUser!
                                  .favoriteRestaurants[index];
                          return FutureBuilder<File?>(
                            future: RestaurantImageCache.getImage(
                              restaurant.photoID,
                            ),
                            builder: (context, snapshot) {
                              return ListTile(
                                leading:
                                    snapshot.data != null
                                        ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Image.file(
                                            snapshot.data!,
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                        : const Icon(Icons.restaurant),
                                title: Text(restaurant.name),
                                subtitle: Text(restaurant.address),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    context
                                        .read<AuthStateProvider>()
                                        .removeFavoriteRestaurant(restaurant);
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
