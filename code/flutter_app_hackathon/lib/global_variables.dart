import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

final ValueNotifier<int> userTriviaScore = ValueNotifier<int>(0);

final sfxPlayer = AudioPlayer();

const int triviaPoints = 10;

const Map<String, int> triviaScores = {
  'Fabio': 770,
  'Bianca': 420,
  'Claudio': 240,
  'Alessandro': 110,
  'Leonardo': 20,
  'Giada': 10,
  'Michele': 0
};