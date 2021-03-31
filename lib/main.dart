import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallpap/home_page.dart';
import 'package:wallpap/wallpaper_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Flutter Demo',
      darkTheme: ThemeData.dark(),
      home: homePage(),
    );
  }
}
