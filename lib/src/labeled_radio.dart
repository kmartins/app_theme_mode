part of 'app_theme_mode_dialog.dart';

/// Equals a [RadioListTile] however without internal padding.
@visibleForTesting
class LabeledRadio<T> extends StatelessWidget {
  /// Constructor for [LabeledRadio]. Builds a [Radio] to selection.
  /// Use as:
  /// ```dart
  /// LabeledRadio<String>(
  ///   value: 'value',
  ///   groupValue: 'otherValue',
  ///   onChanged: (value) => groupValue = value,
  ///   label: 'Value',
  /// );
  /// ```
  const LabeledRadio({
    required this.label,
    required this.groupValue,
    required this.value,
    required this.onChanged,
    super.key,
  });

  /// Radio Title.
  final String label;

  /// Value of the group to which the radio belongs.
  final T groupValue;

  /// Radio value.
  final T value;

  /// Called when the user selects this radio and the
  /// [value] is different of the [groupValue].
  ///
  /// This callback receives the [value] as parameter.
  final void Function(T value) onChanged;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        StringProperty('label', label),
      )
      ..add(
        ObjectFlagProperty<T>.has('groupValue', groupValue),
      )
      ..add(
        ObjectFlagProperty<T>.has('value', value),
      )
      ..add(
        ObjectFlagProperty<void Function(T value)>.has('onChanged', onChanged),
      );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (value != groupValue) {
          onChanged(value);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: <Widget>[
            Radio<T>(
              // ignore: deprecated_member_use
              groupValue: groupValue,
              value: value,
              // ignore: deprecated_member_use
              onChanged: (value) {
                if (value case final value?) {
                  onChanged(value);
                }
              },
            ),
            Text(label),
          ],
        ),
      ),
    );
  }
}
