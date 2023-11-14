import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Scan {

  static void scanDevices() async {
    // Setup Listener for scan results.
    var subscription = FlutterBluePlus.scanResults.listen((results) {
      if (results.isNotEmpty) {
        ScanResult r = results.last; // the most recently found device
        print('${r.device.remoteId}: "${r.advertisementData.localName}" found!');
      }
    }, onError: (e) {
      print(e);
    });

    // Start scanning
    await FlutterBluePlus.startScan();

    // Wait 10 seconds before stopping the scan
    await Future.delayed(Duration(seconds: 10));

    // Stop scanning
    await FlutterBluePlus.stopScan();

    // cancel to prevent duplicate listeners
    subscription.cancel();
  }
}