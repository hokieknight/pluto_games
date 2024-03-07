import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_games/models/game_state.dart';

class GameStateNotifier extends StateNotifier<GameState> {
  GameStateNotifier()
      : super(
          GameState(
            id: null,
            name: null,
            numPlayers: null,
            gameType: null,
            createdAt: null,
            players: null,
            messages: null,
            gameStarted: null,
          ),
        );

  void setGameState(GameState gameState) {
    state = gameState;
  }
}

final gameStateProvider =
    StateNotifierProvider<GameStateNotifier, GameState>((ref) {
  return GameStateNotifier();
});
