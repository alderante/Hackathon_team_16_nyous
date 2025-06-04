// Packages
import 'dart:ui';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

//* Get Video model from Json
Video videoFromJson(String str) => Video.fromJson(json.decode(str));

//* Get Json from Video model
String videoToJson(Video data) => json.encode(data.toJson());

class Video {
  Video({
    required this.id,
    required this.body,
    required this.videoUrl,
  });

  String id;
  String body;
  String videoUrl;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
    id: json["id"] ?? "",
    body: json["body"] ?? "",
    videoUrl: json["videoUrl"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "body": body,
    "videoUrl": videoUrl,
  };
}

class VideoController extends ChangeNotifier {
  // VideoController._();

  static VideoPlayerController? controller;
  static VoidCallback? updateSlider;

  //* Getters
  static VideoPlayerValue? get value => controller?.value;
  static bool get isInitialized => controller?.value.isInitialized ?? false;

  //* Set the controller
  static Future<void> changeController(VideoPlayerController newController, {bool toClear = false}) async {
    //* Clear the controller before setting it
    if (toClear && controller != null) {
      await clear();
    }

    //* Initialize the controller if not already initialized
    try {
      if (!newController.value.isInitialized) {
        await newController.initialize();
      }
    } catch (e, stack) {
      log('Error on initialization of VideoController: $e\n$stack');
    }

    if (updateSlider != null) {
      controller?.removeListener(updateSlider!);
    }

    //* Set the new controller as current
    controller = newController;

    if (updateSlider != null) {
      controller?.addListener(updateSlider!);
    }
  }

  //* Get the position in double
  double getPosition() {
    if (controller == null) {
      return 0;
    }
    return value!.position.inSeconds.toDouble();
  }

  //* Get the duration in double
  double getDuration() {
    if (controller == null) {
      return 0;
    }
    return value!.duration.inSeconds.toDouble();
  }

  //* Play the video
  static Future<void> play() async {
    if (controller != null && controller!.value.isInitialized && !controller!.value.isPlaying) {
      await controller!.play();
    }
  }

  //* Pause the video
  static Future<void> pause() async {
    if (controller != null && controller!.value.isPlaying) {
      await controller!.pause();
    }
  }

  //* Dispose the controller and set it to null
  static Future<void> clear() async {
    if (controller != null) {
      await controller!.pause();
      await controller!.dispose();
      controller = null;
    }
  }
}
