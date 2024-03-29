import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_games/models/game_state.dart';
import 'package:pluto_games/models/game_user.dart';
import 'package:pluto_games/providers/game_state_provider.dart';
import 'package:pluto_games/providers/game_user_provider.dart';
import 'package:pluto_games/widgets/message_bubble.dart';

class ChatMessages extends ConsumerStatefulWidget {
  const ChatMessages({super.key});

  @override
  ConsumerState<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends ConsumerState<ChatMessages> {
  late GameState _gameState;
  late GameUser _gameUser;

  @override
  Widget build(BuildContext context) {
    //final authenticatedUser = FirebaseAuth.instance.currentUser!;
    _gameState = ref.watch(gameStateProvider);
    _gameUser = ref.watch(gameUserProvider);

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('game_state')
          .doc(_gameState.id)
          .snapshots(),
      builder: (ctx, gameStateSnapshot) {
        if (gameStateSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!gameStateSnapshot.hasData) {
          return const Center(
            child: Text('No messages found.'),
          );
        }

        if (gameStateSnapshot.hasError) {
          return const Center(
            child: Text('Something went wrong...'),
          );
        }

        final data = gameStateSnapshot.data!.data() as Map<String, dynamic>;
        var loadedMessages = [];
        if (data['messages'] != null) {
          loadedMessages = data['messages'] as List<dynamic>;
          loadedMessages
              .sort((a, b) => b['createdAt'].compareTo(a['createdAt']));
        }

        return ListView.builder(
          padding: const EdgeInsets.only(
            bottom: 40,
            left: 13,
            right: 13,
          ),
          reverse: true,
          itemCount: loadedMessages.length,
          itemBuilder: (ctx, index) {
            final chatMessage = loadedMessages[index];
            //return Text(chatMessage['text']);
            final nextChatMessage = index + 1 < loadedMessages.length
                ? loadedMessages[index + 1]
                : null;

            final currentMessageUserId = chatMessage['userId'];
            final nextMessageUserId =
                nextChatMessage != null ? nextChatMessage['userId'] : null;
            final nextUserIsSame = nextMessageUserId == currentMessageUserId;

            if (nextUserIsSame) {
              return MessageBubble.next(
                message: chatMessage['text'],
                isMe: _gameUser.uid == currentMessageUserId,
              );
            } else {
              return MessageBubble.first(
                userImage: chatMessage['userImage'],
                username: chatMessage['nickname'],
                message: chatMessage['text'],
                isMe: _gameUser.uid == currentMessageUserId,
              );
            }
          },
        );
      },
    );
  }
}
