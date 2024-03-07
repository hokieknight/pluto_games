import 'package:cloud_firestore/cloud_firestore.dart';

enum GameType { tictactoe, secretsith, uno, poker }

const gameTypeNames = {
  GameType.poker: 'Poker',
  GameType.secretsith: 'Secret Sith',
  GameType.tictactoe: 'Tic-Tac-Toe',
  GameType.uno: 'Uno',
};

class GameState {
  String? id;
  String? name;
  int? numPlayers;
  String? gameType;
  Timestamp? createdAt;
  List<dynamic>? players;
  List<dynamic>? messages;
  bool? gameStarted;
  String? gameDataID;

  GameState.newGame({
    this.id = '-1',
    required this.name,
    required this.numPlayers,
    required this.gameType,
  })  : createdAt = Timestamp.now(),
        players = null,
        messages = null,
        gameStarted = false,
        gameDataID = null;

  GameState({
    required this.id,
    required this.name,
    required this.numPlayers,
    required this.gameType,
    required this.createdAt,
    required this.players,
    required this.messages,
    required this.gameStarted,
    required this.gameDataID,
  });

  // factory GameState.fromFirestore(
  //   DocumentSnapshot<Map<String, dynamic>> snapshot,
  //   SnapshotOptions? options,
  // ) {
  //   final data = snapshot.data();
  //   return GameState(
  //     id: data?['id'],
  //     name: data?['name'],
  //     numPlayers: data?['numPlayers'],
  //     gameType: data?['gameType'],
  //     createdAt: data?['createdAt'],
  //     players:
  //         data?['players'] is Iterable ? List.from(data?['players']) : null,
  //     messages:
  //         data?['messages'] is Iterable ? List.from(data?['messages']) : null,
  //     gameStarted: data?['gameStarted'],
  //     gameDataID: data?['gameDataID'],
  //   );
  // }

  // Map<String, dynamic> toFirestore() {
  //   return {
  //     if (name != null) "name": name,
  //     if (numPlayers != null) "numPlayers": numPlayers,
  //     if (gameType != null) "gameType": gameType,
  //     if (createdAt != null) "createdAt": createdAt,
  //     if (players != null) "players": players,
  //     if (messages != null) "messages": messages,
  //     if (gameStarted != null) "gameStarted": gameStarted,
  //     if (gameDataID != null) "gameDataID": gameDataID,
  //   };
  // }

  Future<void> addRemote() async {
    await FirebaseFirestore.instance.collection('game_state').add({
      'name': name,
      'numPlayers': numPlayers,
      'gameType': gameType,
      'createdAt': Timestamp.now(),
      'players': players,
      'messages': messages,
      'gameStarted': gameStarted,
      'gameDataID': gameDataID,
    }).then((value) => id = value.id);
  }

  Future<void> setRemote() async {
    await FirebaseFirestore.instance.collection('game_state').doc(id).set({
      'name': name,
      'numPlayers': numPlayers,
      'gameType': gameType,
      'createdAt': createdAt,
      'players': players,
      'messages': messages,
      'gameStarted': gameStarted,
      'gameDataID': gameDataID,
    });
  }

  Future<GameState> getRemote(id) async {
    final ref = FirebaseFirestore.instance.collection('game_state').doc(id);
    //.withConverter(
    //  fromFirestore: GameState.fromFirestore,
    //  toFirestore: (GameState GameState, _) => GameState.toFirestore(),
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
    gameStarted = data['gameStarted'];
    gameDataID = data['gameDataID'];

    return this;
  }
}
