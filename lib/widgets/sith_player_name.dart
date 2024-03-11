import 'package:flutter/material.dart';
import 'package:pluto_games/models/sith_player_data.dart';

class SithPlayerName extends StatelessWidget {
  final SithPlayerData player;
  //final bool selectable;
  final void Function(BuildContext, SithPlayerData)? nominatePC;
  const SithPlayerName(this.player, this.nominatePC, {super.key});

  void onTap(BuildContext context) {
    if (nominatePC == null) return;
    nominatePC!(context, player);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(4),
      width: 100,
      //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              onTap(context);
            },
            child: CircleAvatar(
              backgroundImage: null,
              backgroundColor: theme.colorScheme.primary.withAlpha(180),
              radius: 24,
              child: Text(player.name),
            ),
          ),
          //Text(player.name),
          if (player.isViceChair) const Text('Vice'),
          if (player.isViceChair) const Text('Chair'),
          if (player.isPrevViceChair) const Text('Previous'),
          if (player.isPrevViceChair) const Text('Vice'),
          if (player.isPrevViceChair) const Text('Chair'),
          if (player.isPrimeChancellor) const Text('Prime'),
          if (player.isPrimeChancellor) const Text('Chancellor'),
          if (player.isPrevPrimeChancellor) const Text('Previous'),
          if (player.isPrevPrimeChancellor) const Text('Prime'),
          if (player.isPrevPrimeChancellor) const Text('Chancellor'),
        ],
      ),
    );
  }
}
