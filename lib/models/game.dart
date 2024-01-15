enum GameType { tictactoe, secretsith, uno, poker }

const gameTypeNames = {
  GameType.poker: 'Poker',
  GameType.secretsith: 'Secret Sith',
  GameType.tictactoe: 'Tic-Tac-Toe',
  GameType.uno: 'Uno',
};

class Game {
  const Game({
    required this.id,
    required this.name,
    required this.gameType,
    required this.numPlayers,
  });

  final String id;
  final String name;
  final int numPlayers;
  final GameType gameType;
}
