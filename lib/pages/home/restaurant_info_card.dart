import 'dart:io';
import 'package:flutter/material.dart';

class RestaurantInfoCard extends StatelessWidget {
  final String restaurantName;
  final String address;
  final File? imageFile;
  RestaurantInfoCard({
    super.key,
    required this.restaurantName,
    required this.address,
    required this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white70,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 16),
          imageFile != null
              ? SizedBox(
                width: 200,
                height: 200,
                child: Image.file(imageFile!, fit: BoxFit.cover),
              )
              : const SizedBox(
                width: 200,
                height: 200,
                child: Icon(Icons.restaurant),
              ),
          Text(restaurantName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(address),
        ],
      ),
    );
  }
}
