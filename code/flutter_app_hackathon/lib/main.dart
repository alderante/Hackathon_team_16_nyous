// Packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

// Providers
import 'package:hackatron_2/chat/presentation/chat_provider.dart';
import 'package:hackatron_2/video/model/video.dart';
// import 'package:hackatron_2/video/presentation/video_provider.dart';

// Pages
import 'package:hackatron_2/pages/video_page.dart';
import 'package:hackatron_2/pages/indepth_page.dart';
import 'package:hackatron_2/pages/leader_board_page.dart';

// Themes
import 'package:hackatron_2/themes/themes.dart';

// Templates
// import 'package:hackatron_2/video/templates/nyous_temp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Disable Invalid Value Type check
  Provider.debugCheckInvalidValueType = null;

  // Lock screen orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Firebase
  await Firebase.initializeApp();

  // Start the App
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ChatProvider()),
      ChangeNotifierProvider(create: (_) => VideoController()),
      // ChangeNotifierProvider(create: (_) => VideoProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  // Root of the application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hackatron',

      // Debug Banner OFF
      debugShowCheckedModeBanner: false,

      //* App Themes
      theme: Themes.lightTheme(),
      darkTheme: Themes.darkTheme(),

      //* Routes Setup for Navigator
      initialRoute: '/video',
      routes: {
        '/video': (context) => const VideoPage(),
        '/indepth': (context) => const InDepthPage(),
        '/leaderboard': (context) => const LeaderboardPage()
        // '/nyous_temp': (context) => const NyousTemplate(),
      },
      // home: VideoPage(),
    );
  }
}
