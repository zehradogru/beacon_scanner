import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DevicesPage extends StatelessWidget {
  final List<BluetoothDevice> devices;

  DevicesPage({required this.devices});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Taranan Beaconlar')),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(devices[index].name),
            subtitle: Text(devices[index].id.toString()),
          );
        },
      ),
    );
  }
}


/*
import 'package:beacon_project/scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DevicesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Beacon Tarayıcı')),
        body: FutureBuilder<List<ScanResult>>(
          future: Scan.scanDevices(),
          builder: (BuildContext context, AsyncSnapshot<List<ScanResult>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (BuildContext context, int index) {
                  ScanResult result = snapshot.data[index];
                  return ListTile(
                    title: Text('${result.device.remoteId}: "${result.advertisementData.localName}"'),
                    subtitle: Text('${result.rssi} dBm'),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}*/