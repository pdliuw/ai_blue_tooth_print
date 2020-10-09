import 'package:ai_blue_tooth_print/bluetooth_device.dart';

typedef ScanBluetoothSuccessCallback = Function(List<BluetoothDevice> devices);

///
/// ScanBluetoothDeviceResultCallback
class ScanBluetoothDeviceResultCallback {
  ScanBluetoothSuccessCallback _successCallback;

  ScanBluetoothDeviceResultCallback({
    ScanBluetoothSuccessCallback successCallback,
  }) {
    _successCallback = successCallback;
  }

  ScanBluetoothSuccessCallback get successCallback => _successCallback;
}
