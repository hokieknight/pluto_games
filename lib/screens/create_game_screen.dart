import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_games/models/game_state.dart';
import 'package:pluto_games/models/game_user.dart';
import 'package:pluto_games/providers/game_state_provider.dart';
import 'package:pluto_games/providers/game_user_provider.dart';
import 'package:pluto_games/screens/game_room_screen.dart';

class CreateGameScreen extends ConsumerStatefulWidget {
  const CreateGameScreen({super.key});

  @override
  ConsumerState<CreateGameScreen> createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends ConsumerState<CreateGameScreen> {
  final _nameController = TextEditingController();
  final _gameNameController = TextEditingController();
  final _numPlayersController = TextEditingController();
  GameType _selectedGameType = GameType.tictactoe;
  late GameUser _gameUser;

  @override
  void dispose() {
    _nameController.dispose();
    _gameNameController.dispose();
    _numPlayersController.dispose();
    super.dispose();
  }

  void _createGame() async {
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

    if (_gameNameController.text.trim().isEmpty) {
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

    var numPlayers = int.tryParse(_numPlayersController.text.trim());
    if (numPlayers == null || numPlayers < 2) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text('Please enter valid # of players'),
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

    if (_nameController.text.trim() != _gameUser.name) {
      _gameUser.name = _nameController.text.trim();
      ref.read(gameUserProvider.notifier).setUser(_gameUser);
      _gameUser.saveRemote();
    }

    GameState gameState = GameState.newGame(
      name: _gameNameController.text.trim(),
      gameType: gameTypeNames[_selectedGameType]!,
      numPlayers: numPlayers,
    );
    gameState.players.add(
      {'id': _gameUser.uid, 'name': _gameUser.name},
    );
    await gameState.addRemote();
    ref.read(gameStateProvider.notifier).setGameState(gameState);

    //Navigator.pop(context);
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const GameRoomScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _gameUser = ref.watch(gameUserProvider);
    _nameController.text = _gameUser.name;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Pluto Games - Create Game'),
        leading: Image.asset('images/my-pluto-2.png'),
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
                          controller: _gameNameController,
                          //maxLength: 50,
                          decoration: const InputDecoration(
                            label: Text('Game Name'),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _numPlayersController,
                          decoration: const InputDecoration(
                            label: Text('# Players'),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
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
      ),
    );
  }
}
