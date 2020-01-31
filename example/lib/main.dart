import 'dart:async';

import 'package:ai_blue_tooth_print/ai_blue_tooth_print.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ai_blue_tooth_print/ai_blue_tooth_print.dart';

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
            title: Text('Barcode Scanner Example'),
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
      "这是第一行数据",
      "这是第二行数据",
      "这是第三行数据",
      "这是第四行数据",
      "这是第四行数据",
    ]);
  }

}
