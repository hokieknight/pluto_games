import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_games/models/game.dart';

const Game dummyGame = Game(
  id: 'g1',
  name: 'Game 1',
  numPlayers: 2,
  gameType: GameType.tictactoe,
);

final gameProvider = Provider((ref) {
  return dummyGame;
});
