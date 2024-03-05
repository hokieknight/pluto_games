import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_games/models/gameroom.dart';
import 'package:pluto_games/models/gameuser.dart';
import 'package:pluto_games/providers/game_room_provider.dart';
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
  late GameUser _gameUser;
  late GameRoom _gameRoom;

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

    if (_nameController.text.trim() != _gameUser.nickname) {
      _gameUser.nickname = _nameController.text.trim();
      ref.read(gameUserProvider.notifier).setUser(_gameUser);
      _gameUser.saveRemote();
    }

    await _gameRoom.getRemote(_gameIDController.text.trim());
    _gameRoom.players ??= [];
    _gameRoom.players!.add(
      {'id': _gameUser.uid, 'name': _gameUser.nickname},
    );
    await _gameRoom.setRemote();
    ref.read(gameRoomProvider.notifier).setGameRoom(_gameRoom);

    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const LobbyScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _gameUser = ref.watch(gameUserProvider);
    _gameRoom = ref.watch(gameRoomProvider);
    _nameController.text = _gameUser.nickname;

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
