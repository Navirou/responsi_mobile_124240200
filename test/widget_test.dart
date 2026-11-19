import 'package:flutter_test/flutter_test.dart';
import 'package:latres/main.dart';

void main() {
  testWidgets('App smoke test loads login page when not logged in', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(isLoggedIn: false));
    expect(find.text('keripikroll'), findsOneWidget);
  });
}
