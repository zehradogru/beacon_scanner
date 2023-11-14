import 'package:flutter/material.dart';

class LocationPage extends StatelessWidget {
  const LocationPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konum'),
      ),
      body: Center(
        child: Container(
          width: 300,
          height: 500,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
