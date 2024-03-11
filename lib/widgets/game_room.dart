import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_games/models/game_state.dart';
import 'package:pluto_games/models/game_user.dart';
import 'package:pluto_games/models/sith_game_data.dart';
import 'package:pluto_games/models/snapshot_handler.dart';
import 'package:pluto_games/providers/game_state_provider.dart';
import 'package:pluto_games/providers/game_user_provider.dart';
import 'package:pluto_games/providers/sith_game_data_provider.dart';
import 'package:pluto_games/widgets/game_info.dart';
import 'package:pluto_games/widgets/sith_board.dart';

class GameRoomWidget extends ConsumerStatefulWidget {
  const GameRoomWidget({super.key});

  @override
  ConsumerState<GameRoomWidget> createState() => _GameRoomWidgetState();
}

class _GameRoomWidgetState extends ConsumerState<GameRoomWidget> {
  late GameState gameState;
  late GameUser gameUser;

  void _leaveGame() async {
    NavigatorState nav = Navigator.of(context);
    nav.pop();
    nav.pop();

    gameState.players.removeWhere((item) => item['id'] == gameUser.uid);
    await gameState.setRemote();
    ref.read(gameStateProvider.notifier).setGameState(gameState);
  }

  void _startGame() async {
    gameState.gameStarted = true;
    if (gameState.gameDataID.isEmpty) {
      if (gameState.gameType == 'Secret Sith') {
        SithGameData sithGameData = SithGameData.newGame(
            gameID: gameState.id, gamePlayers: gameState.players);
        await sithGameData.addRemote();
        ref.read(sithGameDataProvider.notifier).setSithGameData(sithGameData);
        gameState.gameDataID = sithGameData.id;
      }
    }

    await gameState.setRemote();
    ref.read(gameStateProvider.notifier).setGameState(gameState);
  }

  void _stopGame() async {
    gameState.gameStarted = false;
    await gameState.setRemote();
    ref.read(gameStateProvider.notifier).setGameState(gameState);
  }

  @override
  Widget build(BuildContext context) {
    //final authenticatedUser = FirebaseAuth.instance.currentUser!;
    gameState = ref.watch(gameStateProvider);
    gameUser = ref.watch(gameUserProvider);

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('game_state')
          .doc(gameState.id)
          .snapshots(),
      builder: (ctx, snapshot) {
        Widget? widget = handleSnapshot(snapshot, "Sith Game");
        if (widget != null) return widget;

        Map<String, dynamic>? data = snapshot.data!.data();
        gameState = GameState.fromJson(gameState.id, data!);

        Widget gameWidget = GameInfoWidget(gameState);
        if (gameState.gameStarted) {
          if (gameState.gameType == "Secret Sith") {
            gameWidget = const SithBoard();
          }
        }

        return Container(
          margin: const EdgeInsets.all(2),
          padding: const EdgeInsets.all(2),
          //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
          child: Column(
            children: [
              gameWidget,
              Container(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(4),
                //decoration:
                //    BoxDecoration(border: Border.all(color: Colors.red)),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: _leaveGame,
                      child: const Text('Leave'),
                    ),
                    ElevatedButton(
                      onPressed: gameState.gameStarted ? _stopGame : _startGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                      ),
                      child: Text(
                          gameState.gameStarted ? 'Stop Game' : 'Start Game'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
