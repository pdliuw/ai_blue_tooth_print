import 'dart:async';

import 'package:ai_blue_tooth_print/ai_blue_tooth_print_interface.dart';
import 'package:ai_blue_tooth_print/scan_bluetooth_device_result_callback.dart';

///
/// AiBlueToothPrint
class AiBlueToothPrint {
  ///
  /// print
  static Future<String> print({
    List<String> arrayInfo,
  }) async {
    return AiBlueToothPrintPlatform.instance.print(arrayInfo: arrayInfo);
  }

  ///
  /// printZebra
  static Future<String> printZebra({
    List<String> arrayInfo,
  }) async {
    return AiBlueToothPrintPlatform.instance.printZebra(arrayInfo: arrayInfo);
  }

  static scanBluetoothDeviceResultCallback({
    ScanBluetoothDeviceResultCallback callback,
  }) {
    AiBlueToothPrintPlatform.instance.scanBluetoothDeviceResultCallback =
        callback;
  }

  static scanBluetooth() {
    AiBlueToothPrintPlatform.instance.scanBluetooth();
  }

  static connectBluetooth({String mac}) {
    AiBlueToothPrintPlatform.instance.connectBluetooth(mac: mac);
  }
}
