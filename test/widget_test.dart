import 'package:flutter_test/flutter_test.dart';
import 'package:psb_go/main.dart';

void main() {
  testWidgets('PSB-Go app starts successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const PSBGoApp());

    expect(find.byType(PSBGoApp), findsOneWidget);
  });
}