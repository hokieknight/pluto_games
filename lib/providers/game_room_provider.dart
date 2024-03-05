import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_games/models/gameroom.dart';

class GameRoomNotifier extends StateNotifier<GameRoom> {
  GameRoomNotifier()
      : super(
          GameRoom(
            id: null,
            name: null,
            numPlayers: null,
            gameType: null,
            createdAt: null,
            players: null,
            messages: null,
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
