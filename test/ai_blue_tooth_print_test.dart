import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ai_blue_tooth_print/ai_blue_tooth_print.dart';

void main() {
  const MethodChannel channel = MethodChannel('ai_blue_tooth_print');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await AiBlueToothPrint.platformVersion, '42');
  });
}
