import 'dart:async';

import 'package:example/theme_mode_adapter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _key = 'theme_mode';

class PreferencesThemeModeAdapter extends ThemeModeAdapter {
  const PreferencesThemeModeAdapter(
    this.sharedPreferences, {
    ThemeMode? defaultThemeMode,
  }) : _defaultThemeMode = defaultThemeMode ?? ThemeMode.system;

  final SharedPreferences sharedPreferences;

  final ThemeMode _defaultThemeMode;

  @override
  ThemeMode read() {
    final themeModeName = sharedPreferences.getString(_key);
    return themeModeName == null
        ? _defaultThemeMode
        : ThemeMode.values.byName(themeModeName);
  }

  @override
  FutureOr<void> write(ThemeMode themeMode) =>
      sharedPreferences.setString(_key, themeMode.name);
}
