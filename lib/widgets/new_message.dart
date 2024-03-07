import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_games/models/game_state.dart';
import 'package:pluto_games/models/game_user.dart';
import 'package:pluto_games/providers/game_state_provider.dart';
import 'package:pluto_games/providers/game_user_provider.dart';

class NewMessage extends ConsumerStatefulWidget {
  const NewMessage({super.key});

  @override
  ConsumerState<NewMessage> createState() {
    return _NewMessageState();
  }
}

class _NewMessageState extends ConsumerState<NewMessage> {
  final _messageController = TextEditingController();
  late GameState _gameState;
  late GameUser _gameUser;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;
    //_gameRoom = ref.watch(gameRoomProvider);

    if (enteredMessage.trim().isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus();
    _messageController.clear();

    await _gameState.getRemote(_gameState.id);
    _gameState.messages ??= [];
    _gameState.messages!.add(
      {
        'text': enteredMessage,
        'createdAt': Timestamp.now(),
        'userId': _gameUser.uid,
        'nickname': _gameUser.nickname,
        'userImage': _gameUser.imageUrl,
      },
    );
    await _gameState.setRemote();
    ref.read(gameStateProvider.notifier).setGameState(_gameState);
  }

  @override
  Widget build(BuildContext context) {
    _gameState = ref.watch(gameStateProvider);
    _gameUser = ref.watch(gameUserProvider);

    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(labelText: 'Send a message...'),
            ),
          ),
          IconButton(
            color: Theme.of(context).colorScheme.primary,
            icon: const Icon(
              Icons.send,
            ),
            onPressed: _submitMessage,
          ),
        ],
      ),
    );
  }
}
