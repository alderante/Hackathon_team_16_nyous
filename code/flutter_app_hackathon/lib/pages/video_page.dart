// Packages
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackatron_2/global_variables.dart';
import 'package:hackatron_2/pages/leader_board_page.dart';
import 'package:hackatron_2/pages/indepth_page.dart';
// import 'package:redacted/redacted.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';

// Providers
// import 'package:hackatron_2/video/presentation/video_provider.dart';

// Model
import 'package:hackatron_2/video/model/video.dart';
import 'package:hackatron_2/trivia/model/trivia.dart';
import 'package:hackatron_2/database/model/database.dart';

// Helpers
import 'package:hackatron_2/helpers/duration.dart';

// Widgets
import 'package:hackatron_2/vfx/pulse_score.dart';
import 'package:hackatron_2/vfx/fade_transition_custom.dart';
import 'package:hackatron_2/video/presentation/portrait_player_widget.dart';
import 'package:hackatron_2/trivia/presentation/trivia_card.dart';

/*
    - Page have 2 buttons:

      - Top-Left
        Trophy icon with leaderboard position

      - Bottom-Right
        AI icon
        OnTap: Open InDepthPage
*/

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late PageController pageController;
  int selectedPage = 0;
  int totalPages = 0;

  //* Get a list of Video
  List<Video> mapRecords(QuerySnapshot<Object?>? records) {
    return records?.docs.map((video) => Video(
      id: video.id,
      body: video['body'],
      videoUrl: video['videoUrl'],
    )).toList()
    ?? [];
  }

  //* Go to next page
  void goToNextPage() {
    final nextPage = selectedPage + 1 < totalPages
      ? selectedPage + 1
      : 0;

    log('--------------------');
    log('TotalPages: $totalPages');
    log('selectedPage: $selectedPage');
    log('nextPage: $nextPage');

    pageController.animateToPage(
      nextPage,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    selectedPage = nextPage;
  }

  @override
  void initState() {
    super.initState();

    //* Initialize PageController
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //* TOP SECTION: Logo
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 70,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Center(
          child: Image(
            image: AssetImage('assets/logo_transparent.png'),
            height: MediaQuery.of(context).size.height * 0.08
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Stack(
          children: [
            //* Video Page Builder
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('hack_news').snapshots(),
              builder: (context, snapshot) {
                // Error management
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
            
                if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
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
            
                List<Video> data = mapRecords(snapshot.data);

                if (Database.newsId == null) {
                  Database.setNewsId(newsId: data[0].id);
                }

                //* Save N of pages
                totalPages = data.length;

                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: PageView.builder(
                    controller: pageController,
                    scrollDirection: Axis.vertical,

                    onPageChanged: (value) {
                      selectedPage = value;
                      Database.setNewsId(newsId: data[value].id);
                    },

                    //* N of videos
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      // newsId = data[index].id;
                      return VideoTile(data: data[index]);
                    },
                    // Old PageView's children (with local use)
                    // children: [
                    //   VideoTile(path: 'assets/videos/video1.mp4'),
                    //   VideoTile(path: 'assets/videos/video2.mp4'),
                    //   VideoTile(path: 'assets/videos/news_1.mp4'),
                    //   VideoTile(path: 'assets/videos/news_2.mp4'),
                    // ],
                  ),
                );
              }
            ),

            //* TOP LEFT: Leaderboard Button
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 0.0),
              child: FloatingActionButton(
                onPressed: () async {
                  await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LeaderboardPage(),
                  ),
                );
                }, // Placeholder: Add the Leaderboard placement
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                heroTag: "HeroLeaderboard",
                tooltip: "Leaderboard",
                child: Column(children:[
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Icon(
                        Icons.leaderboard_rounded,
                        color: Theme.of(context).colorScheme.primary
                      ),
                    )
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ValueListenableBuilder<int>(
                        valueListenable: userTriviaScore,
                        builder: (context, value, child) {
                          return PulsingScoreText(score: userTriviaScore);
                        },
                      ),
                    ),
                  )
                ]) 
              ),
            ),

            //* BOTTOM: Slider and AI button
            VideoBottomBar(),
          ],
        ),
      ),
    );
  }
}

class VideoTile extends StatelessWidget {
  const VideoTile({
    super.key,
    required this.data,
  });

  final Video data;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //* TOP SECTION: Logo (Moved to AppBar)
        // Container(
        //   color: Theme.of(context).colorScheme.primary,
        //   width: double.infinity,
  
        //   child: Image(
        //     image: AssetImage('assets/logo_transparent.png'),
        //     height: MediaQuery.of(context).size.height * 0.08
        //   ),
        // ),

        //* VideoPlayer
        PortraitPlayerWidget(
          path: data.videoUrl,
          onFinish: (BuildContext? context, VideoPlayerController controller) async {
            //* Pause Video
            controller.pause();

            //* Get data from DB
            final widgetTrivia = await FirebaseFirestore.instance
              .collection('hack_trivia')
              .where('hack_news_id', isEqualTo: data.id).get()
              .then((querySnapshot) {
                final snapshot = querySnapshot.docs.first;

                // log('Creating Trivia');
                // log('id: ${snapshot.id}');
                // log("question: ${snapshot['question']}");
                // log("wrondAnswers: ${snapshot['wrong_answers']}");
                // log("rightAnswer: ${snapshot['right_answer']}");
                // log('-----------------------------------------------');

                final Trivia trivia = Trivia(
                  id: snapshot.id,
                  question: snapshot['question'],
                  wrongAnswers: List<String>.from(snapshot['wrong_answers'] ?? []),
                  rightAnswer: snapshot['right_answer'],
                );

                // //* Get and Shuffle answers
                // final List<String> answers = List<String>
                //   .of(trivia.wrongAnswers)
                //   ..add(trivia.rightAnswer)
                //   ..shuffle();

                // log('-----------------------------------------------');
                // log(trivia.id);
                // log(trivia.question);
                // log(answers);
                // log('-----------------------------------------------');

                return FadeTransitionCustom(
                  duration: Duration(milliseconds: 750),
                  child: TriviaCard(
                    trivia: trivia,
                  ),
                );
              },
              onError: (e) {
                return Text('Error DB: $e');
              }
            );

            return widgetTrivia;
          }
        ),
      ]
    );
  }
}

//* Bottom bar of Video
class VideoBottomBar extends StatefulWidget {
  const VideoBottomBar({
    super.key,
  });

  @override
  State<VideoBottomBar> createState() => _VideoBottomBarState();
}

class _VideoBottomBarState extends State<VideoBottomBar> {

  @override
  void initState() {
    super.initState();

    //* Initialize UpdateSlider
    VideoController.updateSlider = () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {});
        }
      });
    };
  }

  @override
  void dispose() {
    //* Remove UpdateSlider
    if (VideoController.updateSlider != null) {
      VideoController.controller?.removeListener(VideoController.updateSlider!);
    }
    VideoController.updateSlider = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.of(context).size.height * 0.01,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withAlpha(200),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: VideoController.isInitialized
              ? SizedBox(
              width: MediaQuery.of(context).size.width * 0.72,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //* Video Position
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                    decoration: BoxDecoration(
                      // color: Theme.of(context).colorScheme.primary.withAlpha(200),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(formatDuration(VideoController.value!.position),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  //* Slider
                  Expanded(
                    child: VideoSlider(),
                  ),
                  //* Video Duration
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                    decoration: BoxDecoration(
                      // color: Theme.of(context).colorScheme.primary.withAlpha(200),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(formatDuration(VideoController.value!.duration),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )
            : Container(width: MediaQuery.of(context).size.width * 0.72),
          ),
          //* RIGHT: AI button
          Align(
            alignment: Alignment.center,
            child: FloatingActionButton(
              onPressed: () async {
                Trivia.stop = true;

                //* Get the goToNextPage function for future use
                final goToNextPage = context.findAncestorStateOfType<_VideoPageState>()?.goToNextPage;

                //* Go to InDepthPage, with argument newsId
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InDepthPage(),
                  ),
                );
                // Navigator.pushNamed(context, '/indepth', arguments: Database.newsId);

                if (mounted && goToNextPage != null) {
                  goToNextPage();
                }
              },
              heroTag: "HeroAI",
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              child: Icon(Icons.app_shortcut_outlined, color: Theme.of(context).colorScheme.primary),
            ),
          )
        ],
      ),
    );
  }
}

//* Slider of Video
class VideoSlider extends StatefulWidget {
  const VideoSlider({super.key});

  @override
  State<VideoSlider> createState() => _VideoSliderState();
}

class _VideoSliderState extends State<VideoSlider> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    //* Remove UpdateSlider
    // if (VideoController.updateSlider != null) {
    //   VideoController.controller?.removeListener(VideoController.updateSlider!);
    // }
    // VideoController.updateSlider = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final VideoController controller = context.watch<VideoController>();

    return Slider(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      // Mouse Cursor
      mouseCursor: SystemMouseCursors.grab,

      // secondaryActiveColor: Theme.of(context).colorScheme.primary,
      // overlayColor: WidgetStatePropertyAll(Colors.amber),

      // padding: EdgeInsets.all(0.0),

      value: controller.getPosition().clamp(0.0, controller.getDuration()),
      min: 0,
      max: controller.getDuration(),
      onChanged: (value) {
        setState(() {
          VideoController.controller?.seekTo(Duration(seconds: value.toInt()));
        });
      },
      onChangeEnd: (value) {
        VideoController.controller?.seekTo(Duration(seconds: value.toInt()));
      },
    );
  }
}
