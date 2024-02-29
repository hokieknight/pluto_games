import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_games/models/gameuser.dart';
import 'package:pluto_games/providers/game_user_provider.dart';
import 'package:pluto_games/screens/create_game_screen.dart';
import 'package:pluto_games/screens/settings_screen.dart';
//import 'package:pluto_games/models/gameuser.dart';

class MainScreen extends ConsumerStatefulWidget {
  //static String routeName = '/main';

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
    final gameUser = await FirebaseFirestore.instance
        .collection('game_users')
        .doc(user.uid)
        .get();

    if (gameUser.data() != null) {
      ref.read(gameUserProvider.notifier).setUser(
            GameUser(
              uid: user.uid,
              email: gameUser.data()!['email'],
              nickname: gameUser.data()!['nickname'] ?? '',
              imageUrl: gameUser.data()!['image_url'] ?? '',
            ),
          );
    } else {
      ref.read(gameUserProvider.notifier).setUser(
            GameUser(
              uid: user.uid,
              email: user.email!,
              nickname: '',
              imageUrl: '',
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadUser();
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
                onPressed: () => {},
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
