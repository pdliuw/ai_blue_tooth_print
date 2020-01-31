# ai_blue_tooth_print example

![totem](https://raw.githubusercontent.com/pdliuw/pdliuw.github.io/master/images/totem_four_logo.jpg)

* ai_blue_tooth_print:

[![pub package](https://img.shields.io/pub/v/ai_blue_tooth_print.svg)](https://pub.dev/packages/ai_blue_tooth_print)

* project

[ai_blue_tooth_print](https://github.com/pdliuw/ai_blue_tooth_print) in the[Project](https://github.com/flutter-app-sample/flutter_app_sample)Practical application[flutter sample](https://github.com/flutter-app-sample/flutter_app_sample)

## permission

#### android

```

        <uses-permission android:name="android.permission.BLUETOOTH" />
        <uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
    
```

#### ios


#### macOS



## code


```

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


```

