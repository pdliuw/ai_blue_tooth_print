import 'package:ai_blue_tooth_print/ai_blue_tooth_print.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String barcode = "";

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Ai_Blue_Tooth_Print Example'),
        ),
        body: TargetPlatform.android == Theme.of(context).platform
            ? Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: MaterialButton(
                          onPressed: print, child: Text("print")),
                      padding: const EdgeInsets.all(8.0),
                    ),
                    Text(barcode),
                  ],
                ),
              )
            : IOS(),
      ),
    );
  }

  print() {
    AiBlueToothPrint.print(arrayInfo: [
      "print data",
      "print data",
      "print data",
      "print data",
      "print data",
    ]);
  }
}

class IOS extends StatefulWidget {
  @override
  _IOSState createState() => _IOSState();
}

class _IOSState extends State<IOS> {
  List<BluetoothDevice> _list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          MaterialButton(onPressed: _scanBluetooth, child: Text("扫描蓝牙")),
          MaterialButton(onPressed: _bluetoothPrint, child: Text("打印数据")),
          Column(
            children: _list.map((e) {
              return ListTile(
                title: Text("${e.name}"),
                subtitle: Text("${e.mac}"),
                onTap: () {
                  _connectBluetooth(e.mac);
                },
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  _scanBluetooth() {
    AiBlueToothPrint.scanBluetoothDeviceResultCallback(
        callback: ScanBluetoothDeviceResultCallback(successCallback: (devices) {
          setState(() {
            _list = devices;
          });
        }));
    AiBlueToothPrint.scanBluetooth();
  }

  _connectBluetooth(String mac) {
    AiBlueToothPrint.connectBluetooth(mac: mac);
  }

  _bluetoothPrint() {
    AiBlueToothPrint.print(arrayInfo: [
      "print data",
      "print data",
      "print data",
      "print data",
      "print data",
      "print data",
      "print data",
      "print data",
      "print data",
    ]);
  }
}
