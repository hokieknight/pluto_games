import 'package:cloud_firestore/cloud_firestore.dart';

enum GameType { tictactoe, secretsith, uno, poker }

const gameTypeNames = {
  GameType.poker: 'Poker',
  GameType.secretsith: 'Secret Sith',
  GameType.tictactoe: 'Tic-Tac-Toe',
  GameType.uno: 'Uno',
};

class GameRoom {
  String? id;
  String? name;
  int? numPlayers;
  String? gameType;
  Timestamp? createdAt;
  List<dynamic>? players;
  List<dynamic>? messages;

  GameRoom.newGame({
    this.id = '-1',
    required this.name,
    required this.numPlayers,
    required this.gameType,
  })  : createdAt = Timestamp.now(),
        players = null,
        messages = null;

  GameRoom({
    required this.id,
    required this.name,
    required this.numPlayers,
    required this.gameType,
    required this.createdAt,
    required this.players,
    required this.messages,
  });

  factory GameRoom.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return GameRoom(
      id: data?['id'],
      name: data?['name'],
      numPlayers: data?['numPlayers'],
      gameType: data?['gameType'],
      createdAt: data?['createdAt'],
      players:
          data?['players'] is Iterable ? List.from(data?['players']) : null,
      messages:
          data?['messages'] is Iterable ? List.from(data?['messages']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (numPlayers != null) "numPlayers": numPlayers,
      if (gameType != null) "gameType": gameType,
      if (createdAt != null) "createdAt": createdAt,
      if (players != null) "players": players,
      if (messages != null) "messages": messages,
    };
  }

  Future<void> addRemote() async {
    await FirebaseFirestore.instance.collection('game_room').add({
      'name': name,
      'numPlayers': numPlayers,
      'gameType': gameType,
      'createdAt': Timestamp.now(),
      'players': players,
      'messages': messages,
    }).then((value) => id = value.id);
  }

  Future<void> setRemote() async {
    await FirebaseFirestore.instance.collection('game_room').doc(id).set({
      'name': name,
      'numPlayers': numPlayers,
      'gameType': gameType,
      'createdAt': createdAt,
      'players': players,
      'messages': messages,
    });
  }

  Future<GameRoom> getRemote(id) async {
    final ref = FirebaseFirestore.instance.collection('game_room').doc(id);
    //.withConverter(
    //  fromFirestore: GameRoom.fromFirestore,
    //  toFirestore: (GameRoom gameRoom, _) => gameRoom.toFirestore(),
    //);
    DocumentSnapshot doc = await ref.get();
    final data = doc.data() as Map<String, dynamic>;

    this.id = doc.id;
    name = data['name'];
    numPlayers = data['numPlayers'];
    gameType = data['gameType'];
    createdAt = data['createdAt'];
    players = data['players'];
    messages = data['messages'];

    return this;
  }
}
