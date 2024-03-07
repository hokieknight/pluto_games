//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pluto_games/models/game_state.dart';
// import 'package:pluto_games/models/game_user.dart';
// import 'package:pluto_games/providers/game_state_provider.dart';
// import 'package:pluto_games/providers/game_user_provider.dart';

class SecretSithBoard extends ConsumerStatefulWidget {
  const SecretSithBoard({super.key});

  @override
  ConsumerState<SecretSithBoard> createState() => _SecretSithBoardState();
}

class _SecretSithBoardState extends ConsumerState<SecretSithBoard> {
  //late GameState _gameState;
  //late GameUser _gameUser;

  @override
  Widget build(BuildContext context) {
    //final authenticatedUser = FirebaseAuth.instance.currentUser!;
    //_gameState = ref.watch(gameStateProvider);
    //_gameUser = ref.watch(gameUserProvider);

    return const Center(child: Text('Secret Sith Game'));
  }
}
