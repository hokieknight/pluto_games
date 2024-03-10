import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_games/models/game_user.dart';
import 'package:pluto_games/models/sith_game_data.dart';
import 'package:pluto_games/models/sith_player_data.dart';
import 'package:pluto_games/providers/game_user_provider.dart';
import 'package:pluto_games/providers/sith_game_data_provider.dart';

class SithVote extends ConsumerStatefulWidget {
  const SithVote({super.key});

  @override
  ConsumerState<SithVote> createState() => _SithVoteState();
}

class _SithVoteState extends ConsumerState<SithVote> {
  late GameUser gameUser;
  late SithGameData sithGameData;

  void castVote(String vote) {
    SithPlayerData? playerPC = sithGameData.getPrimeChancellor();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Vote for Prime Chancellor'),
        content: Text('Confirm vote of $vote for ${playerPC!.name}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              sithGameData.castVote(gameUser.uid, vote);
              ref
                  .read(sithGameDataProvider.notifier)
                  .setSithGameData(sithGameData);
              sithGameData.setRemote();
              setState(() {});
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  void retractVote() {
    sithGameData.castVote(gameUser.uid, "");
    ref.read(sithGameDataProvider.notifier).setSithGameData(sithGameData);
    sithGameData.setRemote();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    gameUser = ref.watch(gameUserProvider);
    sithGameData = ref.watch(sithGameDataProvider);
    SithPlayerData? thisPlayer = sithGameData.getPlayerByID(gameUser.uid);
    if (thisPlayer!.vote.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: retractVote,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
          child: const Text('Retract Vote'),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: InkWell(
            onTap: () {
              castVote("Yes");
            },
            child: Image.asset(
                "images/SecretSith_v1.0/Cards/confidence-yes.jpg",
                width: 120),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: InkWell(
            onTap: () {
              castVote("No");
            },
            child: Image.asset("images/SecretSith_v1.0/Cards/confidence-no.jpg",
                width: 120),
          ),
        ),
      ],
    );
  }
}
