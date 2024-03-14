import 'package:flutter/material.dart';
import 'package:pluto_games/models/sith_player_data.dart';

class SithPlayerName extends StatelessWidget {
  final SithPlayerData player;
  final bool isMe;
  final void Function(BuildContext, SithPlayerData)? nominatePC;
  //final bool selectable;

  const SithPlayerName(this.player, this.isMe, this.nominatePC, {super.key});

  void onTap(BuildContext context) {
    if (nominatePC == null) return;
    nominatePC!(context, player);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double textScale = 0.75;

    return Container(
      //margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(2),
      width: 60,
      //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              onTap(context);
            },
            child: CircleAvatar(
              backgroundColor: isMe
                  ? theme.colorScheme.primary.withAlpha(180)
                  : theme.colorScheme.primaryContainer,
              radius: 24,
              child: CircleAvatar(
                backgroundImage: null,
                //backgroundColor: theme.colorScheme.primary.withAlpha(180),
                radius: 20,
                child:
                    Text(player.name, textScaler: TextScaler.linear(textScale)),
              ),
            ),
          ),
          //Text(player.name),
          if (player.isViceChair)
            Text(
              'Vice',
              textScaler: TextScaler.linear(textScale),
            ),
          if (player.isViceChair)
            Text(
              'Chair',
              textScaler: TextScaler.linear(textScale),
            ),
          if (player.isPrevViceChair)
            Text(
              'Previous',
              textScaler: TextScaler.linear(textScale),
            ),
          if (player.isPrevViceChair)
            Text(
              'Vice',
              textScaler: TextScaler.linear(textScale),
            ),
          if (player.isPrevViceChair)
            Text(
              'Chair',
              textScaler: TextScaler.linear(textScale),
            ),
          if (player.isPrimeChancellor)
            Text(
              'Prime',
              textScaler: TextScaler.linear(textScale),
            ),
          if (player.isPrimeChancellor)
            Text(
              'Chancellor',
              textScaler: TextScaler.linear(textScale),
            ),
          if (player.isPrevPrimeChancellor)
            Text(
              'Previous',
              textScaler: TextScaler.linear(textScale),
            ),
          if (player.isPrevPrimeChancellor)
            Text(
              'Prime',
              textScaler: TextScaler.linear(textScale),
            ),
          if (player.isPrevPrimeChancellor)
            Text(
              'Chancellor',
              textScaler: TextScaler.linear(textScale),
            ),
        ],
      ),
    );
  }
}
