//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_games/models/game_state.dart';
// import 'package:pluto_games/models/game_user.dart';
import 'package:pluto_games/providers/game_state_provider.dart';
// import 'package:pluto_games/providers/game_user_provider.dart';

class SecretSithBoard extends ConsumerStatefulWidget {
  const SecretSithBoard({super.key});

  @override
  ConsumerState<SecretSithBoard> createState() => _SecretSithBoardState();
}

class _SecretSithBoardState extends ConsumerState<SecretSithBoard> {
  late GameState _gameState;
  //late GameUser _gameUser;

  @override
  Widget build(BuildContext context) {
    _gameState = ref.watch(gameStateProvider);
    //_gameUser = ref.watch(gameUserProvider);
    String sepPlaymat = 'Playmat_Separatist5-6.jpg';
    if (_gameState.players!.length > 6) {
      sepPlaymat = 'Playmat_Separatist7-8.jpg';
    }
    if (_gameState.players!.length > 8) {
      sepPlaymat = 'Playmat_Separatist9-10.jpg';
    }

    return Expanded(
      child: ListView(
        children: [
          SizedBox(
            width: 600,
            height: 200,
            child: Image.asset(
                'images/SecretSith_v1.0/Playmats/Playmat_Loyalist.jpg'),
          ),
          SizedBox(
            width: 600,
            height: 200,
            child: Image.asset('images/SecretSith_v1.0/Playmats/$sepPlaymat'),
          ),
        ],
      ),
    );
  }
}
