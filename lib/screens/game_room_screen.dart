import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_games/models/game_state.dart';
import 'package:pluto_games/providers/game_state_provider.dart';
import 'package:pluto_games/widgets/chat_messages.dart';
import 'package:pluto_games/widgets/game_room.dart';
import 'package:pluto_games/widgets/new_message.dart';

class GameRoomScreen extends ConsumerStatefulWidget {
  const GameRoomScreen({super.key});

  @override
  ConsumerState<GameRoomScreen> createState() => _GameRoomScreenState();
}

class _GameRoomScreenState extends ConsumerState<GameRoomScreen> {
  late GameState _gameState;

  @override
  Widget build(BuildContext context) {
    _gameState = ref.watch(gameStateProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Pluto Games - ${_gameState.gameType}'),
        leading: Image.asset('images/my-pluto-2.png'),
      ),
      body: Column(
        children: [
          const Expanded(
            flex: 4,
            child: GameRoomWidget(),
          ),
          if (!_gameState.gameStarted)
            const Expanded(
              child: ChatMessages(),
            ),
          if (!_gameState.gameStarted) const NewMessage(),
        ],
      ),
    );
  }
}
