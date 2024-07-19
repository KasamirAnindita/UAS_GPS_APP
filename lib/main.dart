import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Display Demo',
      home: LocationScreen(),
    );
  }
}

class LocationScreen extends StatelessWidget {
  final double _latitude = -6.200000;
  final double _longitude = 106.816666;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Display Demo'),
      ),
      body: Center(
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height / 2 - 20,
              left: MediaQuery.of(context).size.width / 2 - 20,
              child: Icon(
                Icons.location_pin,
                color: Colors.redAccent,
                size: 40.0,
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: Text(
                'Latitude: $_latitude\nLongitude: $_longitude',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
