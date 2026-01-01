import 'package:flutter/widgets.dart';

import 'toast_alignment.dart';

/// Abstract base class for defining toast entry and exit animations.
///
/// Implementations of this class specify how a toast widget
/// transitions on and off the screen.
@immutable
abstract class ToastAnimation {
  /// The duration of the animation.
  final Duration duration;

  /// The curve of the animation.
  final Curve curve;

  const ToastAnimation({required this.duration, required this.curve});

  /// Builds the animated widget based on the current animation state.
  Widget build(
    BuildContext context,
    Animation<double> animation,
    ToastAlignment alignment,
    Widget child,
  );
}

/// A [ToastAnimation] that fades the toast in and out.
class FadeAnimation extends ToastAnimation {
  const FadeAnimation({
    super.duration = const Duration(milliseconds: 350),
    super.curve = Curves.easeIn,
  });

  @override
  Widget build(
    BuildContext context,
    Animation<double> animation,
    ToastAlignment alignment,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }
}

/// A [ToastAnimation] that slides the toast in and out from a direction
/// determined by its [ToastAlignment].
class SlideAnimation extends ToastAnimation {
  const SlideAnimation({
    super.duration = const Duration(milliseconds: 350),
    super.curve = Curves.easeOut,
  });

  @override
  Widget build(
    BuildContext context,
    Animation<double> animation,
    ToastAlignment alignment,
    Widget child,
  ) {
    late final Tween<Offset> tween;

    switch (alignment) {
      case ToastAlignment.top:
      case ToastAlignment.topLeft:
      case ToastAlignment.topRight:
        tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
        break;
      case ToastAlignment.bottom:
      case ToastAlignment.bottomLeft:
      case ToastAlignment.bottomRight:
        tween = Tween(begin: const Offset(0, 1), end: Offset.zero);
        break;
      case ToastAlignment.center:
      case ToastAlignment.centerLeft:
        tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
        break;
      case ToastAlignment.centerRight:
        tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
        break;
    }
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(position: tween.animate(animation), child: child),
    );
  }
}

/// A [ToastAnimation] that scales the toast in and out.
class ScaleAnimation extends ToastAnimation {
  const ScaleAnimation({
    super.duration = const Duration(milliseconds: 250),
    super.curve = Curves.easeOut,
  });

  @override
  Widget build(
    BuildContext context,
    Animation<double> animation,
    ToastAlignment alignment,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(scale: animation, child: child),
    );
  }
}
