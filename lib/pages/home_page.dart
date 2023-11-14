import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'device_details_page.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ScanResult> scanResults = [];

  void _startScan() {
    setState(() {
      scanResults = [];
    });
    FlutterBluePlus.startScan(timeout: Duration(seconds: 4));

    FlutterBluePlus.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        if (!scanResults.contains(result)) {
          setState(() {
            scanResults.add(result);
          });
        }
      }
    });

    Future.delayed(Duration(seconds: 5), () {
      FlutterBluePlus.stopScan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BLE Tarayıcı'),
      ),

      body: ListView.builder(
        itemCount: scanResults.length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListTile(
              title: Text(scanResults[index].device.name ?? 'Unknown'),
              subtitle: Text(scanResults[index].device.id.toString()),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeviceDetailsPage(scanResults[index].device),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startScan,
        tooltip: 'Taramayı Başlat',
        child: Icon(Icons.search),
      ),
    );
  }
}

//Beacon beacon1 = Beacon(uuid: 'B9407F30-F5F8-466E-AFF9-25556B57FE6D', majorId: 1, minorId: 1);
//Beacon beacon2 = Beacon(uuid: '00000000-0000-0000-0000-000000000000', majorId: 2, minorId: 2);