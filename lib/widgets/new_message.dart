import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_games/models/gameroom.dart';
import 'package:pluto_games/models/gameuser.dart';
import 'package:pluto_games/providers/game_room_provider.dart';
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
  late GameRoom _gameRoom;
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

    //final user = FirebaseAuth.instance.currentUser!;
    //final userData = await FirebaseFirestore.instance
    //    .collection('game_users')
    //    .doc(user.uid)
    //    .get();

    //FirebaseFirestore.instance.collection('game_chat').add({
    //  'text': enteredMessage,
    //  'createdAt': Timestamp.now(),
    //  'userId': user.uid,
    //  'nickname': userData.data()!['nickname'],
    //  'userImage': userData.data()!['image_url'],
    //});

    _gameRoom.messages.add(
      {
        'text': enteredMessage,
        'createdAt': Timestamp.now(),
        'userId': _gameUser.uid,
        'nickname': _gameUser.nickname,
        'userImage': _gameUser.imageUrl,
      },
    );
    await _gameRoom.setRemote();
    ref.read(gameRoomProvider.notifier).setGameRoom(_gameRoom);
  }

  @override
  Widget build(BuildContext context) {
    _gameRoom = ref.watch(gameRoomProvider);
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
