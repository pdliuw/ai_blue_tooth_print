import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/services.dart';

///
/// AiBlueToothPrint
class AiBlueToothPrint {
  static const MethodChannel _channel =
      const MethodChannel('ai_blue_tooth_print');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  ///
  /// print
  static Future<String> print({
    List<String> arrayInfo,
  }) async {
    arrayInfo = arrayInfo ?? [];
    return await _channel.invokeMethod('print', {
      "info": arrayInfo,
    });
  }
}
