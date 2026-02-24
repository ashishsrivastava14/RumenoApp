import 'package:flutter_test/flutter_test.dart';
import 'package:rumeno_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const RumenoApp());
    await tester.pumpAndSettle();
    expect(find.text('Rumeno'), findsWidgets);
  });
}
