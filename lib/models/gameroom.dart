import 'package:cloud_firestore/cloud_firestore.dart';

enum GameType { tictactoe, secretsith, uno, poker }

const gameTypeNames = {
  GameType.poker: 'Poker',
  GameType.secretsith: 'Secret Sith',
  GameType.tictactoe: 'Tic-Tac-Toe',
  GameType.uno: 'Uno',
};

class GameRoom {
  String id;
  final String name;
  final int numPlayers;
  final GameType gameType;
  final Timestamp createdAt;
  var players = [];
  var messages = [];

  GameRoom({
    this.id = '-1',
    required this.name,
    required this.gameType,
    required this.numPlayers,
    required this.createdAt,
  });

  Future<void> addRemote() async {
    await FirebaseFirestore.instance.collection('game_room').add({
      'name': name,
      'numPlayers': numPlayers,
      'gameType': gameTypeNames[gameType],
      'createdAt': Timestamp.now(),
      'players': players,
      'messages': messages,
    }).then((value) => id = value.id);
  }

  Future<void> setRemote() async {
    await FirebaseFirestore.instance.collection('game_room').doc(id).set({
      'name': name,
      'numPlayers': numPlayers,
      'gameType': gameTypeNames[gameType],
      'createdAt': Timestamp.now(),
      'players': players,
      'messages': messages,
    });
  }
}
