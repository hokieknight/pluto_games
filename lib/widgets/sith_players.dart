import 'package:flutter/material.dart';
import 'package:pluto_games/models/sith_game_data.dart';
import 'package:pluto_games/models/sith_player_data.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';

class SithPlayers extends StatelessWidget {
  final SithGameData sithGameData;
  const SithPlayers(this.sithGameData, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.builder(
      padding: const EdgeInsets.all(4),
      itemCount: sithGameData.sithPlayers.length,
      itemBuilder: (BuildContext context, int index) {
        SithPlayerData player = sithGameData.sithPlayers[index];
        String title = '';
        if (player.isViceChair) {
          title = 'Vice Chair';
        } else if (player.isPrevViceChair) {
          title = 'Previous Vice Chair';
        } else if (player.isPrimeChancellor) {
          title = 'Prime Chancellor';
        } else if (player.isPrevPrimeChancellor) {
          title = 'Previous Prime Chancellor';
        }
        return Row(
          children: [
            Column(
              children: [
                CircleAvatar(
                  backgroundImage: null,
                  backgroundColor: theme.colorScheme.primary.withAlpha(180),
                  radius: 23,
                  child: Text(player.name),
                ),
                //Text(player.name),
                Text(title),
              ],
            ),
            FlipCard(
              rotateSide: RotateSide.left,
              onTapFlipping: true,
              axis: FlipAxis.vertical,
              controller: FlipCardController(),
              backWidget: Image.asset(
                'images/SecretSith_v1.0/Cards/${player.membership}.jpg',
                width: 100,
                height: 200,
              ),
              frontWidget: Image.asset(
                'images/SecretSith_v1.0/Cards/membership-back.jpg',
                width: 100,
                height: 200,
              ),
            ),
            FlipCard(
              rotateSide: RotateSide.left,
              onTapFlipping: true,
              axis: FlipAxis.vertical,
              controller: FlipCardController(),
              backWidget: Image.asset(
                'images/SecretSith_v1.0/Cards/${player.role}.jpg',
                width: 100,
                height: 200,
              ),
              frontWidget: Image.asset(
                'images/SecretSith_v1.0/Cards/role-back.jpg',
                width: 100,
                height: 200,
              ),
            ),
          ],
        );

        //  'Player: ${player.name} - ${player.membership} - ${player.role} - ${player.isViceChair}');
      },
    );
  }
}
