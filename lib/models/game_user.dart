import 'package:cloud_firestore/cloud_firestore.dart';

class GameUser {
  final String uid;
  final String email;
  String nickname;
  String imageUrl;

  GameUser({
    required this.uid,
    required this.email,
    this.nickname = '',
    this.imageUrl = '',
  });

  Future<void> saveRemote() async {
    //final gameUser = ref.watch(gameUserProvider);
    await FirebaseFirestore.instance.collection('game_users').doc(uid).set({
      'email': email,
      'nickname': nickname,
      'image_url': imageUrl,
    });
  }
}
