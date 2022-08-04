import 'package:app_theme_mode/app_theme_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

typedef ThemeModeCallback = ThemeMode Function();
typedef OnBuild = void Function(BuildContext context, ThemeMode themeMode);

class MyApp extends StatelessWidget {
  const MyApp({
    this.defaultThemeMode,
    this.onChangeThemeMode,
    this.themeModeCallback,
    this.onBuild,
    this.child,
    super.key,
  });

  final ThemeMode? defaultThemeMode;
  final OnChangeThemeMode? onChangeThemeMode;
  final ThemeModeCallback? themeModeCallback;
  final OnBuild? onBuild;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return AppThemeMode(
      initialThemeMode: defaultThemeMode,
      onChangeThemeMode: onChangeThemeMode,
      builder: (context, themeMode) {
        return MaterialApp(
          key: const Key('material_app'),
          themeMode: themeMode,
          home: Builder(
            builder: (context) {
              onBuild?.call(context, themeMode);
              return Center(
                child: TextButton(
                  onPressed: () {
                    final appThemeMode = AppThemeMode.of(context);
                    appThemeMode.setThemeMode(
                      themeModeCallback?.call() ?? appThemeMode.themeMode,
                    );
                  },
                  child: child ?? const Text('Theme Mode Dialog'),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class ShowThemeMode extends StatelessWidget {
  const ShowThemeMode({super.key});

  @override
  Widget build(BuildContext context) =>
      Text(AppThemeMode.of(context).themeMode.name);
}

void main() {
  group('AppThemeMode', () {
    testWidgets('debugFillProperties', (tester) async {
      final child = AppThemeMode(
        onChangeThemeMode: (_) {},
        builder: (_, __) => const SizedBox.shrink(),
      );
      expect(
        child.toString(),
        'AppThemeMode(defaultThemeMode: system, has builder, '
        'has onChangeThemeMode)',
      );

      await tester.pumpWidget(child);
      final state = tester.state(find.byWidget(child));
      expect(state.toString(), endsWith('(themeMode: system)'));
    });

    testWidgets(
        'rendering with dark theme mode when '
        'the default theme mode is not set', (tester) async {
      await tester.pumpWidget(const MyApp());

      final material =
          tester.widget<MaterialApp>(find.byKey(const Key('material_app')));
      expect(material.themeMode, ThemeMode.system);
    });

    testWidgets('rendering the theme mode passed as the default theme',
        (tester) async {
      await tester.pumpWidget(
        const MyApp(
          defaultThemeMode: ThemeMode.dark,
        ),
      );

      final material =
          tester.widget<MaterialApp>(find.byKey(const Key('material_app')));
      expect(material.themeMode, ThemeMode.dark);
    });

    testWidgets(
        'AppThemeMode.of(context).themeMode should change when '
        'a new theme mode is set', (tester) async {
      final themeModes = <ThemeMode>[];
      await tester.pumpWidget(
        MyApp(
          defaultThemeMode: ThemeMode.dark,
          themeModeCallback: () {
            final size = themeModes.length;
            if (size == 1) {
              return ThemeMode.light;
            } else if (size == 2) {
              return ThemeMode.dark;
            }
            return ThemeMode.system;
          },
          onBuild: (context, themeMode) =>
              themeModes.add(AppThemeMode.of(context).themeMode),
        ),
      );
      await tester.tap(find.byType(TextButton));
      await tester.pump();
      await tester.tap(find.byType(TextButton));
      await tester.pump();
      await tester.tap(find.byType(TextButton));
      await tester.pump();
      await tester.tap(find.byType(TextButton));
      await tester.pump();
      await tester.tap(find.byType(TextButton));
      await tester.pump();

      expect(themeModes, [
        ThemeMode.dark,
        ThemeMode.light,
        ThemeMode.dark,
        ThemeMode.system,
      ]);
    });

    testWidgets(
        'should call the on change function '
        'when a new theme mode is set', (tester) async {
      ThemeMode? currentThemeMode;
      var callOnChange = 0;
      await tester.pumpWidget(
        MyApp(
          themeModeCallback: () {
            if (callOnChange == 0) {
              return ThemeMode.light;
            } else if (callOnChange == 1) {
              return ThemeMode.dark;
            }
            return ThemeMode.system;
          },
          onChangeThemeMode: (themeMode) {
            callOnChange++;
            currentThemeMode = themeMode;
          },
        ),
      );
      await tester.tap(find.byType(TextButton));
      await tester.pump();
      await tester.tap(find.byType(TextButton));
      await tester.pump();
      await tester.tap(find.byType(TextButton));
      await tester.pump();
      await tester.tap(find.byType(TextButton));
      await tester.pump();

      expect(callOnChange, 3);
      expect(currentThemeMode, ThemeMode.system);
    });

    testWidgets(
        'should rebuild '
        'when a new theme mode is set', (tester) async {
      ThemeMode? currentThemeMode;
      var callOnBuild = 0;
      await tester.pumpWidget(
        MyApp(
          themeModeCallback: () {
            if (callOnBuild == 1) {
              return ThemeMode.light;
            }
            return ThemeMode.dark;
          },
          onBuild: (_, themeMode) {
            callOnBuild++;
            currentThemeMode = themeMode;
          },
        ),
      );
      await tester.tap(find.byType(TextButton));
      await tester.pump();
      await tester.tap(find.byType(TextButton));
      await tester.pump();
      await tester.tap(find.byType(TextButton));
      await tester.pump();

      expect(callOnBuild, 3);
      expect(currentThemeMode, ThemeMode.dark);
    });

    testWidgets(
        'should rebuild widgets(const) that get the current theme mode '
        'when a new theme mode is set', (tester) async {
      var currentThemeMode = ThemeMode.system;
      await tester.pumpWidget(
        MyApp(
          themeModeCallback: () {
            if (currentThemeMode == ThemeMode.system) {
              return currentThemeMode = ThemeMode.light;
            } else if (currentThemeMode == ThemeMode.light) {
              return currentThemeMode = ThemeMode.dark;
            }
            // reset
            currentThemeMode = ThemeMode.system;
            return ThemeMode.dark;
          },
          child: const ShowThemeMode(),
        ),
      );
      await tester.tap(find.byType(TextButton));
      await tester.pump();
      await tester.tap(find.byType(TextButton));
      await tester.pump();
      await tester.tap(find.byType(TextButton));
      await tester.pump();
      await tester.tap(find.byType(TextButton));
      await tester.pump();

      expect(find.text(ThemeMode.light.name), findsOneWidget);
    });

    group('ThemeModeData', () {
      // ignore: prefer_function_declarations_over_variables
      final onChangeThemeMode = (_) {};
      final themeModeData = ThemeModeData(
        themeMode: ThemeMode.dark,
        setThemeMode: onChangeThemeMode,
      );
      final themeModeData2 = ThemeModeData(
        themeMode: ThemeMode.dark,
        setThemeMode: onChangeThemeMode,
      );
      final differentThemeModeData = ThemeModeData(
        themeMode: ThemeMode.light,
        setThemeMode: onChangeThemeMode,
      );
      test('should be the same hasCode for the same values', () {
        expect(themeModeData.hashCode, themeModeData.hashCode);
        expect(themeModeData.hashCode, themeModeData2.hashCode);
      });

      test('should be the different hasCode for different values', () {
        expect(themeModeData.hashCode, isNot(differentThemeModeData.hashCode));
      });

      test('should be the equals true for the same values', () {
        expect(themeModeData, themeModeData);
        expect(themeModeData, themeModeData2);
      });

      test('should be the equals false for different values', () {
        expect(themeModeData, isNot(differentThemeModeData));
      });

      test('should clone the object', () {
        var callOnChange = 0;
        final cloneThemeModeData = themeModeData.copyWith(
          themeMode: ThemeMode.system,
          onChangeThemeMode: (_) => ++callOnChange,
        )..useDarkMode();
        expect(cloneThemeModeData.themeMode, ThemeMode.system);
        expect(callOnChange, 1);
      });

      test('use system mode', () {
        ThemeMode? currentThemeMode;
        ThemeModeData(
          themeMode: ThemeMode.dark,
          setThemeMode: (themeMode) => currentThemeMode = themeMode,
        ).useSystemMode();
        expect(currentThemeMode, ThemeMode.system);
      });

      test('use light mode', () {
        ThemeMode? currentThemeMode;
        ThemeModeData(
          themeMode: ThemeMode.dark,
          setThemeMode: (themeMode) => currentThemeMode = themeMode,
        ).useLightMode();
        expect(currentThemeMode, ThemeMode.light);
      });

      test('use dark mode', () {
        ThemeMode? currentThemeMode;
        ThemeModeData(
          themeMode: ThemeMode.system,
          setThemeMode: (themeMode) => currentThemeMode = themeMode,
        ).useDarkMode();
        expect(currentThemeMode, ThemeMode.dark);
      });
    });
  });
}
