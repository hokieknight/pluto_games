import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_games/models/game_state.dart';
import 'package:pluto_games/models/game_user.dart';
import 'package:pluto_games/providers/game_state_provider.dart';
import 'package:pluto_games/providers/game_user_provider.dart';
import 'package:pluto_games/screens/lobby_screen.dart';

class JoinGameScreen extends ConsumerStatefulWidget {
  const JoinGameScreen({super.key});

  @override
  ConsumerState<JoinGameScreen> createState() => _JoinGameScreenState();
}

class _JoinGameScreenState extends ConsumerState<JoinGameScreen> {
  final _nameController = TextEditingController();
  final _gameIDController = TextEditingController();
  late GameUser gameUser;
  late GameState gameState;

  @override
  void dispose() {
    _nameController.dispose();
    _gameIDController.dispose();
    super.dispose();
  }

  void _joinGame() async {
    if (_nameController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text('Please enter valid user nickname'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('OK'),
            )
          ],
        ),
      );
      return;
    }

    if (_gameIDController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text('Please enter valid game name'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('OK'),
            )
          ],
        ),
      );
      return;
    }

    if (_nameController.text.trim() != gameUser.name) {
      gameUser.name = _nameController.text.trim();
      ref.read(gameUserProvider.notifier).setUser(gameUser);
      gameUser.saveRemote();
    }

    gameState = await GameState.getRemote(_gameIDController.text.trim());
    gameState.players.add(
      {'id': gameUser.uid, 'name': gameUser.name},
    );
    await gameState.setRemote();
    ref.read(gameStateProvider.notifier).setGameState(gameState);

    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const LobbyScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    gameUser = ref.watch(gameUserProvider);
    gameState = ref.watch(gameStateProvider);
    _nameController.text = gameUser.name;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Pluto Games - Join Game'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Icon(
                Icons.games,
                size: 50,
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Card(
                  margin: const EdgeInsets.all(20),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      //mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _nameController,
                          //maxLength: 50,
                          decoration: const InputDecoration(
                            label: Text('User Nickname'),
                          ),
                        ),
                        TextField(
                          controller: _gameIDController,
                          //maxLength: 50,
                          decoration: const InputDecoration(
                            label: Text('Game ID'),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: _joinGame,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                              child: const Text('Join Game'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
