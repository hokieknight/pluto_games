import 'package:flutter/material.dart';
import 'package:pluto_games/models/game_state.dart';

class GameInfoWidget extends StatelessWidget {
  final GameState gameState;

  const GameInfoWidget(this.gameState, {super.key});

  @override
  Widget build(BuildContext context) {
    final players = gameState.players;

    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              //const Text('Game Type: '),
              Text(gameState.gameType),
            ],
          ),
          //const SizedBox(width: 10),
          Row(
            children: [
              const Text('# Players: '),
              Text('${players.length} / ${gameState.numPlayers}'),
            ],
          ),
          Row(
            children: [
              const Text('Game ID: '),
              SelectableText(gameState.id),
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
        ],
      ),
    );
  }
}
