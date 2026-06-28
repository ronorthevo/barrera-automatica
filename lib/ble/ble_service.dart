import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleService {
  BluetoothDevice? device;

  Future<bool> connectToBarrier() async {
    await FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 5),
    );

    await for (final results in FlutterBluePlus.scanResults) {
      for (final r in results) {
        if (r.device.platformName == "Barrera automatica") {
          await FlutterBluePlus.stopScan();

          device = r.device;

          await device!.connect(timeout: const Duration(seconds: 10));

          return true;
        }
      }
    }

    await FlutterBluePlus.stopScan();
    return false;
  }
}