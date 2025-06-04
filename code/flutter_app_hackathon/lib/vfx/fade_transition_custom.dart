import 'package:flutter/material.dart';

class FadeTransitionCustom extends StatefulWidget {
  const FadeTransitionCustom({
    super.key,
    this.duration = const Duration(seconds: 1),
    this.animation,
    this.child,
  });

  final Duration duration;
  final Animatable<double>? animation;
  final Widget? child;

  @override
  State<FadeTransitionCustom> createState() => _FadeTransitionCustomState();
}

class _FadeTransitionCustomState extends State<FadeTransitionCustom> with TickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = (widget.animation ?? Tween(begin: 0.0, end: 1.0))
      .animate(_animController);

    _animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}