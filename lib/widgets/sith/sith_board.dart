import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_games/controllers/sith_game_controller.dart';
import 'package:pluto_games/models/game_state.dart';
import 'package:pluto_games/models/sith_game_data.dart';
import 'package:pluto_games/models/snapshot_handler.dart';
import 'package:pluto_games/providers/game_state_provider.dart';
import 'package:pluto_games/providers/sith_game_data_provider.dart';
import 'package:pluto_games/widgets/sith/sith_players.dart';
import 'package:pluto_games/widgets/sith/sith_vote.dart';

class SithBoard extends ConsumerStatefulWidget {
  const SithBoard({super.key});

  @override
  ConsumerState<SithBoard> createState() => _SithBoardState();
}

class _SithBoardState extends ConsumerState<SithBoard> {
  late GameState gameState;
  late SithGameData sithGameData;

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
          Widget? widget = handleSnapshot(snapshot, "Sith Game");
          if (widget != null) return widget;

          Map<String, dynamic>? data = snapshot.data!.data();
          sithGameData = SithGameData.fromJson(gameState.gameDataID, data!);

          return Column(
            children: [
              if (sithGameData.electionResult == "Pass")
                const Text("Vote Pass"),
              if (sithGameData.electionResult == "Fail")
                const Text("Vote Fail"),
              Text(SithGameController.getGamePhaseTitle(sithGameData)),
              if (SithGameController.isVotePhase(sithGameData))
                const SithVote(),
              Container(
                margin: const EdgeInsets.all(2),
                //padding: const EdgeInsets.all(2),
                height:
                    SithGameController.isVotePhase(sithGameData) ? 280 : 360,
                //decoration:
                //    BoxDecoration(border: Border.all(color: Colors.red)),
                child: const SithPlayers(),
              ),
            ],
          );
        });
  }
}
