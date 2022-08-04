import 'package:app_theme_mode/app_theme_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

final themeModeDialog = AppThemeMode(
  builder: (_, ThemeMode themeMode) {
    return MaterialApp(
      key: const Key('material_app'),
      themeMode: themeMode,
      home: Material(
        child: Builder(
          builder: (context) {
            return Center(
              child: TextButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => const AppThemeModeDialog(),
                ),
                child: const Text('Theme Mode Dialog'),
              ),
            );
          },
        ),
      ),
    );
  },
);

void main() {
  group('AppThemeModeDialog', () {
    testWidgets('debugFillProperties', (tester) async {
      const child = AppThemeModeDialog(
        title: 'Theme',
        systemThemeTitle: 'System',
        lightThemeTitle: 'Light',
        darkThemeTitle: 'Dark',
        cancelTitle: 'Cancel',
      );
      expect(
        child.toString(),
        'AppThemeModeDialog(title: "Theme", systemThemeTitle: "System", '
        'lightThemeTitle: "Light", '
        'darkThemeTitle: "Dark", cancelTitle: "Cancel")',
      );
    });

    testWidgets('debugFillProperties - LabeledRadio', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppThemeMode(
              initialThemeMode: ThemeMode.system,
              builder: (_, __) => const AppThemeModeDialog(
                title: 'Theme',
                cancelTitle: 'Nope',
              ),
            ),
          ),
        ),
      );
      final labeledRadio = tester.widget(
        find
            .byWidgetPredicate((widget) => widget is LabeledRadio<ThemeMode>)
            .first,
      );
      expect(
        labeledRadio.toString(),
        'LabeledRadio<ThemeMode>(label: "System", '
        'has groupValue, has value, has onChanged)',
      );
    });

    testWidgets('rendering', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppThemeMode(
              initialThemeMode: ThemeMode.system,
              builder: (_, __) => const AppThemeModeDialog(
                title: 'Theme',
                cancelTitle: 'Nope',
              ),
            ),
          ),
        ),
      );
      expect(find.text('Theme'), findsOneWidget);
      expect(
        find.byWidgetPredicate((widget) => widget is LabeledRadio<ThemeMode>),
        findsNWidgets(3),
      );
      expect(find.text('Nope'.toUpperCase()), findsOneWidget);
    });

    testWidgets(
        'should be close dialog and change theme when '
        'the theme mode selected is different', (tester) async {
      await tester.pumpWidget(themeModeDialog);

      await tester.tap(find.text('Theme Mode Dialog'));
      await tester.pump();

      var radio = tester.widget<LabeledRadio<ThemeMode>>(
        find
            .byWidgetPredicate((widget) => widget is LabeledRadio<ThemeMode>)
            .first,
      );
      expect(radio.groupValue, ThemeMode.system);

      await tester.tap(find.text('Light'));
      await tester.pump();

      var materialApp = tester.widget<MaterialApp>(
        find.byType(MaterialApp),
      );
      expect(materialApp.themeMode, ThemeMode.light);

      await tester.tap(find.text('Theme Mode Dialog'));
      await tester.pump();

      radio = tester.widget<LabeledRadio<ThemeMode>>(
        find
            .byWidgetPredicate((widget) => widget is LabeledRadio<ThemeMode>)
            .first,
      );
      expect(radio.groupValue, ThemeMode.light);

      await tester.tap(find.text('System'));
      await tester.pump();

      materialApp = tester.widget<MaterialApp>(
        find.byType(MaterialApp),
      );
      expect(materialApp.themeMode, ThemeMode.system);

      await tester.tap(find.text('Theme Mode Dialog'));
      await tester.pump();

      await tester.tap(find.text('Dark'));
      await tester.pump();

      materialApp = tester.widget<MaterialApp>(
        find.byType(MaterialApp),
      );
      expect(materialApp.themeMode, ThemeMode.dark);
    });

    testWidgets(
        'does not should be close dialog when '
        'the theme mode selected is the same', (tester) async {
      await tester.pumpWidget(themeModeDialog);

      await tester.tap(find.text('Theme Mode Dialog'));
      await tester.pump();

      final radio = tester.widget<LabeledRadio<ThemeMode>>(
        find
            .byWidgetPredicate((widget) => widget is LabeledRadio<ThemeMode>)
            .first,
      );
      expect(radio.groupValue, ThemeMode.system);

      await tester.tap(find.text('System'));
      await tester.pump();
      expect(radio.groupValue, ThemeMode.system);
      expect(find.byType(AppThemeModeDialog), findsOneWidget);
    });

    testWidgets(
        'does not should change theme mode when '
        'the dialog is canceled', (tester) async {
      await tester.pumpWidget(themeModeDialog);

      await tester.tap(find.text('Theme Mode Dialog'));
      await tester.pump();

      await tester.tap(find.text('Cancel'.toUpperCase()));
      await tester.pump();

      final materialApp = tester.widget<MaterialApp>(
        find.byType(MaterialApp),
      );
      expect(materialApp.themeMode, ThemeMode.system);
    });
  });
}
