import 'package:flutter/material.dart';
import 'package:pluto_games/models/sith_player_data.dart';

class SithPlayerName extends StatelessWidget {
  final SithPlayerData player;
  const SithPlayerName(this.player, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        CircleAvatar(
          backgroundImage: null,
          backgroundColor: theme.colorScheme.primary.withAlpha(180),
          radius: 23,
          child: Text(player.name),
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
    );
  }
}
