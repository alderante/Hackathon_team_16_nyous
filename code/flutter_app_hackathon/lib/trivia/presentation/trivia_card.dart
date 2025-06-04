// Packages
import 'dart:async';
import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hackatron_2/global_variables.dart';
import 'package:hackatron_2/video/model/video.dart';

// Widgets
import 'package:hackatron_2/widgets/timed_progress.dart';

// Models
import 'package:hackatron_2/trivia/model/trivia.dart';

typedef MethodBuilder = void Function(BuildContext context, void Function() methodFromChild);

bool isClosing = false;

void closeTrivia({Duration time = const Duration(seconds: 5)}) {
  // Already closing
  if (isClosing) {
    return ;
  }

  //* Lock the closing functions
  isClosing = true;

  //* After 'time' passed, reset the video controller (and close the Trivia)
  Timer(time, () {
    if (Trivia.stop) {
      return ;
    }

    log("-------------- Exiting Trivia --------------\n");
    VideoController.controller?.seekTo(const Duration(seconds: 0));
    VideoController.controller?.play();
  });
}

class TriviaCard extends StatelessWidget {
  const TriviaCard({
    super.key,
    required this.trivia,
  });

  final Trivia trivia;

  @override
  Widget build(BuildContext context) {
    isClosing = false;

    return Center(
      child: Card(
        color: Colors.transparent,
        shadowColor: Theme.of(context).shadowColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(42)),
        margin: EdgeInsets.all(10),
        child: Container(
          height: 500,
          width: MediaQuery.of(context).size.width * 0.85,
          padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(42),
            color: Theme.of(context).cardColor,
            border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
            boxShadow: [BoxShadow(offset: Offset(10, 10), color: Theme.of(context).shadowColor.withAlpha(200))],
          ),
          child: TriviaContent(trivia: trivia),
        ),
      ),
    );
  }
}

class TriviaContent extends StatelessWidget {
  const TriviaContent({
    super.key,
    required this.trivia,
  });

  final Trivia trivia;

  @override
  Widget build(BuildContext context) {
    late void Function() showRightAnswer;

    //* Join answers in a single list and shuffle
    final List<AnswerButton> answerButtons = [
      AnswerButton(
        answer: trivia.wrongAnswers[0],
        trivia: trivia,
        onPressed: () async {
          await sfxPlayer.play(AssetSource('sounds/trivia_answer_wrong.mp3'));
          showRightAnswer.call();
        }
      ),
      AnswerButton(
        answer: trivia.wrongAnswers[1],
        trivia: trivia,
        onPressed: () async {
          await sfxPlayer.play(AssetSource('sounds/trivia_answer_wrong.mp3'));
          showRightAnswer.call();
        }
      ),
      AnswerButton(
        answer: trivia.rightAnswer,
        trivia: trivia,
        builder: (BuildContext context, void Function() method) {
          showRightAnswer = method;
        },
        onPressed: () async {
          await sfxPlayer.play(AssetSource('sounds/trivia_answer_correct.mp3'));
          userTriviaScore.value += triviaPoints;
          log(userTriviaScore.toString());
        }
      ),
    ]
    ..shuffle();

    return Column(
      spacing: 10,
      children: [
        //* Question
        Expanded(
          child: SelectableText(trivia.question,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 26
            ),
          ),
        ),

        //* Answers
        answerButtons[0],
        answerButtons[1],
        answerButtons[2],

        //* Timer Progress
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 8.0),
          child: TimedProgress(
            duration: const Duration(seconds: 10),
            onFinish: () {
              if (isClosing || Trivia.stop) {
                return ;
              }
              //* Time finished
              WidgetsBinding.instance.addPostFrameCallback((_){
                showRightAnswer.call();
              });
              closeTrivia();
            }
          ),
        ),
      ],
    );
  }
}

class AnswerButton extends StatefulWidget {
  const AnswerButton({
    super.key,
    required this.answer,
    required this.trivia,
    this.builder,
    this.onPressed,
  });

  final String answer;
  final Trivia trivia;
  final MethodBuilder? builder;
  final VoidCallback? onPressed;

  @override
  State<AnswerButton> createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<AnswerButton> {
  late ButtonStyle buttonStyle;
  bool? isRight;

  @override
  Widget build(BuildContext context) {
    widget.builder?.call(context, show);

    buttonStyle = Theme.of(context).textButtonTheme.style!.copyWith(
      backgroundColor:
        (isRight == null)
        ? Theme.of(context).textButtonTheme.style!.backgroundColor
        : WidgetStatePropertyAll<Color>(
          isRight == true
          ? Colors.green  // Right Answer
          : Colors.red    // Wrong Answer
        ),
      minimumSize: WidgetStatePropertyAll<Size>(Size(double.infinity, 78)),
      fixedSize: WidgetStatePropertyAll<Size>(Size(double.infinity, 78)),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: [BoxShadow(offset: Offset(3, 3), color: Theme.of(context).shadowColor.withAlpha(200))],
      ),
      child: TextButton(
        style: buttonStyle,
        onPressed: () {
          if (isClosing) {
            return ;
          }

          //* Change button color
          show();
          widget.onPressed?.call();

          closeTrivia();
        },
        child: Text(widget.answer,
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
      ),
    );
  }

  void show() {
    setState(() {
      isRight = widget.trivia.isRightAnswer(widget.answer);
    });
  }
}
