import 'dart:io';
import 'package:flutter/material.dart';

class RestaurantInfoCard extends StatelessWidget {
  final String restaurantName;
  final String address;
  final File? imageFile;
  final int lastEatenTimestamp;

  RestaurantInfoCard({
    super.key,
    required this.restaurantName,
    required this.address,
    required this.imageFile,
    required this.lastEatenTimestamp,
  });

  String _getLastEatenText() {
    final now = DateTime.now().millisecondsSinceEpoch;
    final differenceInDays =
        (now - lastEatenTimestamp) ~/ (1000 * 60 * 60 * 24);

    if (differenceInDays == 0) {
      return 'Eaten today';
    } else if (differenceInDays == 1) {
      return 'Eaten yesterday';
    } else {
      return 'Time to go back!';
    }
  }

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
          Text(
            restaurantName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(address),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                _getLastEatenText(),
                style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
