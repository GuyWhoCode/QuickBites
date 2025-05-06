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
              "My Account",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    authProvider.deleteAccount();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const AuthPage()),
                    );
                  },
                  child: const Text("Delete Account"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Reminder Duration: ", style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value:
                      authProvider.currentUser?.restaurantReminderDuration !=
                                  null &&
                              ![
                                432000000,
                                604800000,
                                1209600000,
                                1814400000,
                                2592000000,
                              ].contains(
                                authProvider
                                    .currentUser
                                    ?.restaurantReminderDuration,
                              )
                          ? -1 // Set to custom if current duration doesn't match preset values
                          : authProvider
                                  .currentUser
                                  ?.restaurantReminderDuration ??
                              604800000,
                  items: [
                    const DropdownMenuItem(
                      value: 432000000, // 5 days in milliseconds
                      child: Text("5 Days"),
                    ),
                    const DropdownMenuItem(
                      value: 604800000, // 7 days in milliseconds
                      child: Text("Weekly"),
                    ),
                    const DropdownMenuItem(
                      value: 1209600000, // 14 days in milliseconds
                      child: Text("Every 2 Weeks"),
                    ),
                    const DropdownMenuItem(
                      value: 1814400000, // 21 days in milliseconds
                      child: Text("Every 3 Weeks"),
                    ),
                    const DropdownMenuItem(
                      value: 2592000000, // 30 days in milliseconds
                      child: Text("Monthly"),
                    ),
                    const DropdownMenuItem(
                      value: -1, // Special value for custom duration
                      child: Text("Custom..."),
                    ),
                  ],
                  onChanged: (value) async {
                    if (value == -1) {
                      // Show dialog for custom duration
                      final textFieldController = TextEditingController();
                      final result = await showDialog<int>(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text('Custom Duration'),
                              content: TextField(
                                controller: textFieldController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Number of days',
                                  hintText: 'Enter number of days',
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    final days = int.tryParse(
                                      textFieldController.text,
                                    );

                                    if (days != null) {
                                      final duration =
                                          days * 24 * 60 * 60 * 1000;
                                      context
                                          .read<AuthStateProvider>()
                                          .updateReminderDuration(duration);
                                      Navigator.of(context).pop(duration);
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Invalid input!'),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text('Submit'),
                                ),
                              ],
                            ),
                      );

                      if (result != null) {
                        context
                            .read<AuthStateProvider>()
                            .updateReminderDuration(result);
                      }
                    } else if (value != null) {
                      context.read<AuthStateProvider>().updateReminderDuration(
                        value,
                      );
                    }
                  },
                ),
              ],
            ),
            // ...existing code...,
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
