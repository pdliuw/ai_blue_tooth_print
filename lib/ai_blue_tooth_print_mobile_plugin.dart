import 'package:ai_blue_tooth_print/bluetooth_device.dart';
import 'package:flutter/services.dart';

import 'ai_blue_tooth_print_interface.dart';

///
/// AiBlueToothPrintMobilePlugin
class AiBlueToothPrintMobilePlugin extends AiBlueToothPrintPlatform {
  AiBlueToothPrintMobilePlugin() {}

  Future<dynamic> _handler(MethodCall call) {
    String method = call.method;
    dynamic arguments = call.arguments;

    switch (method) {
      case "scanBluetoothDeviceResultStart":
        bluetoothDeviceList.clear();
        break;
      case "scanBluetoothDeviceResult":
        String name = arguments['name'];
        String ip = arguments['ip'];
        String mac = arguments['mac'];
        bluetoothDeviceList
            .add(BluetoothDevice.defaultStyle(name: name, ip: ip, mac: mac));
        break;
      case "scanBluetoothDeviceResultEnd":
        scanBluetoothDeviceResultCallback.successCallback(bluetoothDeviceList);
        break;
      default:
    }

    return Future.delayed(Duration(seconds: 1));
  }

  @override
  Future<String> print({List<String> arrayInfo}) async {
    arrayInfo = arrayInfo ?? [];
    return await AiBlueToothPrintPlatform.instance.methodChannel
        .invokeMethod('print', {
      "info": arrayInfo,
    });
  }

  @override
  Future<String> printZebra({List<String> arrayInfo}) async {
    arrayInfo = arrayInfo ?? [];
    return await AiBlueToothPrintPlatform.instance.methodChannel
        .invokeMethod('printZebra', {
      "info": arrayInfo,
    });
  }

  @override
  void scanBluetooth() {
    AiBlueToothPrintPlatform.instance.methodChannel
        .setMethodCallHandler(_handler);
    AiBlueToothPrintPlatform.instance.methodChannel
        .invokeMethod('scanBluetooth', {
      "placeholder": "placeholder",
    });
  }

  @override
  void connectBluetooth({String mac}) {
    AiBlueToothPrintPlatform.instance.methodChannel
        .invokeMethod('connectBluetooth', {
      "mac": mac,
    });
  }
}
