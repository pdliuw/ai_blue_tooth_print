import 'ai_blue_tooth_print_interface.dart';

///
/// AiBlueToothPrintMobilePlugin
class AiBlueToothPrintMobilePlugin extends AiBlueToothPrintPlatform {
  @override
  Future<String> print({List<String> arrayInfo}) async {
    arrayInfo = arrayInfo ?? [];
    return await AiBlueToothPrintPlatform.instance.methodChannel.invokeMethod(
      'print',
      {
        "info": arrayInfo,
      },
    );
  }
}
