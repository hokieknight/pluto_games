import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_games/models/game_state.dart';

class GameStateNotifier extends StateNotifier<GameState> {
  GameStateNotifier()
      : super(
          GameState.newGame(
            name: "",
            numPlayers: 0,
            gameType: "",
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
