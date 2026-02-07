import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';

import 'toast_alignment.dart';
import 'toast_animation.dart';
import 'toast_theme.dart';

export 'toast_alignment.dart';
export 'toast_animation.dart';

/// Manages the toast queue and orchestrates the showing and dismissing of toasts.
final class ToastManager {
  ToastManager._();

  static final instance = ToastManager._();

  final _queue = Queue<_ToastJob>();
  _ToastJob? _currentJob;

  ///The root overlay is the overlay provided by [WidgetsApp] and rarely gets dismounted
  late OverlayState _rootOverlayState;

  /// Shows a toast with the given [content] widget.
  ///
  /// The [context] must have an [Overlay] ancestor.
  ///
  /// Prefer using `showToast`, `showToastMessage`, `context.showToast` or `context.showToastMessage` over this.
  void show(
    BuildContext context, {
    Duration duration = const Duration(seconds: 3),
    ToastAnimation? animation,
    ToastAlignment? alignment,
    EdgeInsets? inset,
    bool isDismissible = true,
    bool ignorePointer = false,
    required Widget content,
  }) {
    final theme = ToastTheme.of(context);

    final themeInset = theme.insets ?? EdgeInsets.all(16);
    final themeAlignment = theme.alignment ?? .top;
    final themeAnimation = theme.animation ?? const ScaleAnimation();

    final key = GlobalKey<_ToastWidgetState>();
    _queue.add(
      _ToastJob(
        key: key,
        animation: animation ?? themeAnimation,
        duration: duration,
        alignment: alignment ?? themeAlignment,
        inset: inset ?? themeInset,
        isDismissible: isDismissible,
        ignorePointer: ignorePointer,
        content: content,
      ),
    );

    //refresh the root overlay state just in case the root [WidgetsApp] got switched
    _rootOverlayState = Overlay.of(context, rootOverlay: true);

    if (_currentJob == null) {
      _showNext();
    }
  }

  /// Dismiss the current toast on screen
  void dismiss() {
    _currentJob?.key.currentState?.hide();
  }

  /// Clear the queue of toasts.
  void clearQueue() {
    _queue.clear();
  }

  void _showNext() {
    if (_queue.isEmpty) {
      _currentJob = null;
      return;
    }

    _currentJob = _queue.removeFirst();

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _ToastWidget(
        key: _currentJob!.key,
        job: _currentJob!,
        onFinished: () {
          entry.remove();
          _showNext();
        },
      ),
    );
    _rootOverlayState.insert(entry);
  }
}

/// Holds all the information related to one toasts lifespan
class _ToastJob {
  final GlobalKey<_ToastWidgetState> key;
  final EdgeInsets inset;
  final Duration duration;
  final ToastAnimation animation;
  final ToastAlignment alignment;
  final bool isDismissible;
  final bool ignorePointer;
  final Widget content;

  _ToastJob({
    required this.key,
    required this.inset,
    required this.duration,
    required this.animation,
    required this.alignment,
    required this.isDismissible,
    required this.ignorePointer,
    required this.content,
  });
}

/// The internal widget wrapping the users toast.
class _ToastWidget extends StatefulWidget {
  final _ToastJob job;
  final VoidCallback onFinished;

  const _ToastWidget({
    required super.key,
    required this.job,
    required this.onFinished,
  });

  @override
  _ToastWidgetState createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  Timer? _timer;
  bool _hiding = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.job.animation.duration,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.job.animation.curve,
    );

    _controller.forward();
    _timer = Timer(widget.job.duration, hide);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void hide() {
    if (mounted && !_hiding) {
      _hiding = true;
      _timer?.cancel();
      _controller.reverse().whenComplete(() {
        if (mounted) {
          widget.onFinished();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _ToastPositioned(
      inset: widget.job.inset,
      alignment: widget.job.alignment,
      child: Center(
        child: widget.job.animation.build(
          context,
          _animation,
          widget.job.alignment,
          GestureDetector(
            onTap: widget.job.isDismissible ? hide : null,
            child: IgnorePointer(
              ignoring: widget.job.ignorePointer,
              child: widget.job.content,
            ),
          ),
        ),
      ),
    );
  }
}

/// Wraps child with a position based on [alignment]
class _ToastPositioned extends StatelessWidget {
  const _ToastPositioned({
    required this.inset,
    required this.alignment,
    required this.child,
  });

  final EdgeInsets inset;
  final Widget child;
  final ToastAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return switch (alignment) {
      .top => Positioned(
        top: inset.top,
        left: inset.left,
        right: inset.right,
        child: child,
      ),
      .topLeft => Positioned(top: inset.top, left: inset.left, child: child),
      .topRight => Positioned(top: inset.top, right: inset.right, child: child),
      .center => Positioned(
        top: inset.top,
        bottom: inset.bottom,
        left: inset.left,
        right: inset.right,
        child: child,
      ),
      .centerLeft => Positioned(
        top: inset.top,
        bottom: inset.bottom,
        left: inset.left,
        child: child,
      ),
      .centerRight => Positioned(
        top: inset.top,
        bottom: inset.bottom,
        right: inset.right,
        child: child,
      ),
      .bottomLeft => Positioned(
        bottom: inset.bottom,
        left: inset.left,
        child: child,
      ),
      .bottomRight => Positioned(
        bottom: inset.bottom,
        right: inset.right,
        child: child,
      ),
      _ => Positioned(
        bottom: inset.bottom,
        left: inset.left,
        right: inset.right,
        child: child,
      ),
    };
  }
}
