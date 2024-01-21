import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_games/models/gameuser.dart';

class GameUserNotifier extends StateNotifier<GameUser> {
  GameUserNotifier()
      : super(
          GameUser(
            uid: '??',
            email: '??',
            nickname: '??',
            imageUrl: '??',
          ),
        );

  void setUser(GameUser user) {
    state = user;
  }
}

final gameUserProvider =
    StateNotifierProvider<GameUserNotifier, GameUser>((ref) {
  return GameUserNotifier();
});
