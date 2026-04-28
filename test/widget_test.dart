import 'package:flutter_test/flutter_test.dart';
import 'package:veterinaria/main.dart';

void main() {
  testWidgets('muestra el menu principal del sistema', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Sistema veterinario'), findsOneWidget);
    expect(find.text('Registro animal'), findsOneWidget);
    expect(find.text('Citas'), findsOneWidget);
    expect(find.text('Adopciones'), findsOneWidget);
  });
}
