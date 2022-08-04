# App Theme Mode

[![pub][package_badge]][package_link]
[![License: MIT][license_badge]][license_link]
[![codecov][codecov_badge]][codecov_link]

Widgets to control your app **theme mode** during runtime and save it how you wishing.

It's very similar to [dynamic_theme_mode_package][dynamic_theme_mode_package].

## Why?

There is no business logic here, only widgets that control the **theme mode**, you choose how you want to save with [SharedPreferences][shared_preferences], [Hive][hive]... any one.

## Usage

```yaml
dependencies:
  app_theme_mode:
```

Import it where you want to use it e.g, in your main file.

```dart
import 'package:app_theme_mode/app_theme_mode.dart';
```

Put the `AppThemeMode` widget, above `MaterialApp/CupertinoApp` or another that had `theme mode`.
```dart
AppThemeMode(
    builder: (context, themeMode) => MaterialApp(        
        title: 'Flutter Demo',
        themeMode: themeMode,
        darkTheme: ThemeData.dark(),
        theme: ThemeData.light(),
        home: const MyHomePage(
          title: 'Flutter Demo Home Page',
        ),
    ),
);
```

Set the initial `theme mode`:
```dart
AppThemeMode(
    initialThemeMode: ThemeMode.light // System mode is the default
    builder: (context, themeMode)...
);
```
Get the `theme mode` saved of your **business logic**.
This is set only *_one time_*.

Add a callback for when a new different `theme mode` is set:
```dart
AppThemeMode(
    onChangeThemeMode: (themeMode) {
      // call your business logic to save 
      // the current theme mode here.
    },
    builder: (context, themeMode)...
);
```
**Here you can call your _logic business_ for the save current `theme mode`.**

You can access the current `theme mode`:
```dart
final currentTheme = AppThemeMode.of(context).themeMode;
```
**All the time that a new different `theme mode` is set the widget is rebuilt.**

Or set a new `theme mode`:
```dart
AppThemeMode.of(context).setThemeMode(ThemeMode.dark);
// or
AppThemeMode.of(context).useDarkMode();
```

There is a dialog widget called `AppThemeModeDialog` for the user to choose which `theme mode` he wants
```dart
IconButton(
    icon: const Icon(Icons.access_time_sharp),
    onPressed: () => showDialog(
        context: context,
        builder: (_) => const AppThemeModeDialog(),
    ),
),
```

## 📝 Maintainers

[Kauê Martins][github_profile]

## 🤝 Support

You liked this package? Then give it a ⭐️. If you want to help then:

- Fork this repository
- Send a Pull Request with new features
- Share this package
- Create issues if you find a bug or want to suggest a new extension

**Pull Request title follows [Conventional Commits][conventional_commits].

## 📝 License

Copyright © 2022 [Kauê Martins][github_profile].<br />
This project is [MIT][license_link] licensed.

[package_badge]: https://img.shields.io/pub/v/app_theme_mode.svg
[package_link]: https://pub.dev/packages/app_theme_mode
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[codecov_badge]: https://codecov.io/gh/kmartins/app_theme_mode/branch/main/graph/badge.svg
[codecov_link]: https://codecov.io/gh/kmartins/app_theme_mode
[shared_preferences]: https://pub.dev/packages/shared_preferences
[hive]: https://pub.dev/packages/hive
[conventional_commits]: https://www.conventionalcommits.org/en/v1.0.0/
[github_profile]: https://github.com/kmartins
[dynamic_theme_mode_package]: https://pub.dev/packages/dynamic_theme_mode