import 'package:beacon_project/pages/device_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Services extends StatelessWidget {
  final List<BluetoothService> services;

  Services({required this.services});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Servisler ve Karakteristikler'),
      ),
      body: ListView.builder(
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return ExpansionTile(
            title: Text(service.uuid.toString()),
            children: service.characteristics.map((characteristic) {
              final beacon = Beacon(characteristic: characteristic, uuid: characteristic.uuid.toString(), majorId: 0, minorId: 0);
              return Column(
                children: [
                  ListTile(
                    title: Text(characteristic.uuid.toString()),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            beacon.readCharacteristics(service);
                          },
                          child: Text('Oku', style: TextStyle(color: Colors.white)),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            beacon.writeCharacteristic(characteristic, [0x01]);
                          },
                          child: Text('Yaz', style: TextStyle(color: Colors.white)),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            beacon.subscribeToCharacteristic(characteristic);
                          },
                          child: Text('Sub', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
