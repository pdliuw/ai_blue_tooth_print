import 'dart:async';

import 'package:flutter/services.dart';

class AiBlueToothPrint {
  static const MethodChannel _channel =
      const MethodChannel('ai_blue_tooth_print');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
