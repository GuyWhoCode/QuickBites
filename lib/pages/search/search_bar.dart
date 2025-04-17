import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './result.dart';

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
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
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.',
    );
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

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
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
            determinePosition()
                .then((Position position) async {
                  var headers = {
                    'Content-Type': 'application/json',
                    'X-Goog-Api-Key': '',
                  };
                  var request = http.Request(
                    'POST',
                    Uri.parse(
                      'https://places.googleapis.com/v1/places:autocomplete',
                    ),
                  );
                  request.body = json.encode({
                    "input": value,
                    "locationBias": {
                      "circle": {
                        "center": {
                          "latitude": position.latitude,
                          "longitude": position.longitude,
                        },
                        "radius": 5000.0,
                      },
                    },
                  });
                  request.headers.addAll(headers);

                  http.StreamedResponse response = await request.send();

                  if (response.statusCode == 200) {
                    String result = await response.stream.bytesToString();
                    var jsonResponse = json.decode(result);

                    print(jsonResponse['suggestions'][0]['placePrediction']);
                    setState(() {
                      searchResults =
                          (jsonResponse['suggestions'] as List?)
                              ?.map(
                                (prediction) => SearchResultBox(
                                  restaurantName:
                                      prediction['placePrediction']['structuredFormat']?['mainText']?['text'] ??
                                      'Unknown',
                                  address:
                                      prediction['placePrediction']['structuredFormat']?['secondaryText']?['text'] ??
                                      'No address',
                                  placeID: prediction['placeId'] ?? '',
                                ),
                              )
                              .toList() ??
                          [];
                    });
                  }
                })
                .catchError((e) {
                  print(e);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error: $e')));
                });
          },
        ),
        Expanded(child: ListView(children: searchResults)),
      ],
    );
  }

  // ...existing dispose method...
}
