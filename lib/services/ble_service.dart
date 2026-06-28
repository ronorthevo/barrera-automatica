import 'dart:async';
import 'dart:convert';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleService {

  static final BleService _instance = BleService._internal();

  factory BleService() => _instance;

  BleService._internal();

  static const serviceUuid =
      "6E400001-B5A3-F393-E0A9-E50E24DCCA9E";

  static const txUuid =
      "6E400003-B5A3-F393-E0A9-E50E24DCCA9E";

  static const rxUuid =
      "6E400002-B5A3-F393-E0A9-E50E24DCCA9E";

  BluetoothDevice? device;
  BluetoothCharacteristic? tx;
  BluetoothCharacteristic? rx;

  final StreamController<String> messages =
      StreamController.broadcast();

  Future<bool> connectToBarrier() async {

    await FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 5),
    );

    await for (final results in FlutterBluePlus.scanResults) {

      for (final r in results) {

        if (r.device.platformName == "Barrera automatica") {

          await FlutterBluePlus.stopScan();

          device = r.device;

          await device!.connect();

          List<BluetoothService> services =
              await device!.discoverServices();

          for (var s in services) {

            if (s.uuid.toString().toUpperCase() == serviceUuid) {

              for (var c in s.characteristics) {

                if (c.uuid.toString().toUpperCase() == txUuid) {

                  tx = c;

                  await tx!.setNotifyValue(true);

                  tx!.lastValueStream.listen((data) {

                    messages.add(
                      utf8.decode(data),
                    );

                  });

                }

                if (c.uuid.toString().toUpperCase() == rxUuid) {

                  rx = c;

                }

              }

            }

          }

          return true;

        }

      }

    }

    return false;

  }

  Future<void> sendWifi(
      String ssid,
      String password,
      ) async {

    if (rx == null) return;

    await rx!.write(
      utf8.encode("$ssid,$password"),
    );

  }

}