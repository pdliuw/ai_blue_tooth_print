import 'package:ai_blue_tooth_print/ai_blue_tooth_print_mobile_plugin.dart';
import 'package:ai_blue_tooth_print/bluetooth_device.dart';
import 'package:ai_blue_tooth_print/scan_bluetooth_device_result_callback.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///
/// AiBlueToothPrintPlatform
abstract class AiBlueToothPrintPlatform {
  static const MethodChannel _methodChannel =
      const MethodChannel('ai_blue_tooth_print');

  /// Only mock implementations should set this to true.
  ///
  /// Mockito mocks are implementing this class with `implements` which is forbidden for anything
  /// other than mocks (see class docs). This property provides a backdoor for mockito mocks to
  /// skip the verification that the class isn't implemented with `implements`.
  @visibleForTesting
  bool get isMock => false;

  static AiBlueToothPrintPlatform _instance = AiBlueToothPrintMobilePlugin();

  /// The default instance of [AiBlueToothPrintPlatform] to use.
  ///
  /// Platform-specific plugins should override this with their own
  /// platform-specific class that extends [AiBlueToothPrintPlatform] when they
  /// register themselves.
  ///
  static AiBlueToothPrintPlatform get instance => _instance;

  MethodChannel get methodChannel => _methodChannel;

  static List<BluetoothDevice> _bluetoothDeviceList = [];

  ScanBluetoothDeviceResultCallback _scanBluetoothDeviceResultCallback;

  ///
  /// Instance update
  static set instance(AiBlueToothPrintPlatform instance) {
    if (!instance.isMock) {
      try {
        instance._verifyProvidesDefaultImplementations();
      } on NoSuchMethodError catch (_) {
        throw AssertionError(
            'Platform interfaces must not be implemented with `implements`');
      }
    }
    _instance = instance;
  }

  // This method makes sure that AiBarcode isn't implemented with `implements`.
  //
  // See class doc for more details on why implementing this class is forbidden.
  //
  // This private method is called by the instance setter, which fails if the class is
  // implemented with `implements`.
  void _verifyProvidesDefaultImplementations() {}

  ///
  /// print
  Future<String> print({
    List<String> arrayInfo,
  }) async {
    return Future.delayed(
      Duration(seconds: 1),
    ).then((value) => "");
  }

  void scanBluetooth() {}

  void connectBluetooth({
    String mac,
  }) {}

  List<BluetoothDevice> get bluetoothDeviceList => _bluetoothDeviceList;

  set scanBluetoothDeviceResultCallback(
      ScanBluetoothDeviceResultCallback callback) {
    if (callback == null) {
      //do nothing
    }
    _scanBluetoothDeviceResultCallback = callback;
  }

  ScanBluetoothDeviceResultCallback get scanBluetoothDeviceResultCallback =>
      _scanBluetoothDeviceResultCallback;
}
