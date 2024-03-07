import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_games/models/game_state.dart';
import 'package:pluto_games/providers/game_state_provider.dart';
import 'package:pluto_games/widgets/chat_messages.dart';
import 'package:pluto_games/widgets/game_room.dart';
import 'package:pluto_games/widgets/new_message.dart';

class LobbyScreen extends ConsumerStatefulWidget {
  const LobbyScreen({super.key});

  @override
  ConsumerState<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends ConsumerState<LobbyScreen> {
  late GameState _gameState;

  @override
  Widget build(BuildContext context) {
    _gameState = ref.watch(gameStateProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Pluto Games - Room - ${_gameState.name}'),
      ),
      body: const Column(
        children: [
          Expanded(
            child: GameRoomWidget(),
          ),
          Expanded(
            child: ChatMessages(),
          ),
          NewMessage(),
        ],
      ),
    );
  }
}
