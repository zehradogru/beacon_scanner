import 'package:flutter/material.dart';

class ConnectedDevicesPage extends StatelessWidget {
  const ConnectedDevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bağlı Cihazlar'),
      ),
      body: Center(
        child: Text('Bağlı Cihazlar'),
      ),
    );
  }
}
