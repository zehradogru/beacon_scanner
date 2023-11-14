import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BeaconPositioning extends StatefulWidget {
  @override
  _BeaconPositioningState createState() => _BeaconPositioningState();
}

class _BeaconPositioningState extends State<BeaconPositioning> {
  //FlutterBluePlus flutterBlue = FlutterBluePlus();
  List<BluetoothDevice> devicesList = [];
  Map<BluetoothDevice, Beacon> beacons = {};

  @override
  void initState() {
    super.initState();
    initBluetooth();
  }

  void initBluetooth() {

    //flutterBlue.startScan(timeout: Duration(seconds: 4));
    FlutterBluePlus.startScan(timeout: Duration(seconds: 4));
    //flutterBlue.scanResults.listen((List<ScanResult> results) {
    FlutterBluePlus.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        if (devicesList.contains(result.device)) continue;
        devicesList.add(result.device);
        result.device.discoverServices().then((value) {
          value.forEach((service) {
            service.characteristics.forEach((characteristic) {
              if (characteristic.uuid.toString() == '0000feaa-0000-1000-8000-00805f9b34fb') {
                beacons[result.device] = Beacon(characteristic);
              }
            });
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beacon Positioning'),
      ),
      body: Column(
        children: [
          Text('Devices Found: ${devicesList.length}'),
          Expanded(
            child: ListView.builder(
              itemCount: devicesList.length,
              itemBuilder: (context, index) {
                BluetoothDevice device = devicesList[index];
                Beacon? beacon = beacons[device];
                return ListTile(
                  title: Text('${device.name}'),
                  subtitle: Text('Major: ${beacon?.major}, Minor: ${beacon?.minor}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Beacon {
  BluetoothCharacteristic characteristic;
  int major = 0; // Varsayılan değeri belirleyin
  int minor = 0; // Varsayılan değeri belirleyin

  Beacon(this.characteristic) {
    characteristic.read().then((value) {
      major = value[4];
      minor = value[5];
    });
  }
}
