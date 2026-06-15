import 'package:flutter_test/flutter_test.dart';
import 'package:zenfocus_ai/main.dart';

void main() {
  testWidgets('Tranquil Study AI launches', (WidgetTester tester) async {
    await tester.pumpWidget(const ZenFocusApp(showOnboarding: false));
    expect(find.byType(ZenFocusApp), findsOneWidget);
  });
}
