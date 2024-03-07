//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:pluto_games/models/secret_sith_game_data.dart';
//import 'package:pluto_games/providers/sith_game_data_provider.dart';
import 'package:pluto_games/widgets/secret_sith_players.dart';

class SecretSithBoard extends ConsumerStatefulWidget {
  const SecretSithBoard({super.key});

  @override
  ConsumerState<SecretSithBoard> createState() => _SecretSithBoardState();
}

class _SecretSithBoardState extends ConsumerState<SecretSithBoard> {
  //late SecretSithGameData _sithGameData;

  @override
  Widget build(BuildContext context) {
    //_sithGameData = ref.watch(sithGameDataProvider);

    // String sepPlaymat = 'Playmat_Separatist5-6.jpg';
    // if (_sithGameData.sithPlayers.length > 6) {
    //   sepPlaymat = 'Playmat_Separatist7-8.jpg';
    // }
    // if (_sithGameData.sithPlayers.length > 8) {
    //   sepPlaymat = 'Playmat_Separatist9-10.jpg';
    // }

    return const Expanded(
      child: SecretSithPlayers(),
    );

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
