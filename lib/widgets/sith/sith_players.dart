import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_games/controllers/sith_game_controller.dart';
import 'package:pluto_games/models/game_user.dart';
import 'package:pluto_games/models/sith_game_data.dart';
import 'package:pluto_games/models/sith_player_data.dart';
import 'package:pluto_games/models/snapshot_handler.dart';
import 'package:pluto_games/providers/game_user_provider.dart';
import 'package:pluto_games/providers/sith_game_data_provider.dart';
import 'package:pluto_games/widgets/my_flipcard.dart';
import 'package:pluto_games/widgets/sith/sith_player_name.dart';

class SithPlayers extends ConsumerStatefulWidget {
  const SithPlayers({super.key});

  @override
  ConsumerState<SithPlayers> createState() => _SithPlayersState();
}

class _SithPlayersState extends ConsumerState<SithPlayers> {
  late GameUser gameUser;
  late SithGameData sithGameData;

  void _nominatePC(SithPlayerData player) async {
    sithGameData = await SithGameData.getRemote(sithGameData.id);
    SithGameController.nominatePrimeChancellor(sithGameData, player);
    ref.read(sithGameDataProvider.notifier).setSithGameData(sithGameData);
    sithGameData.setRemote();
  }

  void nominatePC(BuildContext context, SithPlayerData player) async {
    bool selectPC = SithGameController.canSelectPC(sithGameData, gameUser.uid);
    //(selectPC && !player.isViceChair) ? _nominatePC : null
    if (!selectPC) return;
    if (player.isViceChair) return;
    if (player.isPrevPrimeChancellor) return;
    if (player.isPrevViceChair) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nominate Prime Chancellor'),
        content: Text('Confirm nomination of ${player.name}'),
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
              _nominatePC(player);
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    gameUser = ref.watch(gameUserProvider);
    sithGameData = ref.watch(sithGameDataProvider);

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('sith_game_data')
          .doc(sithGameData.id)
          .snapshots(),
      builder: (ctx, snapshot) {
        Widget? widget = handleSnapshot(snapshot, "Sith Game");
        if (widget != null) return widget;

        Map<String, dynamic>? data = snapshot.data!.data();
        sithGameData = SithGameData.fromJson(sithGameData.id, data!);

        return ListView.builder(
          //padding: const EdgeInsets.all(2),
          itemCount: sithGameData.sithPlayers.length,
          itemBuilder: (BuildContext context, int index) {
            SithPlayerData player = sithGameData.sithPlayers[index];
            return Row(
              children: [
                SithPlayerName(player, gameUser.uid == player.id, nominatePC),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: MyFlipCard(
                    'images/SecretSith_v1.0/Cards/membership-back.jpg',
                    'images/SecretSith_v1.0/Cards/${player.membership}.jpg',
                    gameUser.uid == player.id,
                    100,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: MyFlipCard(
                    'images/SecretSith_v1.0/Cards/role-back.jpg',
                    'images/SecretSith_v1.0/Cards/${player.role}.jpg',
                    gameUser.uid == player.id,
                    100,
                  ),
                ),
                if (SithGameController.isVotePhase(sithGameData) &&
                    player.vote.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(
                        "images/SecretSith_v1.0/Cards/confidence-back.jpg",
                        width: 80),
                  ),
                if (!SithGameController.isVotePhase(sithGameData) &&
                    player.vote == "Yes")
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(
                        "images/SecretSith_v1.0/Cards/confidence-yes.jpg",
                        width: 80),
                  ),
                if (!SithGameController.isVotePhase(sithGameData) &&
                    player.vote == "No")
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(
                        "images/SecretSith_v1.0/Cards/confidence-no.jpg",
                        width: 80),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
