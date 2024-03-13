import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_games/controllers/sith_game_controller.dart';
import 'package:pluto_games/models/game_user.dart';
import 'package:pluto_games/models/sith_game_data.dart';
import 'package:pluto_games/models/sith_player_data.dart';
import 'package:pluto_games/providers/game_user_provider.dart';
import 'package:pluto_games/providers/sith_game_data_provider.dart';
import 'package:pluto_games/widgets/stack_cards.dart';

class SithPolicy extends ConsumerStatefulWidget {
  const SithPolicy({super.key});

  @override
  ConsumerState<SithPolicy> createState() => _SithPolicyState();
}

class _SithPolicyState extends ConsumerState<SithPolicy> {
  late GameUser gameUser;
  late SithGameData sithGameData;

  @override
  Widget build(BuildContext context) {
    double policyWidth = 60;
    double policyHeight = 100;
    double textScale = 0.60;
    gameUser = ref.watch(gameUserProvider);
    sithGameData = ref.watch(sithGameDataProvider);
    SithPlayerData? thisPlayer =
        SithGameController.getPlayerByID(sithGameData, gameUser.uid);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Card.outlined(
            child: Column(
              children: [
                StackOfCards(
                  sithGameData.policyDraw.length,
                  Image.asset(
                    "images/SecretSith_v1.0/Cards/policy-back.png",
                    width: policyWidth * .75,
                    height: policyHeight * .75,
                  ),
                  2,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    "Draw-${sithGameData.policyDraw.length}",
                    textScaler: TextScaler.linear(textScale),
                  ),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: InkWell(
            onTap: () {},
            child: Image.asset(
              "images/SecretSith_v1.0/Cards/policy-loy.png",
              width: policyWidth,
              height: policyHeight,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: InkWell(
            onTap: () {},
            child: Image.asset(
              "images/SecretSith_v1.0/Cards/policy-sep.png",
              width: policyWidth,
              height: policyHeight,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: InkWell(
            onTap: () {},
            child: Image.asset(
              "images/SecretSith_v1.0/Cards/policy-sep.png",
              width: policyWidth,
              height: policyHeight,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Card.outlined(
            child: Column(
              children: [
                StackOfCards(
                  sithGameData.policyDiscard.length,
                  Image.asset(
                    "images/SecretSith_v1.0/Cards/policy-back.png",
                    width: policyWidth * .75,
                    height: policyHeight * .75,
                  ),
                  2,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    "Discard-${sithGameData.policyDiscard.length}",
                    textScaler: TextScaler.linear(textScale),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
