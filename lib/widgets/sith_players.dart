import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_games/models/game_user.dart';
import 'package:pluto_games/models/sith_game_data.dart';
import 'package:pluto_games/models/sith_player_data.dart';
import 'package:pluto_games/models/snapshot_handler.dart';
import 'package:pluto_games/providers/game_user_provider.dart';
import 'package:pluto_games/providers/sith_game_data_provider.dart';
import 'package:pluto_games/widgets/my_flipcard.dart';
import 'package:pluto_games/widgets/sith_player_name.dart';

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

    for (var player in sithGameData.sithPlayers) {
      player.isPrimeChancellor = false;
      player.vote = "";
    }

    int index = sithGameData.sithPlayers
        .indexWhere((element) => element.id == player.id);
    if (index < 0) return;
    sithGameData.sithPlayers[index].isPrimeChancellor = true;
    sithGameData.nextPhase();

    ref.read(sithGameDataProvider.notifier).setSithGameData(sithGameData);
    sithGameData.setRemote();
  }

  void nominatePC(BuildContext context, SithPlayerData player) async {
    bool selectPC = sithGameData.isSelectPC(gameUser.uid);
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
                SithPlayerName(player, nominatePC),
                MyFlipCard('images/SecretSith_v1.0/Cards/membership-back.jpg',
                    'images/SecretSith_v1.0/Cards/${player.membership}.jpg'),
                MyFlipCard('images/SecretSith_v1.0/Cards/role-back.jpg',
                    'images/SecretSith_v1.0/Cards/${player.role}.jpg'),
                if (sithGameData.isVotePhase() && player.vote.isNotEmpty)
                  Image.asset(
                      "images/SecretSith_v1.0/Cards/confidence-back.jpg",
                      width: 100),
                if (!sithGameData.isVotePhase() && player.vote == "Yes")
                  Image.asset("images/SecretSith_v1.0/Cards/confidence-yes.jpg",
                      width: 100),
                if (!sithGameData.isVotePhase() && player.vote == "No")
                  Image.asset("images/SecretSith_v1.0/Cards/confidence-no.jpg",
                      width: 100),
              ],
            );
          },
        );
      },
    );
  }
}
