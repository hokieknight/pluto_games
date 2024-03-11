import 'dart:math';

import 'package:pluto_games/models/sith_game_data.dart';
import 'package:pluto_games/models/sith_player_data.dart';

class SithGameController {
  SithGameController();

  static SithGameData newGame(String gameID, List<dynamic> gamePlayers) {
    SithGameData game = SithGameData();
    game.gameID = gameID;

    game.numPlayers = gamePlayers.length;
    int numSeps = 2;
    if (game.numPlayers > 6) {
      numSeps++;
    }
    if (game.numPlayers > 8) {
      numSeps++;
    }

    List<String> temp = [];
    for (var player in gamePlayers) {
      temp.add(player['id']);
    }
    temp.shuffle();

    for (var player in gamePlayers) {
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

      game.sithPlayers.add(newPlayer);
    }
    game.sithPlayers[Random().nextInt(game.sithPlayers.length)].isViceChair =
        true;

    return game;
  }

  static bool isSelectPC(SithGameData game, String uid) {
    if (game.phase != "pick-chancellor") return false;
    int index = game.sithPlayers.indexWhere((element) => element.id == uid);
    if (index < 0) return false;
    return game.sithPlayers[index].isViceChair;
  }

  static SithPlayerData? getPlayerByID(SithGameData game, String uid) {
    int index = game.sithPlayers.indexWhere((element) => element.id == uid);
    if (index < 0) return null;
    return game.sithPlayers[index];
  }

  static SithPlayerData? getPrimeChancellor(SithGameData game) {
    int index = game.sithPlayers
        .indexWhere((element) => element.isPrimeChancellor == true);
    if (index < 0) return null;
    return game.sithPlayers[index];
  }

  static String getGamePhaseTitle(SithGameData game) {
    if (game.phase == "pick-chancellor") {
      return "Vice Chair Nominate Prime Chancellor";
    }
    if (game.phase == "vote-chancellor") {
      SithPlayerData? pcPlayer = getPrimeChancellor(game);
      if (null != pcPlayer) {
        return "Vote for ${pcPlayer.name} as Prime Chancellor";
      }
      return "No Prime Chancellor to Vote For";
    }
    if (game.phase == "select-policy1") return "Vice Chair Select Policies";

    return "";
  }

  static bool isVotePhase(SithGameData game) {
    return game.phase == "vote-chancellor";
  }

  static void castVote(SithGameData game, String uid, String vote) {
    int yesCount = 0;
    int noCount = 0;
    int indexVC = 0;
    int indexPC = 0;
    for (int index = 0; index < game.sithPlayers.length; index++) {
      var player = game.sithPlayers[index];
      if (player.id == uid) player.vote = vote;
      if (player.vote == "Yes") yesCount++;
      if (player.vote == "No") noCount++;
      if (player.isViceChair) indexVC = index;
      if (player.isPrimeChancellor) indexPC = index;
    }

    // voting is done
    if ((yesCount + noCount) == game.sithPlayers.length) {
      if (yesCount > noCount) {
        game.phase = "select-policy1";
        game.electionResult = "Pass";
      } else {
        game.phase = "pick-chancellor";
        game.sithPlayers[indexVC].isViceChair = false;
        game.sithPlayers[indexPC].isPrimeChancellor = false;
        indexVC = (indexVC + 1) % game.sithPlayers.length;
        game.sithPlayers[indexVC].isViceChair = true;
        game.electionResult = "Fail";
      }
    }
  }

  static void nextPhase(SithGameData game) {
    if (game.phase == "pick-chancellor") game.phase = "vote-chancellor";
  }

  static void nominatePrimeChancellor(
      SithGameData game, SithPlayerData player) {
    for (var player in game.sithPlayers) {
      player.isPrimeChancellor = false;
      player.vote = "";
    }

    int index =
        game.sithPlayers.indexWhere((element) => element.id == player.id);
    if (index < 0) return;
    game.sithPlayers[index].isPrimeChancellor = true;
    nextPhase(game);
  }
}
