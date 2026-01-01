import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'toast.dart';

/// Defines the behaviour of toasts and visuals of toast messages.
///
/// Used by [ToastTheme] to pass down toast styling through the widget tree.
@immutable
class ToastThemeData with Diagnosticable {
  /// Creates a theme for customizing toasts and toast messages.
  const ToastThemeData({
    this.successBackgroundColor,
    this.warningBackgroundColor,
    this.neutralBackgroundColor,
    this.successForegroundColor,
    this.warningForegroundColor,
    this.neutralForegroundColor,
    this.successIcon,
    this.warningIcon,
    this.neutralIcon,
    this.alignment,
    this.borderRadius,
    this.insets,
    this.messagePadding,
    this.messageStyle,
    this.spacing,
  });

  /// The background color for success toast messages.
  final Color? successBackgroundColor;

  /// The background color for error toasts messages.
  final Color? warningBackgroundColor;

  /// The background color for neutral toasts messages.
  final Color? neutralBackgroundColor;

  /// The foreground color (text and icon) for success toasts messages.
  final Color? successForegroundColor;

  /// The foreground color (text and icon) for error toasts messages.
  final Color? warningForegroundColor;

  /// The foreground color (text and icon) for neutral toasts messages.
  final Color? neutralForegroundColor;

  /// The icon for success toasts messages.
  final IconData? successIcon;

  /// The icon for error toast messages.
  final IconData? warningIcon;

  /// The icon for neutral toasts messages.
  final IconData? neutralIcon;

  /// The default alignment for all toasts.
  final ToastAlignment? alignment;

  /// The padding the container has in message toast
  final EdgeInsetsGeometry? messagePadding;

  /// The border radius of the toast message.
  final BorderRadius? borderRadius;

  /// The default insets the toast has from the edges of the screen.
  final EdgeInsets? insets;

  /// The textstyle of the message in toast messages.
  final TextStyle? messageStyle;

  /// The spacing between the icon and the text in toast messages.
  final double? spacing;

  /// Creates a copy of this theme but with the given fields replaced with
  /// new values.
  ToastThemeData copyWith({
    Color? successBackgroundColor,
    Color? warningBackgroundColor,
    Color? neutralBackgroundColor,
    Color? successForegroundColor,
    Color? warningForegroundColor,
    Color? neutralForegroundColor,
    IconData? successIcon,
    IconData? warningIcon,
    IconData? neutralIcon,
    ToastAlignment? alignment,
    EdgeInsetsGeometry? messagePadding,
    BorderRadius? borderRadius,
    EdgeInsets? insets,
    TextStyle? messageStyle,
    double? spacing,
  }) {
    return ToastThemeData(
      successBackgroundColor:
          successBackgroundColor ?? this.successBackgroundColor,
      warningBackgroundColor:
          warningBackgroundColor ?? this.warningBackgroundColor,
      neutralBackgroundColor:
          neutralBackgroundColor ?? this.neutralBackgroundColor,
      successForegroundColor:
          successForegroundColor ?? this.successForegroundColor,
      warningForegroundColor:
          warningForegroundColor ?? this.warningForegroundColor,
      neutralForegroundColor:
          neutralForegroundColor ?? this.neutralForegroundColor,
      successIcon: successIcon ?? this.successIcon,
      warningIcon: warningIcon ?? this.warningIcon,
      neutralIcon: neutralIcon ?? this.neutralIcon,
      messagePadding: messagePadding ?? this.messagePadding,
      alignment: alignment ?? this.alignment,
      borderRadius: borderRadius ?? this.borderRadius,
      insets: insets ?? this.insets,
      messageStyle: messageStyle,
      spacing: spacing,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ToastThemeData &&
        other.successBackgroundColor == successBackgroundColor &&
        other.warningBackgroundColor == warningBackgroundColor &&
        other.neutralBackgroundColor == neutralBackgroundColor &&
        other.successForegroundColor == successForegroundColor &&
        other.warningForegroundColor == warningForegroundColor &&
        other.neutralForegroundColor == neutralForegroundColor &&
        other.successIcon == successIcon &&
        other.warningIcon == warningIcon &&
        other.neutralIcon == neutralIcon &&
        other.alignment == alignment &&
        other.borderRadius == borderRadius &&
        other.insets == insets &&
        other.messagePadding == messagePadding &&
        other.messageStyle == messageStyle &&
        other.spacing == spacing;
  }

  @override
  int get hashCode => Object.hash(
    successBackgroundColor,
    warningBackgroundColor,
    neutralBackgroundColor,
    successForegroundColor,
    warningForegroundColor,
    neutralForegroundColor,
    successIcon,
    warningIcon,
    neutralIcon,
    alignment,
    borderRadius,
    insets,
    messagePadding,
    messageStyle,
    spacing,
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      ColorProperty('successBackgroundColor', successBackgroundColor),
    );
    properties.add(
      ColorProperty('warningBackgroundColor', warningBackgroundColor),
    );
    properties.add(
      ColorProperty('neutralBackgroundColor', neutralBackgroundColor),
    );
    properties.add(
      ColorProperty('successForegroundColor', successForegroundColor),
    );
    properties.add(
      ColorProperty('warningForegroundColor', warningForegroundColor),
    );
    properties.add(
      ColorProperty('neutralForegroundColor', neutralForegroundColor),
    );
    properties.add(DiagnosticsProperty('successIcon', successIcon));
    properties.add(DiagnosticsProperty('warningIcon', warningIcon));
    properties.add(DiagnosticsProperty('neutralIcon', neutralIcon));
    properties.add(DiagnosticsProperty('aligment', alignment));
    properties.add(DiagnosticsProperty('borderRadius', borderRadius));
    properties.add(DiagnosticsProperty('insets', insets));
    properties.add(DiagnosticsProperty('messagePadding', messagePadding));
    properties.add(DiagnosticsProperty('messageStyle', messageStyle));
    properties.add(DiagnosticsProperty('spacing', spacing));
  }
}

/// An inherited widget that makes a [ToastThemeData] available to descendants.
///
/// Use this widget to apply a consistent toast style across your app.
class ToastTheme extends InheritedWidget {
  /// Creates a toast theme that controls the style of descendant toasts.
  const ToastTheme({super.key, required this.data, required super.child});

  /// The style configuration for descendant toasts.
  final ToastThemeData data;

  /// The data from the closest [ToastTheme] instance that encloses the given
  /// [BuildContext].
  ///
  /// If no [ToastTheme] is in scope, an empty [ToastThemeData] is returned.
  static ToastThemeData of(BuildContext context) {
    final ToastTheme? result = context
        .dependOnInheritedWidgetOfExactType<ToastTheme>();
    return result?.data ?? const ToastThemeData();
  }

  @override
  bool updateShouldNotify(ToastTheme oldWidget) => data != oldWidget.data;
}
