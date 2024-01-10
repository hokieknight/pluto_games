import 'package:flutter/material.dart';
import 'package:pluto_games/screens/new_game_screen.dart';

class MainScreen extends StatefulWidget {
  static String routeName = '/main';

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  void logout() {
    Navigator.pop(context);
  }

  void createGame() {
    showModalBottomSheet(
      context: context,
      //isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => const NewGameScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Pluto Games'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => {},
              child: const Text("Settings"),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: createGame,
              child: const Text("Create Game"),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => {},
              child: const Text("Join Game"),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: logout,
              child: const Text("Sign Out"),
            ),
          ],
        ),
      ),
    );
  }
}
