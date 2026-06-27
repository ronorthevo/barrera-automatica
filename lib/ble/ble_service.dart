import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleService {

  Future<List<ScanResult>> scanDevices() async {

    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    final results = await FlutterBluePlus.scanResults.first;

    await FlutterBluePlus.stopScan();

    return results;
  }
}