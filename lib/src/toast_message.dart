import 'package:flutter/material.dart';

import 'toast_theme.dart';

enum ToastType { success, neutral, warning }

/// An opinionated and minimal widget to show in toasts.
class ToastMessage extends StatelessWidget {
  /// An opinionated and minimal widget to show in toasts.
  const ToastMessage({
    super.key,
    required this.message,
    required this.type,
    this.textStyle,
    this.icon,
    this.backgroundColor,
    this.padding,
    this.borderRadius,
    this.spacing,
  });

  /// The message in the toast.
  final String message;

  /// The style of the text, if null will fallback to [ToastTheme].
  final TextStyle? textStyle;

  /// The type of the toast, if null will fallback to [ToastTheme].
  final ToastType type;

  /// The icon in front of the text, if null will fallback to [ToastTheme].
  final Widget? icon;

  /// The padding of the container holding the text, if null will fallback to [ToastTheme].
  final EdgeInsetsGeometry? padding;

  /// The color of the container, if null will fallback to [ToastTheme].
  final Color? backgroundColor;

  /// The radius of the container, if null will fallback to [ToastTheme].
  final BorderRadius? borderRadius;

  /// The spacing between the icon and text
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    final theme = ToastTheme.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    final themeIconData = switch (type) {
      .success => theme.successIcon ?? Icons.check,
      .neutral => theme.neutralIcon ?? Icons.info,
      .warning => theme.warningIcon ?? Icons.warning,
    };

    final themeBackgroundColor = switch (type) {
      .success => theme.successBackgroundColor ?? colorScheme.tertiaryContainer,
      .neutral => theme.neutralBackgroundColor ?? colorScheme.primaryContainer,
      .warning => theme.warningBackgroundColor ?? colorScheme.errorContainer,
    };

    final themeForegroundColor = switch (type) {
      .success =>
        theme.successForegroundColor ?? colorScheme.onTertiaryContainer,
      .neutral =>
        theme.neutralForegroundColor ?? colorScheme.onPrimaryContainer,
      .warning => theme.warningForegroundColor ?? colorScheme.onErrorContainer,
    };

    final themeBorderRadius = theme.borderRadius ?? BorderRadius.circular(4);

    final themePadding = theme.messagePadding ?? EdgeInsets.all(8);

    final themeTextStyle =
        theme.messageStyle ?? TextStyle(color: themeForegroundColor);

    final themeSpacing = theme.spacing ?? 4;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? themeBackgroundColor,
        borderRadius: borderRadius ?? themeBorderRadius,
      ),
      padding: padding ?? themePadding,
      child: Row(
        spacing: themeSpacing,
        mainAxisSize: MainAxisSize.min,
        children: [
          icon ?? Icon(themeIconData, color: themeForegroundColor),
          Text(message, style: textStyle ?? themeTextStyle),
        ],
      ),
    );
  }
}
