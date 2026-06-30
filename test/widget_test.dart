import 'package:flutter_test/flutter_test.dart';
import 'package:solar_agreement/main.dart';

void main() {
  testWidgets('App loads agreement form', (WidgetTester tester) async {
    await tester.pumpWidget(const SolarAgreementApp());
    expect(find.text('AGREEMENT DETAILS'), findsOneWidget);
  });
}
