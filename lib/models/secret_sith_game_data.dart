import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pluto_games/models/secret_sith_player_data.dart';

class SecretSithGameData {
  String id = "";
  String gameID;
  int numPlayers = 0;
  Timestamp? createdAt;
  List<SecretSithPlayerData> sithPlayers = [];

  SecretSithGameData() : gameID = "-1";

  SecretSithGameData.newGame({
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
      SecretSithPlayerData newPlayer =
          SecretSithPlayerData(id: player['id'], name: player['name']);
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

  // SecretSithGameData.fromJson(Map<String, dynamic> json)
  //     : name = json['name'] as String,
  //       email = json['email'] as String;

  // Map<String, dynamic> toJson() => {
  //       'id': id,
  //       'numPlayers': numPlayers,
  //       'sithPlayers': sithPlayers,
  //     };

  Future<void> addRemote() async {
    await FirebaseFirestore.instance.collection('secret_sith_game_data').add({
      'gameID': gameID,
      'numPlayers': numPlayers,
      'createdAt': Timestamp.now(),
      'sithPlayers': sithPlayers.map((e) => e.toJson()).toList(),
    }).then((value) => id = value.id);
  }
}
