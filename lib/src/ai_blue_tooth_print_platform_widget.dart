import 'package:ai_blue_tooth_print/src/ai_blue_tooth_print_mobile_plugin.dart';
import 'package:flutter/material.dart';

import 'ai_blue_tooth_print_controller.dart';

///
/// AiBlueToothPrintReceiveControllerCallback
typedef AiBlueToothPrintReceiveControllerCallback = void Function(
    AiBlueToothPrintController controller);

///
/// AiBlueToothPrintPlatformWidget
// ignore: must_be_immutable
class AiBlueToothPrintPlatformWidget extends StatefulWidget {
  ///
  /// AiBlueToothPrintReceiveControllerCallback
  AiBlueToothPrintReceiveControllerCallback _receiveControllerCallback;

  ///
  /// AiBlueToothPrintPlatformWidget
  AiBlueToothPrintPlatformWidget.defaultStyle({
    @required
        AiBlueToothPrintReceiveControllerCallback receiveControllerCallback,
  }) {
    assert(receiveControllerCallback != null);
    _receiveControllerCallback = receiveControllerCallback;
  }

  @override
  _AiBlueToothPrintPlatformWidgetState createState() =>
      _AiBlueToothPrintPlatformWidgetState();
}

class _AiBlueToothPrintPlatformWidgetState
    extends State<AiBlueToothPrintPlatformWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      TargetPlatform platform = Theme.of(context).platform;

      if (platform == TargetPlatform.android ||
          platform == TargetPlatform.iOS) {
        var mobileController = AiBlueToothPrintController.mobile(
            printPlatform: AiBlueToothPrintMobilePlugin());
        widget._receiveControllerCallback(mobileController);
      } else {
        var webController = AiBlueToothPrintController.web();
        widget._receiveControllerCallback(webController);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
