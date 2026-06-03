import 'package:flutter_test/flutter_test.dart';

import 'package:minimarket_adso_apk/main.dart';

void main() {
  testWidgets('renders the store home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MinimarketApp());

    expect(find.text('MMARK'), findsOneWidget);
    expect(find.text('Compra Ahora'), findsOneWidget);
    expect(find.text('Envio Gratis'), findsOneWidget);
    expect(find.textContaining('Cargando productos'), findsOneWidget);
  });
}
