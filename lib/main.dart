import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'bluetooth_off_screen.dart';
import 'navbar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;

  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;

  @override
  void initState() {
    super.initState();
    _adapterStateStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _adapterStateStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget screen = _adapterState == BluetoothAdapterState.on
        ? const NavBar()
        : BluetoothOffScreen(adapterState: _adapterState);

    return MaterialApp(
      color: Colors.lightBlue,
      home: screen,
      navigatorObservers: [BluetoothAdapterStateObserver()],
    );
  }
}

class BluetoothAdapterStateObserver extends NavigatorObserver {
  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name == '/DeviceScreen') {
      // Start listening to Bluetooth state changes when a new route is pushed
      _adapterStateSubscription ??= FlutterBluePlus.adapterState.listen((state) {
        if (state != BluetoothAdapterState.on) {
          // Pop the current route if Bluetooth is off
          navigator?.pop();
        }
      });
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    // Cancel the subscription when the route is popped
    _adapterStateSubscription?.cancel();
    _adapterStateSubscription = null;
  }
}





/*
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Indoor Navigation'),
        ),
        body: BeaconApp(),
      ),
    );
  }
}

class BeaconApp extends StatefulWidget {
  @override
  _BeaconAppState createState() => _BeaconAppState();
}

class _BeaconAppState extends State<BeaconApp> {
  StreamSubscription<dynamic>? _streamSubscription;
  List<double>? _userPosition;
  List<double>? _beaconPositions;

  @override
  void initState() {
    super.initState();
    _streamSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _userPosition = <double>[event.x, event.y, event.z];
      });
    });
    _beaconPositions = List<double>.generate(5, (index) => index * 5);
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _beaconPositions!.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text('Beacon ${index + 1}'),
          subtitle: Text(
            'Distance: ${_userPosition == null ? 'Calculating...' : _calculateDistance(_userPosition!, _beaconPositions![index]).toStringAsFixed(2)} meters',
          ),
        );
      },
    );
  }

  double _calculateDistance(List<double> userPosition, double beaconPosition) {
    double sum = 0;
    for (int i = 0; i < userPosition.length; i++) {
      sum += pow(userPosition[i] - beaconPosition, 2);
    }
    return sqrt(sum);
  }
}
*/