import 'package:ai_blue_tooth_print/ai_blue_tooth_print.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

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

  test('print', () async {
    expect(await AiBlueToothPrint.print(arrayInfo: ["one", "two"]), '42');
  });
}
