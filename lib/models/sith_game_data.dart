import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pluto_games/models/sith_player_data.dart';

class SithGameData {
  String id = "";
  String gameID = "";
  int numPlayers = 0;
  Timestamp createdAt = Timestamp.now();
  List<SithPlayerData> sithPlayers = [];
  int turn = 1;
  String phase = "pick-chancellor";
  String electionResult = "";

  SithGameData();

  SithGameData.newGame({
    required this.gameID,
    required gamePlayers,
  }) {
    numPlayers = gamePlayers!.length;
    int numSeps = 2;
    if (numPlayers > 6) {
      numSeps++;
    }
    if (numPlayers > 8) {
      numSeps++;
    }

    List<String> temp = [];
    for (var player in gamePlayers!) {
      temp.add(player['id']);
    }
    temp.shuffle();

    for (var player in gamePlayers!) {
      SithPlayerData newPlayer =
          SithPlayerData(id: player['id'], name: player['name']);
      int index = temp.indexOf(newPlayer.id);
      if (index == 0) {
        newPlayer.role = "role-sep1-palp";
        newPlayer.membership = "membership-sep";
      } else if (index < numSeps) {
        newPlayer.role = "role-sep${index + 1}";
        newPlayer.membership = "membership-sep";
      } else {
        newPlayer.role = "role-loy${index - numSeps + 1}";
        newPlayer.membership = "membership-loy";
      }

      sithPlayers.add(newPlayer);
    }
    sithPlayers[Random().nextInt(sithPlayers.length)].isViceChair = true;
  }

  bool isSelectPC(String uid) {
    if (phase != "pick-chancellor") return false;
    int index = sithPlayers.indexWhere((element) => element.id == uid);
    if (index < 0) return false;
    return sithPlayers[index].isViceChair;
  }

  SithPlayerData? getPlayerByID(String uid) {
    int index = sithPlayers.indexWhere((element) => element.id == uid);
    if (index < 0) return null;
    return sithPlayers[index];
  }

  SithPlayerData? getPrimeChancellor() {
    int index =
        sithPlayers.indexWhere((element) => element.isPrimeChancellor == true);
    if (index < 0) return null;
    return sithPlayers[index];
  }

  String getGamePhaseTitle() {
    if (phase == "pick-chancellor") {
      return "Vice Chair Nominate Prime Chancellor";
    }
    if (phase == "vote-chancellor") {
      SithPlayerData? pcPlayer = getPrimeChancellor();
      if (null != pcPlayer) {
        return "Vote for ${pcPlayer.name} as Prime Chancellor";
      }
      return "No Prime Chancellor to Vote For";
    }
    if (phase == "select-policy1") return "Vice Chair Select Policies";

    return "";
  }

  bool isVotePhase() {
    return phase == "vote-chancellor";
  }

  void castVote(String uid, String vote) {
    int yesCount = 0;
    int noCount = 0;
    int indexVC = 0;
    int indexPC = 0;
    for (int index = 0; index < sithPlayers.length; index++) {
      var player = sithPlayers[index];
      if (player.id == uid) player.vote = vote;
      if (player.vote == "Yes") yesCount++;
      if (player.vote == "No") noCount++;
      if (player.isViceChair) indexVC = index;
      if (player.isPrimeChancellor) indexPC = index;
    }

    // voting is done
    if ((yesCount + noCount) == sithPlayers.length) {
      if (yesCount > noCount) {
        phase = "select-policy1";
        electionResult = "Pass";
      } else {
        phase = "pick-chancellor";
        sithPlayers[indexVC].isViceChair = false;
        sithPlayers[indexPC].isPrimeChancellor = false;
        indexVC = (indexVC + 1) % sithPlayers.length;
        sithPlayers[indexVC].isViceChair = true;
        electionResult = "Fail";
      }
    }
  }

  void nextPhase() {
    if (phase == "pick-chancellor") phase = "vote-chancellor";
  }

  SithGameData.fromJson(String newid, Map<String, dynamic> json)
      : id = newid,
        gameID = json['gameID'] as String,
        numPlayers = json['numPlayers'] as int,
        createdAt = json['createdAt'] as Timestamp,
        sithPlayers = List<SithPlayerData>.from(
            json['sithPlayers'].map((model) => SithPlayerData.fromJson(model))),
        turn = json['turn'] as int,
        phase = json['phase'] as String,
        electionResult = json['electionResult'] as String;

  Map<String, dynamic> toJson() => {
        'id': id,
        'gameID': gameID,
        'numPlayers': numPlayers,
        'createdAt': createdAt,
        'sithPlayers': sithPlayers.map((e) => e.toJson()),
        'turn': turn,
        'phase': phase,
        'electionResult': electionResult,
      };

  Future<void> addRemote() async {
    await FirebaseFirestore.instance.collection('sith_game_data').add({
      'gameID': gameID,
      'numPlayers': numPlayers,
      'createdAt': Timestamp.now(),
      'sithPlayers': sithPlayers.map((e) => e.toJson()).toList(),
      'turn': turn,
      'phase': phase,
      'electionResult': electionResult,
    }).then((value) => id = value.id);
  }

  static Future<SithGameData> getRemote(id) async {
    final ref = await FirebaseFirestore.instance
        .collection('sith_game_data')
        .doc(id)
        .get();

    if (ref.data() != null) {
      final data = ref.data()!;
      return SithGameData.fromJson(id, data);
    } else {
      return SithGameData();
    }
  }

  Future<void> setRemote() async {
    await FirebaseFirestore.instance.collection('sith_game_data').doc(id).set({
      'gameID': gameID,
      'numPlayers': numPlayers,
      'createdAt': Timestamp.now(),
      'sithPlayers': sithPlayers.map((e) => e.toJson()).toList(),
      'turn': turn,
      'phase': phase,
      'electionResult': electionResult,
    });
  }
}
