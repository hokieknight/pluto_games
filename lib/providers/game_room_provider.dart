import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_games/models/gameroom.dart';

GameRoom dummyGame = GameRoom(
  id: 'g1',
  name: 'Game 1',
  numPlayers: 2,
  gameType: GameType.tictactoe,
  createdAt: Timestamp.now(),
);

class GameRoomNotifier extends StateNotifier<GameRoom> {
  GameRoomNotifier()
      : super(
          GameRoom(
            id: '??',
            name: '??',
            numPlayers: 2,
            gameType: GameType.tictactoe,
            createdAt: Timestamp.now(),
          ),
        );

  void setGameRoom(GameRoom gameRoom) {
    state = gameRoom;
  }
}

final gameRoomProvider =
    StateNotifierProvider<GameRoomNotifier, GameRoom>((ref) {
  return GameRoomNotifier();
});
