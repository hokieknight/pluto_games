import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_games/models/sith_game_data.dart';

class SithGameDataNotifier extends StateNotifier<SithGameData> {
  SithGameDataNotifier()
      : super(
          SithGameData(),
        );

  void setSithGameData(SithGameData gameData) {
    state = gameData;
  }
}

final sithGameDataProvider =
    StateNotifierProvider<SithGameDataNotifier, SithGameData>((ref) {
  return SithGameDataNotifier();
});
