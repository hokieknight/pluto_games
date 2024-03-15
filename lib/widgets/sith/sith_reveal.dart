import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_games/controllers/sith_game_controller.dart';
import 'package:pluto_games/models/game_user.dart';
import 'package:pluto_games/models/sith_game_data.dart';
import 'package:pluto_games/models/sith_player_data.dart';
import 'package:pluto_games/providers/game_user_provider.dart';
import 'package:pluto_games/providers/sith_game_data_provider.dart';

class SithReveal extends ConsumerStatefulWidget {
  const SithReveal({super.key});

  @override
  ConsumerState<SithReveal> createState() => _SithRevealState();
}

class _SithRevealState extends ConsumerState<SithReveal> {
  late GameUser gameUser;
  late SithGameData sithGameData;

  void setRevealReady() async {
    sithGameData = await SithGameData.getRemote(sithGameData.id);
    SithGameController.setRevealReady(sithGameData, gameUser.uid);
    ref.read(sithGameDataProvider.notifier).setSithGameData(sithGameData);
    sithGameData.setRemote();
    setState(() {});
  }

  void setReady() {
    setRevealReady();
  }

  @override
  Widget build(BuildContext context) {
    gameUser = ref.watch(gameUserProvider);
    sithGameData = ref.watch(sithGameDataProvider);

    SithPlayerData thisPlayer =
        SithGameController.getPlayerByID(sithGameData, gameUser.uid)!;
    if (thisPlayer.revealReady) return const SizedBox();
    if (!SithGameController.isSeparatistReveal(sithGameData, thisPlayer.role)) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: setReady,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: const Text('Ready'),
      ),
    );
  }
}
