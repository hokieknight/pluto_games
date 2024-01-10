import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';

import 'package:pluto_games/screens/login_screen.dart';
import 'package:pluto_games/screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

final lightTheme = ThemeData.light().copyWith(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepPurple,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  ),
);

final darkTheme = ThemeData.dark().copyWith(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepPurple,
    brightness: Brightness.dark,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  ),
  //textTheme: GoogleFonts.latoTextTheme(),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pluto Games',
      darkTheme: darkTheme,
      theme: lightTheme,
      routes: {
        LoginScreen.routeName: (context) => const LoginScreen(),
        MainScreen.routeName: (context) => const MainScreen(),
        //JoinGameScreen.routeName: (context) => const JoinGameScreen(),
        //CreateGameScreen.routeName: (context) => const CreateGameScreen(),
        //GameScreen.routeName: (context) => const GameScreen(),
      },
      initialRoute: LoginScreen.routeName,
      //themeMode: ThemeMode.light,
    );
  }
}
