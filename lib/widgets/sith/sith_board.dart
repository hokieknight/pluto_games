import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_games/controllers/sith_game_controller.dart';
import 'package:pluto_games/models/game_state.dart';
import 'package:pluto_games/models/sith_game_data.dart';
import 'package:pluto_games/models/sith_player_data.dart';
import 'package:pluto_games/models/snapshot_handler.dart';
import 'package:pluto_games/providers/game_state_provider.dart';
import 'package:pluto_games/providers/sith_game_data_provider.dart';
import 'package:pluto_games/widgets/sith/sith_players.dart';
import 'package:pluto_games/widgets/sith/sith_policy.dart';
import 'package:pluto_games/widgets/sith/sith_vote.dart';

class SithBoard extends ConsumerStatefulWidget {
  const SithBoard({super.key});

  @override
  ConsumerState<SithBoard> createState() => _SithBoardState();
}

class _SithBoardState extends ConsumerState<SithBoard> {
  late GameState gameState;
  late SithGameData sithGameData;

  String getGamePhaseTitle() {
    if (SithGameController.isPickPhase(sithGameData)) {
      return "Vice Chair Nominate Prime Chancellor";
    }
    if (SithGameController.isVotePhase(sithGameData)) {
      SithPlayerData? pcPlayer =
          SithGameController.getPrimeChancellor(sithGameData);
      if (null != pcPlayer) {
        return "Vote for ${pcPlayer.name} as Prime Chancellor";
      }
      return "No Prime Chancellor to Vote For";
    }
    if (SithGameController.isPolicyPhase1(sithGameData)) {
      return "Vice Chair Discard a Policy";
    }
    if (SithGameController.isPolicyPhase2(sithGameData)) {
      return "Prime Chancellor Discard a Policy";
    }
    return "";
  }

  String getGameResult() {
    if (SithGameController.isElectionPass(sithGameData)) return "Vote Pass";
    if (SithGameController.isElectionFail(sithGameData)) return "Vote Fail";
    if (SithGameController.isLoyalistPolicyEnacted(sithGameData)) {
      return "Loyalist Policy Enacted";
    }
    if (SithGameController.isSeparatistPolicyEnacted(sithGameData)) {
      return "Separatist Policy Enacted";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    gameState = ref.watch(gameStateProvider);
    sithGameData = ref.watch(sithGameDataProvider);

    // String sepPlaymat = 'Playmat_Separatist5-6.jpg';
    // if (_sithGameData.sithPlayers.length > 6) {
    //   sepPlaymat = 'Playmat_Separatist7-8.jpg';
    // }
    // if (_sithGameData.sithPlayers.length > 8) {
    //   sepPlaymat = 'Playmat_Separatist9-10.jpg';
    // }

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('sith_game_data')
            .doc(gameState.gameDataID)
            .snapshots(),
        builder: (ctx, snapshot) {
          Widget? errorWidget = handleSnapshot(snapshot, "Sith Game");
          if (errorWidget != null) return errorWidget;

          Map<String, dynamic>? data = snapshot.data!.data();
          sithGameData = SithGameData.fromJson(gameState.gameDataID, data!);

          return Column(
            children: [
              Text(getGameResult()),
              Text(getGamePhaseTitle()),
              if (SithGameController.isVotePhase(sithGameData))
                const SithVote(),
              if (SithGameController.isPolicyPhase(sithGameData))
                const SithPolicy(),
              Container(
                margin: const EdgeInsets.all(2),
                //padding: const EdgeInsets.all(2),
                //height: 280,
                height: SithGameController.isVotePhase(sithGameData) ||
                        SithGameController.isPolicyPhase(sithGameData)
                    ? 280
                    : 360,
                //decoration:
                //    BoxDecoration(border: Border.all(color: Colors.red)),
                child: const SithPlayers(),
              ),
            ],
          );
        });
  }
}
