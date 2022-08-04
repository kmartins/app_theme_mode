import 'dart:async';

import 'package:flutter/material.dart';

@immutable
abstract class ThemeModeAdapter {
  const ThemeModeAdapter();

  ThemeMode read();

  FutureOr<void> write(ThemeMode themeMode);
}
