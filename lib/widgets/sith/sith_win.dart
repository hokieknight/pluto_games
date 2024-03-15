import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_games/controllers/sith_game_controller.dart';
import 'package:pluto_games/models/game_user.dart';
import 'package:pluto_games/models/sith_game_data.dart';
import 'package:pluto_games/providers/game_user_provider.dart';
import 'package:pluto_games/providers/sith_game_data_provider.dart';

class SithWin extends ConsumerStatefulWidget {
  const SithWin({super.key});

  @override
  ConsumerState<SithWin> createState() => _SithWinState();
}

class _SithWinState extends ConsumerState<SithWin> {
  late GameUser gameUser;
  late SithGameData sithGameData;

  Widget getWinWidget() {
    if (SithGameController.isLoyWinPhase(sithGameData)) {
      return const Text(
        "Loyalists WIN!",
        style: TextStyle(color: Colors.blue),
        textScaler: TextScaler.linear(2.0),
      );
    }
    if (SithGameController.isSepWinPhase(sithGameData)) {
      return const Text(
        "Separatists WIN!",
        style: TextStyle(color: Colors.red),
        textScaler: TextScaler.linear(2.0),
      );
    }
    return const Text("Game Over");
  }

  @override
  Widget build(BuildContext context) {
    gameUser = ref.watch(gameUserProvider);
    sithGameData = ref.watch(sithGameDataProvider);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: getWinWidget(),
    );
  }
}
