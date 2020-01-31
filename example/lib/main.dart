import 'dart:async';

import 'package:ai_blue_tooth_print/ai_blue_tooth_print.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
          body: Center(
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
          )),
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
