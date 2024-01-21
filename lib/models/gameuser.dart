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
}
