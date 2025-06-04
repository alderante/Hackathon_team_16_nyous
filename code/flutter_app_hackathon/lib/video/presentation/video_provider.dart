// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class VideoProvider extends ChangeNotifier {
//   late VideoPlayerController _controller;
//   bool _isInitialized = false;
//   bool _isBuffering = false;

//   VideoPlayerController get controller => _controller;
//   bool get isInitialized => _isInitialized;
//   bool get isPlaying => _controller.value.isPlaying;
//   bool get isBuffering => _isBuffering;

//   Duration get position => _controller.value.position;
//   Duration get duration => _controller.value.duration;

//   Future<void> load(String videoUrl) async {
//     _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));

//     _controller.addListener(() {
//       final buffering = _controller.value.isBuffering;
//       if (buffering != _isBuffering) {
//         _isBuffering = buffering;
//         notifyListeners();
//       }
//     });

//     await _controller.initialize();
//     _isInitialized = true;
//     notifyListeners();
//   }

//   void playPause() {
//     if (_controller.value.isPlaying) {
//       _controller.pause();
//     } else {
//       _controller.play();
//     }
//     notifyListeners();
//   }

//   void play() {
//     if (!_controller.value.isPlaying) {
//       _controller.play();
//       notifyListeners();
//     }
//   }

//   void pause() {
//     if (_controller.value.isPlaying) {
//       _controller.pause();
//       notifyListeners();
//     }
//   }

//   void seekTo(Duration position) {
//     _controller.seekTo(position);
//     notifyListeners();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }
