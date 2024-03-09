import 'package:flutter/material.dart';
import 'package:pluto_games/models/sith_game_data.dart';
import 'package:pluto_games/models/sith_player_data.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:pluto_games/widgets/sith_player_name.dart';

class SithPlayers extends StatelessWidget {
  final SithGameData sithGameData;
  const SithPlayers(this.sithGameData, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(4),
      itemCount: sithGameData.sithPlayers.length,
      itemBuilder: (BuildContext context, int index) {
        SithPlayerData player = sithGameData.sithPlayers[index];
        return Row(
          children: [
            SithPlayerName(player),
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
