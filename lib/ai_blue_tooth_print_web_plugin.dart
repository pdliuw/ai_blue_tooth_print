import 'dart:html' as html;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'ai_blue_tooth_print_interface.dart';

///
/// AiBlueToothPrintWebPlugin
class AiBlueToothPrintWebPlugin extends AiBlueToothPrintPlatform {
  /// Registers this class as the default instance of [AiBlueToothPrintWebPlugin].
  static void registerWith(Registrar registrar) {
    AiBlueToothPrintPlatform.instance = AiBlueToothPrintWebPlugin();
  }

  @override
  Future<String> print({List<String> arrayInfo}) {
    html.window.print();
    return Future.delayed(
      Duration(seconds: 1),
    ).then((value) => "web print is ok");
  }

  @override
  Future<String> printZebra({List<String> arrayInfo}) {
    html.window.print();
    return Future.delayed(
      Duration(seconds: 1),
    ).then((value) => "web print is ok");
  }
}
