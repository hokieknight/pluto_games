import 'package:flutter/material.dart';
import 'package:pluto_games/models/game_state.dart';

class GameInfoWidget extends StatelessWidget {
  final GameState gameState;

  const GameInfoWidget(this.gameState, {super.key});

  @override
  Widget build(BuildContext context) {
    final players = gameState.players;

    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(8),
      //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(4),
            padding: const EdgeInsets.all(8),
            //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
            child: Image.asset(
              'images/CoverSecretSith.jpg',
              height: 250,
              //width: 100,
              fit: BoxFit.fitHeight,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(4),
            padding: const EdgeInsets.all(4),
            //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Game ID: '), //aBmTuXAioWHuVKK1ymlk
                    SelectableText(gameState.id),
                  ],
                ),
                Text('Name: ${gameState.name}'),
                Text('#Players: ${players.length} / ${gameState.numPlayers}'),
                Container(
                  margin: const EdgeInsets.all(4),
                  padding: const EdgeInsets.all(8),
                  //decoration:
                  //    BoxDecoration(border: Border.all(color: Colors.red)),
                  width: 200,
                  height: 200,
                  child: ListView.builder(
                    //padding: const EdgeInsets.all(8),
                    itemCount: players.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Text(
                          'Player ${index + 1}: ${players[index]['name']}');
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    // Column(
    //   children: [
    //   ],
    // );
  }
}
