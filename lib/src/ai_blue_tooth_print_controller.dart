import 'package:ai_blue_tooth_print_interface/ai_blue_tooth_print_interface.dart';
import 'package:flutter/widgets.dart';

///
/// AiBlueToothPrintController
class AiBlueToothPrintController {
  ///
  /// mobile constructor
  AiBlueToothPrintController.mobile({
    @required AiBlueToothPrintPlatform printPlatform,
  }) {
    AiBlueToothPrintPlatform.instance = printPlatform;
  }

  ///
  /// web constructor
  AiBlueToothPrintController.web();

  ///
  /// print
  print({
    @required List<String> arrayInfo,
  }) {
    return AiBlueToothPrintPlatform.instance.print(arrayInfo: arrayInfo);
  }

  ///
  /// printZebra
  Future<String> printZebra({
    @required List<String> arrayInfo,
  }) {
    return AiBlueToothPrintPlatform.instance.printZebra(arrayInfo: arrayInfo);
  }
}
