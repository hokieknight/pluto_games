import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_games/models/game_state.dart';
import 'package:pluto_games/models/sith_game_data.dart';
import 'package:pluto_games/providers/game_state_provider.dart';
import 'package:pluto_games/providers/sith_game_data_provider.dart';
import 'package:pluto_games/widgets/sith_players.dart';

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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('Game not found.'),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong...'),
            );
          }

          Map<String, dynamic>? data = snapshot.data!.data();
          sithGameData = SithGameData.fromJson(gameState.gameDataID, data!);
          //ref.read(sithGameDataProvider.notifier).setSithGameData(sithGameData);
          //setState(() {});

          return Column(
            children: [
              const Text('Vice Chair Nominate Prime Chancellor'),
              Container(
                margin: const EdgeInsets.all(2),
                padding: const EdgeInsets.all(2),
                height: 360,
                //decoration:
                //    BoxDecoration(border: Border.all(color: Colors.red)),
                child: const SithPlayers(),
              ),
            ],
          );
        });

    // return Expanded(
    //   child: ListView(
    //     children: [
    //       const SecretSithPlayers(),
    //       SizedBox(
    //         width: 600,
    //         height: 200,
    //         child: Image.asset(
    //             'images/SecretSith_v1.0/Playmats/Playmat_Loyalist.jpg'),
    //       ),
    //       SizedBox(
    //         width: 600,
    //         height: 200,
    //         child: Image.asset('images/SecretSith_v1.0/Playmats/$sepPlaymat'),
    //       ),
    //     ],
    //   ),
    // );
  }
}
