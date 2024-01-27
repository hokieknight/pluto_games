import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_games/models/game.dart';
import 'package:pluto_games/models/gameuser.dart';
import 'package:pluto_games/providers/game_user_provider.dart';

class CreateGameScreen extends ConsumerStatefulWidget {
  const CreateGameScreen({super.key});

  @override
  ConsumerState<CreateGameScreen> createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends ConsumerState<CreateGameScreen> {
  final _nameController = TextEditingController();
  GameType _selectedGameType = GameType.tictactoe;
  late GameUser _gameUser;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _createGame() {
    if (_nameController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text('Please enter valid name'),
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

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    _gameUser = ref.watch(gameUserProvider);
    _nameController.text = _gameUser.nickname;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Pluto Games - Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
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
                          label: Text('Nickname'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButton(
                          value: _selectedGameType,
                          items: GameType.values
                              .map(
                                (gameType) => DropdownMenuItem(
                                  value: gameType,
                                  child: Text(
                                    gameTypeNames[gameType]!,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              _selectedGameType = value;
                            });
                          }),
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
                            onPressed: _createGame,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                            child: const Text('Create Game'),
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
    );
  }
}
