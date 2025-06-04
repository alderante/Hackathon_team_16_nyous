// Packages
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:video_player/video_player.dart';
// import 'package:provider/provider.dart';

// Models
import 'package:hackatron_2/video/model/video.dart';

// Providers
// import 'package:hackatron_2/video/presentation/video_provider.dart';

// Animations
// import 'package:hackatron_2/video/presentation/play_pause_animation.dart';

typedef WidgetCallback = Future<Widget> Function(BuildContext? context, VideoPlayerController controller);

// https://www.youtube.com/watch?v=xAdmfbMOilw

class PortraitPlayerWidget extends StatefulWidget {
  const PortraitPlayerWidget({
    super.key,
    required this.path,
    this.isLooping = true,
    this.onFinish,
  });

  final String path;
  final bool isLooping;
  final WidgetCallback? onFinish;

  @override
  State<PortraitPlayerWidget> createState() => _PortraitPlayerWidgetState();
}

class _PortraitPlayerWidgetState extends State<PortraitPlayerWidget> {
  late VideoPlayerController _controller;
  late VoidCallback _videoListener;

  @override
  void initState() {
    super.initState();

    _videoListener = () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {});
        }
      });
    };

    // Asset local
    // _controller = VideoPlayerController.asset(widget.path)

    //* Get video from network
    _controller = VideoPlayerController.networkUrl(Uri.parse("https://storage.googleapis.com/nyous-final.firebasestorage.app/${widget.path}"))
      ..addListener(_videoListener)
      ..setLooping(true);

    VideoController.changeController(_controller);
  }

  @override
  void dispose() {
    //* Remove the video listener
    _controller.removeListener(_videoListener);

    //* Clear the VideoController if is remained saved
    if (VideoController.controller == _controller) {
      VideoController.clear();
    }
    else {
      _controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized ? GestureDetector(
      onTap: () {
        if (_controller.value.isPlaying) {
          _controller.pause();
        }
        else {
          _controller.play();
        }

        if (isFinished()) {
          _controller.seekTo(Duration(seconds: 0));
          _controller.play();
        }
      },
      child: SafeArea(
        child: Center(
          child: Stack(
            // fit: StackFit.expand,
            children: [
              // Possible Play and Pause buttons Animations
              // AnimatedOpacity(
              //   duration: const Duration(milliseconds: 750),
              //   opacity: _visible ? 1.0 : 0.0,
              //   child: PlayPauseAnimation(
              //     icon: const Icon(Icons.pause_circle_filled_rounded),
              //     duration: const Duration(milliseconds: 750),
              //     begin: 40,
              //     end: 80,
              //   ),
              // ),

              //* Video
              VisibilityDetector(
                key: ObjectKey(_controller),
                onVisibilityChanged: (visibility) {
                  if (!mounted) {
                    return ;
                  }
                  if (visibility.visibleFraction == 0) {
                    _controller.pause();
                  }
                  if (visibility.visibleFraction == 1.0) {
                    _controller.play();
                  }
                },
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),

              //* Pause Animation
              Center(
                child: AnimatedOpacity(
                  opacity: !_controller.value.isPlaying ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: Icon(Icons.pause_circle_filled_rounded,
                    size: 100.0,
                    color: Theme.of(context).colorScheme.primary.withAlpha(150),
                  ),
                ),
              ),

              //* onFinish Future<Widget> Callback
              // Video finished AND onFinish exist
              (isFinished() && widget.onFinish != null)
                // Get the Widget
                ? FutureBuilder<Widget>(
                  future: widget.onFinish!(mounted ? context : null, _controller),
                  builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                    //* Error/Data not loaded Management
                    if (snapshot.hasError || !snapshot.hasData
                      || snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    }

                    return snapshot.data ?? Container();
                  },
                )
                : Container(),

              // //* Slider video (Moved into VideoPage)
              // Positioned(
              //   bottom: 3,
              //   child: SizedBox(
              //     width: MediaQuery.of(context).size.width * 0.82,
              //     child: Slider(
              //       // Mouse Cursor
              //       mouseCursor: SystemMouseCursors.grab,

              //       // secondaryActiveColor: Theme.of(context).colorScheme.primary,
              //       // overlayColor: WidgetStatePropertyAll(Colors.amber),

              //       // padding: EdgeInsets.all(0.0),

              //       value: _controller.value.position.inSeconds.toDouble(),
              //       min: 0,
              //       max: _controller.value.duration.inSeconds.toDouble(),
              //       onChanged: (value) {
              //         setState(() {
              //           _controller.seekTo(Duration(seconds: value.toInt()));
              //         });
              //       },
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    ) : Center(
      //* Loading Indicator
      child: SizedBox(
        height: 120,
        width: 120,
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }

  //* Check if video finished
  bool isFinished() {
    final video = _controller.value;

    if (video.isCompleted
    || video.duration.inMilliseconds - video.position.inMilliseconds <= 100) {
      return true;
    }
    return false;
  }
}
