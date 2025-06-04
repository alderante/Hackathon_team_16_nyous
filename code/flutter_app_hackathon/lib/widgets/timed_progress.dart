import 'package:flutter/material.dart';


class TimedProgress extends StatefulWidget {
  const TimedProgress({
    super.key,
    this.duration = const Duration(seconds: 5),
    this.onFinish,
    this.finishExecutionTimes = 1,
  });

  final Duration duration;
  final VoidCallback? onFinish;
  final int finishExecutionTimes;

  @override
  State<TimedProgress> createState() => _TimedProgressState();
}

class _TimedProgressState extends State<TimedProgress> with TickerProviderStateMixin {
  late AnimationController _controller;
  int finishExecutionTimes = 0;

  @override
  void initState() {
    super.initState();

    // Initialize AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )
    ..addListener(() {
      setState(() {});
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.value == 1.0 && widget.onFinish != null
        && widget.finishExecutionTimes - finishExecutionTimes != 0) {
      widget.onFinish!();
      ++finishExecutionTimes;
    }

    return LinearProgressIndicator(
      value: _controller.value,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}