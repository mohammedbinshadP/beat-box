import 'package:beatabox/provider/onboarding_provider/onboarding.dart';
import 'package:beatabox/screens/mini_screens/splash_screen.dart';
import 'package:beatabox/model/fav_model.dart';
import 'package:beatabox/provider/songmodel_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!Hive.isAdapterRegistered(FavModelAdapter().typeId)) {
    Hive.registerAdapter(FavModelAdapter());
  }

  await Hive.initFlutter();
  await Hive.openBox<int>('FavoriteDB');
  await Hive.openBox<FavModel>('playlistDb');

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider(create:(context) => SongModelProvider(), ),
        ListenableProvider(create: (context) =>OnBoardingProvider(),)
      ],
      child: MaterialApp(
        title: 'BeatBox Music Player',
        theme: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 70, 40, 114)))),
          primarySwatch: Colors.blue,
        ),
        home:  SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
