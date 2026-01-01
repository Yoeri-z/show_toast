import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';

import 'toast_theme.dart';

/// Denotes the alignment of the toast on the screen.
enum ToastAlignment {
  top,
  bottom,
  center,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  centerLeft,
  centerRight,
}

/// Manages the toast queue and orchestrates the showing and dismissing of toasts.
class ToastManager {
  static final _queue = Queue<_ToastJob>();
  static _ToastJob? _currentJob;

  /// Shows a toast with the given [content] widget.
  ///
  /// The [context] must have an [Overlay] ancestor.
  ///
  /// Prefer using `showToast`, `showToastMessage`, `context.showToast` or `context.showToastMessage` over this.
  static void show(
    BuildContext context, {
    Duration duration = const Duration(seconds: 3),
    Duration fadeDuration = const Duration(milliseconds: 350),
    ToastAlignment? alignment,
    EdgeInsets? inset,
    bool isDismissible = true,
    bool ignorePointer = false,
    required Widget content,
  }) {
    final theme = ToastTheme.of(context);

    final themeInset = theme.insets ?? EdgeInsets.all(16);
    final themeAlignment = theme.alignment ?? ToastAlignment.bottom;

    final key = GlobalKey<_ToastWidgetState>();
    _queue.add(
      _ToastJob(
        key: key,
        fadeDuration: fadeDuration,
        context: context,
        duration: duration,
        alignment: alignment ?? themeAlignment,
        inset: inset ?? themeInset,
        isDismissible: isDismissible,
        ignorePointer: ignorePointer,
        content: content,
      ),
    );

    if (_currentJob == null) {
      _showNext();
    }
  }

  /// Dismiss the current toast on screen
  static void dismiss() {
    _currentJob?.key.currentState?.hide();
  }

  /// Clear the queue of toasts.
  static void clearQueue() {
    _queue.clear();
  }

  static void _showNext() {
    if (_queue.isEmpty) {
      _currentJob = null;
      return;
    }

    _currentJob = _queue.removeFirst();

    if (!_currentJob!.context.mounted) {
      _showNext();
      return;
    }

    final overlay = Overlay.of(_currentJob!.context);

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _ToastWidget(
        key: _currentJob!.key,
        job: _currentJob!,
        onFinished: () {
          entry.remove();
          _currentJob = null;
          _showNext();
        },
      ),
    );
    overlay.insert(entry);
  }
}

/// Holds all the information related to one toasts lifespan
class _ToastJob {
  final GlobalKey<_ToastWidgetState> key;
  final BuildContext context;
  final EdgeInsets inset;
  final Duration duration;
  final Duration fadeDuration;
  final ToastAlignment alignment;
  final bool isDismissible;
  final bool ignorePointer;
  final Widget content;

  _ToastJob({
    required this.key,
    required this.inset,
    required this.context,
    required this.duration,
    required this.fadeDuration,
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

class _ToastWidgetState extends State<_ToastWidget> {
  var _opacity = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => setState(() => _opacity = 1.0),
    );
    _timer = Timer(widget.job.duration, hide);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void hide() {
    if (mounted) {
      _timer?.cancel();
      setState(() => _opacity = 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _ToastPositioned(
      inset: widget.job.inset,
      alignment: widget.job.alignment,
      child: Center(
        child: GestureDetector(
          onTap: widget.job.isDismissible ? hide : null,
          child: IgnorePointer(
            ignoring: widget.job.ignorePointer,
            child: AnimatedOpacity(
              opacity: _opacity,
              duration: widget.job.fadeDuration,
              onEnd: () {
                if (_opacity == 0.0) widget.onFinished();
              },
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
