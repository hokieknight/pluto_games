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
      builder: (ctx, chatSnapshots) {
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!chatSnapshots.hasData) {
          return const Center(
            child: Text('Game Room not found.'),
          );
        }

        if (chatSnapshots.hasError) {
          return const Center(
            child: Text('Something went wrong...'),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                  'Game Type: ${chatSnapshots.data!.data()!['gameType'].toString()}'),
              //const SizedBox(width: 10),
              Text(
                  '# Players: ${chatSnapshots.data!.data()!['numPlayers'].toString()}'),
              Text('Game ID: ${_gameRoom.id}'),
            ],
          ),
        );
      },
    );
  }
}
