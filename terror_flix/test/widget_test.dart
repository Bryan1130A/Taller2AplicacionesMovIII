import 'package:flutter_test/flutter_test.dart';
import 'package:terror_flix/main.dart';

void main() {
  testWidgets('La aplicación inicia correctamente', (WidgetTester tester) async {
    await tester.pumpWidget(const TerrorFlix());

    expect(find.text('Bienvenido a Terror Flix'), findsOneWidget);
  });
}