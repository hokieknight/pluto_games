import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_games/models/gameroom.dart';
import 'package:pluto_games/providers/game_room_provider.dart';

class GameRoomWidget extends ConsumerStatefulWidget {
  const GameRoomWidget({super.key});

  @override
  ConsumerState<GameRoomWidget> createState() => _GameRoomWidgetState();
}

class _GameRoomWidgetState extends ConsumerState<GameRoomWidget> {
  late GameRoom _gameRoom;

  @override
  Widget build(BuildContext context) {
    //final authenticatedUser = FirebaseAuth.instance.currentUser!;
    _gameRoom = ref.watch(gameRoomProvider);

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('game_room')
          .doc(_gameRoom.id)
          .snapshots(),
      builder: (ctx, gameRoomSnapshot) {
        if (gameRoomSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!gameRoomSnapshot.hasData) {
          return const Center(
            child: Text('Game Room not found.'),
          );
        }

        if (gameRoomSnapshot.hasError) {
          return const Center(
            child: Text('Something went wrong...'),
          );
        }

        final data = gameRoomSnapshot.data!.data() as Map<String, dynamic>;
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
                  SelectableText(_gameRoom.id),
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
      },
    );
  }
}
