import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// When the theme mode is changed.
typedef OnChangeThemeMode = void Function(ThemeMode themeMode);

/// Builders the widget with the base in the [ThemeMode].
typedef ThemeModeBuilder = Widget Function(
  BuildContext context,
  ThemeMode themeMode,
);

/// {@template theme_mode_data}
/// Class with actions to manipulate [ThemeMode].
/// {@endtemplate}
@immutable
@visibleForTesting
class ThemeModeData {
  /// {@macro theme_mode_data}
  const ThemeModeData({
    required this.themeMode,
    required this.setThemeMode,
  });

  /// Gets the current [ThemeMode].
  final ThemeMode themeMode;

  /// Changes [ThemeMode].
  final OnChangeThemeMode setThemeMode;

  /// Sets the theme mode system.
  void useSystemMode() => setThemeMode(ThemeMode.system);

  /// Sets the theme mode light.
  void useLightMode() => setThemeMode(ThemeMode.light);

  /// Sets the theme mode dark.
  void useDarkMode() => setThemeMode(ThemeMode.dark);

  /// Create a new [ThemeModeData] based in other.
  ThemeModeData copyWith({
    ThemeMode? themeMode,
    OnChangeThemeMode? setThemeMode,
  }) {
    return ThemeModeData(
      themeMode: themeMode ?? this.themeMode,
      setThemeMode: setThemeMode ?? this.setThemeMode,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ThemeModeData &&
        other.themeMode == themeMode &&
        other.setThemeMode == setThemeMode;
  }

  @override
  int get hashCode => Object.hashAll([themeMode, setThemeMode]);
}

/// {@template app_theme_mode}
/// Provides access to [ThemeModeData] in its descendant widgets to
/// manage your [ThemeMode]. Rebuilds every time that a new [ThemeMode] is set.
/// {@endtemplate}
class AppThemeMode extends StatefulWidget {
  /// {@macro app_theme_mode}
  const AppThemeMode({
    required this.builder,
    this.onChangeThemeMode,
    ThemeMode? initialThemeMode,
    super.key,
  }) : initialThemeMode = initialThemeMode ?? ThemeMode.system;

  /// [ThemeMode] initial, changing it later does not
  /// change the current [ThemeMode].
  final ThemeMode initialThemeMode;

  /// Builders the widget every time that a new [ThemeMode] is set.
  final ThemeModeBuilder builder;

  /// It's called every time when a new different [ThemeMode] is set.
  final OnChangeThemeMode? onChangeThemeMode;

  @override
  State<AppThemeMode> createState() => _AppThemeModeState();

  /// Gets the [ThemeModeData].
  static ThemeModeData of(BuildContext context) {
    final inheritedThemeMode =
        context.dependOnInheritedWidgetOfExactType<_InheritedThemeModeData>();
    if (inheritedThemeMode != null) {
      return inheritedThemeMode.themeModeData;
    }
    throw FlutterError(
      '''
        AppThemeMode.of() called with a context that does not contain a $AppThemeMode.        
        This can happen if the context you used comes from a widget above the AppThemeMode.
        The context used was: $context
      ''',
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        EnumProperty('defaultThemeMode', initialThemeMode),
      )
      ..add(
        ObjectFlagProperty<ThemeModeBuilder>.has('builder', builder),
      )
      ..add(
        ObjectFlagProperty<OnChangeThemeMode>.has(
          'onChangeThemeMode',
          onChangeThemeMode,
        ),
      );
  }
}

class _AppThemeModeState extends State<AppThemeMode> {
  late ThemeModeData _themeModeData = ThemeModeData(
    themeMode: widget.initialThemeMode,
    setThemeMode: _setThemeMode,
  );

  ThemeMode get _currentThemeMode => _themeModeData.themeMode;

  @override
  Widget build(BuildContext context) {
    return _InheritedThemeModeData(
      themeModeData: _themeModeData,
      child: widget.builder(context, _currentThemeMode),
    );
  }

  void _setThemeMode(ThemeMode themeMode) {
    if (_currentThemeMode != themeMode) {
      widget.onChangeThemeMode?.call(themeMode);
      setState(
        () => _themeModeData = _themeModeData.copyWith(
          themeMode: themeMode,
        ),
      );
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty('themeMode', _currentThemeMode));
  }
}

class _InheritedThemeModeData extends InheritedWidget {
  const _InheritedThemeModeData({
    required this.themeModeData,
    required super.child,
  });

  final ThemeModeData themeModeData;

  @override
  bool updateShouldNotify(_InheritedThemeModeData oldWidget) =>
      themeModeData.themeMode != oldWidget.themeModeData.themeMode;
}
