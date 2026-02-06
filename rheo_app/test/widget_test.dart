// Basic Flutter test for Rheo App

import 'package:flutter_test/flutter_test.dart';
import 'package:rheo_app/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    // Build our app with onboarding disabled for testing
    await tester.pumpWidget(const RheoApp(showOnboarding: false));

    // Allow widget to settle
    await tester.pumpAndSettle();

    // Verify that the app title is displayed
    expect(find.text('RHEO'), findsOneWidget);
  });
}
