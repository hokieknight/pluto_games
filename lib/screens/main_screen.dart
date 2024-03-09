import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_games/models/game_user.dart';
import 'package:pluto_games/providers/game_user_provider.dart';
import 'package:pluto_games/screens/create_game_screen.dart';
import 'package:pluto_games/screens/join_game_screen.dart';
import 'package:pluto_games/screens/settings_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  void logout() {
    FirebaseAuth.instance.signOut();
  }

  void _loadUser() async {
    final user = FirebaseAuth.instance.currentUser!;
    final gameUser = await GameUser.getRemote(user);
    ref.read(gameUserProvider.notifier).setUser(gameUser);
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Pluto Games'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => const SettingsScreen(),
                    ),
                  )
                },
                child: const Text("Settings"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => const CreateGameScreen(),
                    ),
                  )
                },
                child: const Text("Create Game"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => const JoinGameScreen(),
                    ),
                  )
                },
                child: const Text("Join Game"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: logout,
                child: const Text("Log Out"),
              ),
            ],
          ),
          //],
        ),
      ),
    );
  }
}
