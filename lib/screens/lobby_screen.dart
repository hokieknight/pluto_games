import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_games/models/gameroom.dart';
import 'package:pluto_games/providers/game_room_provider.dart';
import 'package:pluto_games/widgets/chat_messages.dart';
import 'package:pluto_games/widgets/game_room.dart';
import 'package:pluto_games/widgets/new_message.dart';

class LobbyScreen extends ConsumerStatefulWidget {
  const LobbyScreen({super.key});

  @override
  ConsumerState<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends ConsumerState<LobbyScreen> {
  late GameRoom _gameRoom;

  @override
  Widget build(BuildContext context) {
    _gameRoom = ref.watch(gameRoomProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Pluto Games - Game Lobby - ${_gameRoom.name}'),
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
