import 'package:flutter/material.dart';

class GameInfoWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  final String gameID;

  const GameInfoWidget({super.key, required this.gameID, required this.data});

  @override
  Widget build(BuildContext context) {
    final players = data['players'] as List<dynamic>;

    return Expanded(
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
              //SelectableText(_gameState.id!),
              SelectableText(gameID),
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
