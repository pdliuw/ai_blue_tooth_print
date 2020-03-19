import 'dart:async';

import 'package:ai_blue_tooth_print/ai_blue_tooth_print_interface.dart';

///
/// AiBlueToothPrint
class AiBlueToothPrint {
  ///
  /// print
  static Future<String> print({
    List<String> arrayInfo,
  }) async {
    return AiBlueToothPrintPlatform.instance.print(arrayInfo: arrayInfo);
  }
}
