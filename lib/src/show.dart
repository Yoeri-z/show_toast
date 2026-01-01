import 'package:flutter/widgets.dart';

import 'toast.dart';
import 'toast_message.dart';

/// Displays a custom toast message on the screen.
///
/// The [content] is the widget to be displayed inside the toast.
/// The [duration] specifies how long the toast remains visible.
/// The [fadeDuration] controls the animation duration for showing and hiding the toast.
/// The [alignment] determines the position of the toast on the screen.
/// If [isDismissible] is true, the toast can be dismissed by tapping.
/// If [ignorePointer] is true, the toast will not block pointer events to widgets behind it.
void showToast(
  BuildContext context, {
  required Widget content,
  Duration duration = const Duration(seconds: 3),
  Duration fadeDuration = const Duration(milliseconds: 350),
  ToastAlignment alignment = .bottom,
  bool isDismissible = true,
  bool ignorePointer = false,
}) {
  ToastManager.show(
    context,
    duration: duration,
    fadeDuration: fadeDuration,
    alignment: alignment,
    isDismissible: true,
    ignorePointer: false,
    content: content,
  );
}

/// Displays a pre-styled toast message with an icon and customizable appearance.
///
/// The [message] is the text content to display.
/// The [type] determines the default style (e.g., 'ok', 'info', 'warning') of the toast.
/// [duration], [fadeDuration], [alignment], [isDismissible], [ignorePointer]
/// function similarly to [showToast].
///
/// [inset] defines the padding from the edges of the screen.
/// [textStyle] customizes the text style of the message.
/// [padding] customizes the internal padding of the toast content.
/// [spacing] customizes the spacing between the icon and the message.
/// [icon] provides a custom icon, overriding the default for the [type].
/// [backgroundColor] provides a custom background color, overriding the default for the [type].
/// [borderRadius] customizes the corner radius of the toast container.
void showToastMessage(
  BuildContext context, {
  required String message,
  required ToastType type,
  Duration duration = const Duration(seconds: 3),
  Duration fadeDuration = const Duration(milliseconds: 350),
  ToastAlignment alignment = ToastAlignment.bottom,
  EdgeInsets inset = const EdgeInsets.all(16),
  bool isDismissible = true,
  bool ignorePointer = false,
  TextStyle? textStyle,
  EdgeInsets? padding,
  double? spacing,
  Widget? icon,
  Color? backgroundColor,
  BorderRadius? borderRadius,
}) {
  ToastManager.show(
    context,
    duration: duration,
    fadeDuration: fadeDuration,
    alignment: alignment,
    inset: inset,
    isDismissible: isDismissible,
    ignorePointer: ignorePointer,
    content: ToastMessage(
      message: message,
      textStyle: textStyle,
      padding: padding,
      spacing: spacing,
      type: type,
      icon: icon,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
    ),
  );
}

extension ToastContext on BuildContext {
  /// Displays a custom toast message using the [BuildContext].
  ///
  /// This is an extension method on [BuildContext] for convenience.
  /// See [showToast] for parameter details.
  void showToast({
    required Widget content,
    Duration duration = const Duration(seconds: 3),
    Duration fadeDuration = const Duration(milliseconds: 350),
    ToastAlignment alignment = ToastAlignment.bottom,
    bool isDismissible = true,
    bool ignorePointer = false,
  }) {
    ToastManager.show(
      this,
      duration: duration,
      fadeDuration: fadeDuration,
      alignment: alignment,
      isDismissible: true,
      ignorePointer: false,
      content: content,
    );
  }

  /// Displays a pre-styled toast message using the [BuildContext].
  ///
  /// This is an extension method on [BuildContext] for convenience.
  /// See [showToastMessage] for parameter details.
  void showToastMessage({
    required String message,
    required ToastType type,
    Duration duration = const Duration(seconds: 3),
    Duration fadeDuration = const Duration(milliseconds: 350),
    ToastAlignment alignment = ToastAlignment.bottom,
    EdgeInsets inset = const EdgeInsets.all(16),
    bool isDismissible = true,
    bool ignorePointer = false,
    TextStyle? textStyle,
    EdgeInsets? padding,
    double? spacing,
    Widget? icon,
    Color? backgroundColor,
    BorderRadius? borderRadius,
  }) {
    ToastManager.show(
      this,
      duration: duration,
      fadeDuration: fadeDuration,
      alignment: alignment,
      inset: inset,
      isDismissible: isDismissible,
      ignorePointer: ignorePointer,
      content: ToastMessage(
        message: message,
        textStyle: textStyle,
        padding: padding,
        spacing: spacing,
        type: type,
        icon: icon,
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
      ),
    );
  }
}
