import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GameUser {
  String uid;
  String email;
  String name;
  String imageUrl;

  GameUser({
    required this.uid,
    required this.email,
    this.name = '',
    this.imageUrl = '',
  });

  static Future<GameUser> getRemote(User user) async {
    final ref = await FirebaseFirestore.instance
        .collection('game_users')
        .doc(user.uid)
        .get();

    if (ref.data() != null) {
      final data = ref.data()!;
      return GameUser.fromJson(user.uid, data);
    } else {
      return GameUser(uid: user.uid, email: user.email!);
    }
  }

  Future<void> saveRemote() async {
    await FirebaseFirestore.instance.collection('game_users').doc(uid).set({
      'email': email,
      'name': name,
      'imageUrl': imageUrl,
    });
  }

  GameUser.fromJson(String id, Map<String, dynamic> json)
      : uid = id,
        email = json['email'] as String,
        name = json['name'] as String,
        imageUrl = json['imageUrl'] as String;

  Map<String, dynamic> toJson() => {
        'id': uid,
        'email': email,
        'name': name,
        'imageUrl': imageUrl,
      };
}
