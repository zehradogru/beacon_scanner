import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../services.dart';

class DeviceDetailsPage extends StatefulWidget {
  final BluetoothDevice device;
  DeviceDetailsPage(this.device);

  @override
  _DeviceDetailsPageState createState() => _DeviceDetailsPageState();
}

class _DeviceDetailsPageState extends State<DeviceDetailsPage> {
  bool isDeviceConnected = false;
  int mtu = 0;
// Reads all characteristics

  Future<void> discoverServices() async {
    List<BluetoothService> service = await widget.device.discoverServices();
    service.forEach((service) {
      // do something with service
    });
  }


  @override
  void initState() {
    super.initState();
    widget.device.connectionState.listen((BluetoothConnectionState state) {
      if (state == BluetoothConnectionState.connected) {
        setState(() {
          isDeviceConnected = true;
        });

        widget.device.requestMtu(512).then((value) {
          setState(() {
            mtu = value;
          });
        });
      } else if (state == BluetoothConnectionState.disconnected) {
        setState(() {
          isDeviceConnected = false;
        });
      }
    });
    discoverServices();
  }

  void connectToDevice() async {
    try {
      await widget.device.connect();
    } catch (e) {
      print("Bağlantı hatası: $e");
    }
  }

  void disconnectDevice() {
    widget.device.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cihaz Detayları'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Cihaz id: ${widget.device.id.toString()}'),
            //Text('Major:'),
            //Text('Minor:'),
            SizedBox(height: 20),
            if (isDeviceConnected)
              Column(
                children: [
                  Text('MTU Değeri: $mtu'), // MTU değerini ekrana yazdır
                  SizedBox(height: 20),
                  Text('Cihaz Şu Anda Bağlı'),
                ],
              ),

            ElevatedButton(
              onPressed: () {
                if (!isDeviceConnected) {
                  connectToDevice();
                } else {
                  disconnectDevice();
                }
              },
              child: Text(isDeviceConnected ? 'Bağlantıyı Kes' : 'Bağlan'),
            ),
            ElevatedButton(
              onPressed: () async {
                List<BluetoothService> services = await widget.device.discoverServices();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Services(services: services),
                  ),
                );
              }, child: Text('Servisleri Getir'),

            ),

          ],
        ),
      ),
    );
  }
}

class Beacon {
  BluetoothCharacteristic characteristic;
  String uuid;
  int majorId;
  int minorId;

  Beacon({required this.characteristic, required this.uuid, required this.majorId, required this.minorId});


  Future<void> readCharacteristics(BluetoothService service) async {
    // Reads all characteristics
    var characteristics = service.characteristics;
    for (BluetoothCharacteristic c in characteristics) {
      if (c.properties.read) {
        List<int> value = await c.read();
        print(value);
      }
    }
  }

  void writeCharacteristic(BluetoothCharacteristic c, List<int> data) async {
    await c.write([0x12, 0x34]);
    await c.write(data, allowLongWrite: true);
  }

  void subscribeToCharacteristic(BluetoothCharacteristic characteristic) async {
    final chrSubscription = characteristic.onValueReceived.listen((value) {
      // onValueReceived is updated:
      //   - anytime read() is called
      //   - anytime a notification arrives (if subscribed)
    });

    // cleanup: cancel subscription when disconnected
    characteristic.device.cancelWhenDisconnected(chrSubscription);

    // enable notifications
    await characteristic.setNotifyValue(true);
  }

  void readAndWriteDescriptors(BluetoothCharacteristic characteristic) async {
    // Reads all descriptors
    var descriptors = characteristic.descriptors;
    for (BluetoothDescriptor d in descriptors) {
      List<int> value = await d.read();
      print(value);
    }

    // Writes to a descriptor
    if (descriptors.isNotEmpty) {
      var d = descriptors.first;
      await d.write([0x12, 0x34]);
    }
  }
}

