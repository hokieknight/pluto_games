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

  void discardPolicy(int index) async {
    sithGameData = await SithGameData.getRemote(sithGameData.id);
    SithGameController.discardPolicy(sithGameData, index);
    ref.read(sithGameDataProvider.notifier).setSithGameData(sithGameData);
    sithGameData.setRemote();
    //setState(() {});
  }

  void discardPolicy0() {
    discardPolicy(0);
  }

  void discardPolicy1() {
    discardPolicy(1);
  }

  void discardPolicy2() {
    discardPolicy(2);
  }

  Widget? getPolicyWidget(index, SithPlayerData? thisPlayer) {
    //double policyWidth = 60;
    double policyHeight = 100;

    if (SithGameController.isPolicyPhase1(sithGameData) &&
        !thisPlayer!.isViceChair) {
      return Image.asset(
        "images/SecretSith_v1.0/Cards/policy-back.png",
        //width: policyWidth,
        height: policyHeight,
      );
    }
    if (SithGameController.isPolicyPhase2(sithGameData) && (index > 1)) {
      return null;
    }
    if (SithGameController.isPolicyPhase2(sithGameData) &&
        !thisPlayer!.isPrimeChancellor) {
      return Image.asset(
        "images/SecretSith_v1.0/Cards/policy-back.png",
        //width: policyWidth,
        height: policyHeight,
      );
    }

    List<dynamic> policyHand = sithGameData.policyHand;

    void Function() onTap = discardPolicy0;
    if (index == 1) onTap = discardPolicy1;
    if (index == 2) onTap = discardPolicy2;

    return InkWell(
      onTap: onTap,
      child: Image.asset(
        "images/SecretSith_v1.0/Cards/policy-${policyHand[0]}.png",
        //width: policyWidth,
        height: policyHeight,
      ),
    );
  }

  Widget getCardPileWidget(int count, String name) {
    return Card.outlined(
      child: Column(
        children: [
          StackOfCards(
            sithGameData.policyDraw.length,
            Image.asset(
              "images/SecretSith_v1.0/Cards/policy-back.png",
              //width: policyWidth * .75,
              height: 75,
            ),
            2,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              "$name-$count",
              textScaler: const TextScaler.linear(0.6),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    gameUser = ref.watch(gameUserProvider);
    sithGameData = ref.watch(sithGameDataProvider);

    SithPlayerData? thisPlayer =
        SithGameController.getPlayerByID(sithGameData, gameUser.uid);

    Widget? policyWidget0 = getPolicyWidget(0, thisPlayer);
    Widget? policyWidget1 = getPolicyWidget(1, thisPlayer);
    Widget? policyWidget2 = getPolicyWidget(2, thisPlayer);
    Widget drawPile = getCardPileWidget(sithGameData.policyDraw.length, "Draw");
    Widget discardPile =
        getCardPileWidget(sithGameData.policyDiscard.length, "Discard");

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(padding: const EdgeInsets.all(4.0), child: drawPile),
        Padding(padding: const EdgeInsets.all(4.0), child: policyWidget0),
        Padding(padding: const EdgeInsets.all(4.0), child: policyWidget1),
        if (policyWidget2 != null)
          Padding(padding: const EdgeInsets.all(4.0), child: policyWidget2),
        Padding(padding: const EdgeInsets.all(4.0), child: discardPile),
      ],
    );
  }
}
