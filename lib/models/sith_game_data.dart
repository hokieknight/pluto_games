import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pluto_games/models/sith_player_data.dart';

class SithGameData {
  String id = "";
  String gameID = "";
  int numPlayers = 0;
  Timestamp createdAt = Timestamp.now();
  List<SithPlayerData> sithPlayers = [];

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

  SithGameData.fromJson(String newid, Map<String, dynamic> json)
      : id = newid,
        gameID = json['gameID'] as String,
        numPlayers = json['numPlayers'] as int,
        createdAt = json['createdAt'] as Timestamp,
        sithPlayers = List<SithPlayerData>.from(
            json['sithPlayers'].map((model) => SithPlayerData.fromJson(model)));

  Map<String, dynamic> toJson() => {
        'id': id,
        'gameID': gameID,
        'numPlayers': numPlayers,
        'createdAt': createdAt,
        'sithPlayers': sithPlayers.map((e) => e.toJson()),
      };

  Future<void> addRemote() async {
    await FirebaseFirestore.instance.collection('sith_game_data').add({
      'gameID': gameID,
      'numPlayers': numPlayers,
      'createdAt': Timestamp.now(),
      'sithPlayers': sithPlayers.map((e) => e.toJson()).toList(),
    }).then((value) => id = value.id);
  }
}