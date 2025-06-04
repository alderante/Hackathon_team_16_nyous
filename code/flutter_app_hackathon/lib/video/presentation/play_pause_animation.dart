// import 'package:flutter/material.dart';

// class PlayPauseAnimation extends StatefulWidget {
//   const PlayPauseAnimation({
//     super.key,
//     required this.icon,
//     this.duration = const Duration(seconds: 1),
//     this.begin = 0,
//     this.end = 300,
//   });

//   final Widget icon;
//   final Duration duration;
//   final double begin;
//   final double end;

//   @override
//   State<PlayPauseAnimation> createState() => _PlayPauseAnimationState();
// }

// class _PlayPauseAnimationState extends State<PlayPauseAnimation> with SingleTickerProviderStateMixin {
//   late Animation<double> _animation;
//   late AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();

//     // Animation Duration
//     _controller = AnimationController(
//       duration: widget.duration,
//       vsync: this,
//     );

//     // Animation Effect Tween
//     _animation = Tween<double>(
//       begin: widget.begin,
//       end: widget.end
//     ).animate(_controller)
//       ..addListener(() {
//         setState(() {
//           // The state that has changed here is the animation object's value.
//         });
//       });
//     _controller.forward();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 10),
//         height: _animation.value,
//         width: _animation.value,
//         child: widget.icon,
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }