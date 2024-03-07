import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_games/models/secret_sith_game_data.dart';

class SithGameDataNotifier extends StateNotifier<SecretSithGameData> {
  SithGameDataNotifier()
      : super(
          SecretSithGameData(),
        );

  void setSithGameData(SecretSithGameData gameData) {
    state = gameData;
  }
}

final sithGameDataProvider =
    StateNotifierProvider<SithGameDataNotifier, SecretSithGameData>((ref) {
  return SithGameDataNotifier();
});
