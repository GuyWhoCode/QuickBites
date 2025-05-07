import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:quickbites/env_vars.dart';
import 'dart:convert';
import 'package:quickbites/pages/search/result.dart';

Future<Position?> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return null;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return null;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return null;
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

class RestaurantSearchBar extends StatefulWidget {
  const RestaurantSearchBar({super.key});

  @override
  State<RestaurantSearchBar> createState() => _RestaurantSearchBarState();
}

class _RestaurantSearchBarState extends State<RestaurantSearchBar> {
  late TextEditingController _controller;
  List<Widget> searchResults = [];
  bool _isLoading = false;
  bool hasLocationPermission = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => hasLocationPermission = false);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() => hasLocationPermission = false);
    } else {
      setState(() => hasLocationPermission = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Search',
            prefixIcon: Icon(Icons.search_rounded),
          ),
          onSubmitted: (String value) async {
            setState(() {
              _isLoading = true;
              searchResults = [];
            });

            final position = await determinePosition();
            var headers = {
              'Content-Type': 'application/json',
              'X-Goog-Api-Key': GOOGLE_API_KEY,
              "X-Goog-FieldMask":
                  "places.displayName,places.formattedAddress,places.photos,places.rating",
            };

            var request = http.Request(
              'POST',
              Uri.parse('https://places.googleapis.com/v1/places:searchText'),
            );

            if (position == null) {
              request.body = json.encode({"textQuery": value, "pageSize": 8});
            } else {
              request.body = json.encode({
                "textQuery": value,
                "locationBias": {
                  "circle": {
                    "center": {
                      "latitude": position.latitude,
                      "longitude": position.longitude,
                    },
                    "radius": 5000.0,
                  },
                },
                "pageSize": 8,
              });
              setState(() {
                hasLocationPermission = true;
              });
            }

            request.headers.addAll(headers);

            final response = await request.send();

            if (response.statusCode == 200) {
              String result = await response.stream.bytesToString();
              var jsonResponse = json.decode(result);

              setState(() {
                _isLoading = false;
                searchResults =
                    (jsonResponse['places'] as List?)
                        ?.map(
                          (prediction) => SearchResultBox(
                            restaurantName:
                                prediction['displayName']['text'] ?? 'Unknown',
                            address:
                                prediction['formattedAddress'] ?? 'No address',
                            photoID: prediction['photos'][0]['name'] ?? '',
                            rating:
                                prediction['rating'] != null
                                    ? (prediction['rating'] as num).toDouble()
                                    : 0.0,
                          ),
                        )
                        .toList() ??
                    [];
              });
            }
          },
        ),
        hasLocationPermission
            ? const SizedBox(height: 10)
            : Column(
              children: [
                const Text(
                  'Location services are disabled. Please enable them to get better results.',
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () async {
                    await Geolocator.openLocationSettings();
                    await _checkLocationPermission();
                  },
                  icon: const Icon(Icons.location_on),
                  label: const Text('Enable Location Services'),
                ),
              ],
            ),
        Expanded(
          child:
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(children: searchResults),
        ),
      ],
    );
  }

  // ...existing dispose method...
}
