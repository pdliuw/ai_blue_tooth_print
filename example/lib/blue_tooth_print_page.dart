import 'package:ai_blue_tooth_print/ai_blue_tooth_print.dart';
import 'package:flutter/material.dart';

///
/// BluetoothPrintPage
class BluetoothPrintPage extends StatefulWidget {
  @override
  _BluetoothPrintPageState createState() => _BluetoothPrintPageState();
}

class _BluetoothPrintPageState extends State<BluetoothPrintPage> {
  AiBlueToothPrintController _toothPrintController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("bluetooth print example"),
      ),
      body: Column(
        children: <Widget>[
          AiBlueToothPrintPlatformWidget.defaultStyle(
            receiveControllerCallback: (AiBlueToothPrintController controller) {
              _toothPrintController = controller;
            },
          ),
          Expanded(
            child: Center(
              child: Container(
                child: OutlinedButton(
                    onPressed: () {
                      toothPrint();
                    },
                    child: Text("print")),
                padding: const EdgeInsets.all(8.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  toothPrint() {
    _toothPrintController.print(
      arrayInfo: [
        "print data",
        "print data",
        "print data",
        "print data",
        "print data",
        "print data",
        "print data",
        "print data",
        "print data",
        "print data",
        "print data",
        "print data",
        "print data",
        "print data",
      ],
    );
  }
}
