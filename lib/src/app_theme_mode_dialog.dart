import 'package:app_theme_mode/src/app_theme_mode.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

part 'labeled_radio.dart';

/// Create a dialog to choose a theme mode.
class AppThemeModeDialog extends StatelessWidget {
  /// Constructor for [AppThemeModeDialog].
  /// Builds a [AlertDialog] to switch themes modes.
  /// Use as:
  /// ```dart
  /// showDialog(context: context, builder: (_) => const ThemeModeDialog());
  /// ```
  const AppThemeModeDialog({
    this.title,
    this.systemThemeTitle,
    this.lightThemeTitle,
    this.darkThemeTitle,
    this.cancelTitle,
    super.key,
  });

  /// The optional title of the dialog is displayed in a large font at the top
  /// of the dialog.
  final String? title;

  /// The optional title of the system theme mode [ThemeMode.system].
  final String? systemThemeTitle;

  /// The optional title of the system theme mode [ThemeMode.light].
  final String? lightThemeTitle;

  /// The optional title of the system theme mode [ThemeMode.dark].
  final String? darkThemeTitle;

  /// The optional title of the cancel action that closes the dialog.
  final String? cancelTitle;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        StringProperty('title', title),
      )
      ..add(
        StringProperty('systemThemeTitle', systemThemeTitle),
      )
      ..add(
        StringProperty('lightThemeTitle', lightThemeTitle),
      )
      ..add(
        StringProperty('darkThemeTitle', darkThemeTitle),
      )
      ..add(
        StringProperty('cancelTitle', cancelTitle),
      );
  }

  @override
  Widget build(BuildContext context) {
    final themeModeData = AppThemeMode.of(context);
    final currentTheme = themeModeData.themeMode;
    final setThemeMode = themeModeData.setThemeMode;

    /// Change Theme Mode and close dialog.
    void changeThemeMode(ThemeMode themeMode) {
      setThemeMode(themeMode);
      Navigator.pop(context);
    }

    return AlertDialog(
      title: Text(title ?? 'Select a theme'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text((cancelTitle ?? 'Cancel').toUpperCase()),
        ),
      ],
      content: RadioGroup<ThemeMode>(
        groupValue: currentTheme,
        onChanged: (theme) => changeThemeMode(theme!),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LabeledRadio<ThemeMode>(
              value: ThemeMode.system,
              groupValue: currentTheme,
              onChanged: changeThemeMode,
              label: systemThemeTitle ?? 'System',
            ),
            LabeledRadio<ThemeMode>(
              value: ThemeMode.light,
              groupValue: currentTheme,
              onChanged: changeThemeMode,
              label: lightThemeTitle ?? 'Light',
            ),
            LabeledRadio<ThemeMode>(
              value: ThemeMode.dark,
              groupValue: currentTheme,
              onChanged: changeThemeMode,
              label: darkThemeTitle ?? 'Dark',
            ),
          ],
        ),
      ),
    );
  }
}
