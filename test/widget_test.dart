import 'package:flutter_test/flutter_test.dart';
import 'package:mylawyer/main.dart';
import 'package:mylawyer/widgets/theme_provider.dart';

void main() {
  testWidgets('Загрузка документов кнопка проверка', (WidgetTester tester) async {
    final themeProvider = ThemeProvider();

    // Загрузка темы из базы данных (или устанавливаем светлую тему вручную)
    await themeProvider.loadThemeFromDB(); // можно заменить на вручную установку: themeProvider._themeMode = ThemeMode.light;

    // Разворачиваем приложение с переданным themeProvider
    await tester.pumpWidget(MyApp(themeProvider: themeProvider));

    // Проверяем, что кнопка с текстом 'Загрузить документы' существует на экране
    expect(find.text('Загрузить документы'), findsOneWidget);

    // Нажимаем на кнопку
    await tester.tap(find.text('Загрузить документы'));
    await tester.pump();

    // Проверяем, что после нажатия происходит какое-то действие (например, открытие нового экрана).
    // Для этого можно добавить проверку, что на экране появился новый виджет или изменился состояние.
    // Например, если открывается новый экран, можно проверять его наличие:
    // expect(find.byType(YourNewScreen), findsOneWidget);
  });
}
