import 'dart:math';

import 'package:pluto_games/models/sith_game_data.dart';
import 'package:pluto_games/models/sith_player_data.dart';

class SithGameController {
  SithGameController();

  static SithGameData newGame(String gameID, List<dynamic> gamePlayers) {
    SithGameData game = SithGameData();
    game.gameID = gameID;
    game = setupPlayers(game, gamePlayers);
    game = setupPolicies(game);
    return game;
  }

  static SithGameData setupPlayers(
      SithGameData game, List<dynamic> gamePlayers) {
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

  static SithGameData setupPolicies(SithGameData game) {
    game.policyDiscard = [];
    game.policyDraw = [
      "loy",
      "loy",
      "loy",
      "loy",
      "loy",
      "loy",
      "sep",
      "sep",
      "sep",
      "sep",
      "sep",
      "sep",
      "sep",
      "sep",
      "sep",
      "sep",
      "sep"
    ];
    game.policyDraw.shuffle();
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
    if (game.phase == "select-policy1") return "Vice Chair Discard a Policy";
    if (game.phase == "select-policy2") {
      return "Prime Chancellor Discard a Policy";
    }

    return "";
  }

  static bool isVotePhase(SithGameData game) {
    return game.phase == "vote-chancellor";
  }

  static bool isPolicyPhase(SithGameData game) {
    return game.phase == "select-policy1" || game.phase == "select-policy2";
  }

  static bool isPolicyPhase1(SithGameData game) {
    return game.phase == "select-policy1";
  }

  static bool isPolicyPhase2(SithGameData game) {
    return game.phase == "select-policy2";
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
      game.policyResult = "";
      if (yesCount > noCount) {
        game.electionResult = "Pass";
      } else {
        game.sithPlayers[indexVC].isViceChair = false;
        game.sithPlayers[indexPC].isPrimeChancellor = false;
        indexVC = (indexVC + 1) % game.sithPlayers.length;
        game.sithPlayers[indexVC].isViceChair = true;
        game.electionResult = "Fail";
      }
    }
    nextPhase(game);
  }

  static void nominatePrimeChancellor(
    SithGameData game,
    SithPlayerData player,
  ) {
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

  static void discardPolicy(
    SithGameData game,
    int index,
  ) {
    String policy = game.policyHand.removeAt(index);
    game.policyDiscard.add(policy);
    if (game.policyHand.length == 1) {
      String playPolicy = game.policyHand.removeAt(0);
      if (playPolicy == "loy") {
        game.policiesEnactedLoy++;
        game.policyResult = "Loyalist";
      } else {
        game.policiesEnactedSep++;
        game.policyResult = "Separatist";
      }
    }
    nextPhase(game);
  }

  static void drawPolicies(SithGameData game) {
    if (game.policyDraw.length < 3) {
      for (String policy in game.policyDiscard) {
        game.policyDraw.add(policy);
      }
      game.policyDraw.shuffle();
      game.policyDiscard.clear();
    }

    String policy1 = game.policyDraw.removeAt(0);
    game.policyHand.add(policy1);
    String policy2 = game.policyDraw.removeAt(0);
    game.policyHand.add(policy2);
    String policy3 = game.policyDraw.removeAt(0);
    game.policyHand.add(policy3);
  }

  static void nextPhase(SithGameData game) {
    if (game.phase == "pick-chancellor") {
      game.phase = "vote-chancellor";
      return;
    }
    if (game.phase == "vote-chancellor") {
      if (game.electionResult == "Pass") {
        game.phase = "select-policy1";
        drawPolicies(game);
      } else {
        game.phase = "pick-chancellor";
      }
      return;
    }
    if (game.phase == "select-policy1") {
      game.phase = "select-policy2";
      return;
    }
    if (game.phase == "select-policy2") {
      game.phase = "pick-chancellor";
      game.turn++;
      game.electionResult = "";
      //set new VC, prev VC, prev PC
      //clear PC
      //clear votes

      int indexVC = 0;
      int indexPC = 0;
      for (int index = 0; index < game.sithPlayers.length; index++) {
        var player = game.sithPlayers[index];
        player.vote = "";
        player.isPrevPrimeChancellor = false;
        player.isPrevViceChair = false;
        if (player.isViceChair) indexVC = index;
        if (player.isPrimeChancellor) indexPC = index;
      }

      game.sithPlayers[indexVC].isPrevViceChair = true;
      game.sithPlayers[indexVC].isViceChair = false;
      indexVC = (indexVC + 1) % game.sithPlayers.length;
      game.sithPlayers[indexVC].isViceChair = true;
      game.sithPlayers[indexPC].isPrevPrimeChancellor = true;
      game.sithPlayers[indexPC].isPrimeChancellor = false;

      return;
    }
  }
}
