import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_games/models/game_state.dart';
import 'package:pluto_games/models/game_user.dart';
import 'package:pluto_games/providers/game_state_provider.dart';
import 'package:pluto_games/providers/game_user_provider.dart';

class GameRoomWidget extends ConsumerStatefulWidget {
  const GameRoomWidget({super.key});

  @override
  ConsumerState<GameRoomWidget> createState() => _GameRoomWidgetState();
}

class _GameRoomWidgetState extends ConsumerState<GameRoomWidget> {
  late GameState _gameState;
  late GameUser _gameUser;

  void _leaveGame() async {
    NavigatorState nav = Navigator.of(context);
    nav.pop();
    nav.pop();

    _gameState.players!.removeWhere((item) => item['id'] == _gameUser.uid);
    await _gameState.setRemote();
    ref.read(gameStateProvider.notifier).setGameState(_gameState);
  }

  void _startGame() async {}

  @override
  Widget build(BuildContext context) {
    //final authenticatedUser = FirebaseAuth.instance.currentUser!;
    _gameState = ref.watch(gameStateProvider);
    _gameUser = ref.watch(gameUserProvider);

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('game_state')
          .doc(_gameState.id)
          .snapshots(),
      builder: (ctx, gameStateSnapshot) {
        if (gameStateSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!gameStateSnapshot.hasData) {
          return const Center(
            child: Text('Game not found.'),
          );
        }

        if (gameStateSnapshot.hasError) {
          return const Center(
            child: Text('Something went wrong...'),
          );
        }

        Map<String, dynamic>? data = gameStateSnapshot.data!.data();
        if (data == null) {
          return Center(
            child: Text('Game not found. ${_gameState.id}'),
          );
        }
        final players = data['players'] as List<dynamic>;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  //const Text('Game Type: '),
                  Text(data['gameType'].toString()),
                ],
              ),
              //const SizedBox(width: 10),
              Row(
                children: [
                  const Text('# Players: '),
                  Text('${players.length} / ${data['numPlayers'].toString()}'),
                ],
              ),
              Row(
                children: [
                  const Text('Game ID: '),
                  SelectableText(_gameState.id!),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: players.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Text('Player: ${players[index]['name']}');
                  },
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: _leaveGame,
                    child: const Text('Leave'),
                  ),
                  ElevatedButton(
                    onPressed: _startGame,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                    ),
                    child: const Text('Start Game'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
