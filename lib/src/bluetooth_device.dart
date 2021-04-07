///
/// BluetoothDevice
class BluetoothDevice {
  String _name;
  String _ip;
  String _mac;

  BluetoothDevice.defaultStyle({
    String name,
    String ip,
    String mac,
  }) {
    _name = name;
    _ip = ip;
    _mac = mac;
  }

  String get name => _name;

  String get ip => _ip;

  String get mac => _mac;
}
