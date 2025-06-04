import 'package:flutter/material.dart';

class PulsingScoreText extends StatefulWidget {
  final ValueNotifier<int> score;

  const PulsingScoreText({super.key, required this.score});

  @override
  State<PulsingScoreText> createState() => _PulsingScoreTextState();
}

class _PulsingScoreTextState extends State<PulsingScoreText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  int _lastScore = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 2.5)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_controller);

    widget.score.addListener(() {
      if (_lastScore != widget.score.value) {
        _lastScore = widget.score.value;
        _controller.forward(from: 0).then((_) => _controller.reverse());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: widget.score,
      builder: (context, score, _) {
        return AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Text(
                '$score',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
