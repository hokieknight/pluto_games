import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pluto_games/models/sith_player_data.dart';

class SithGameData {
  String id = "";
  String gameID = "";
  int numPlayers = 0;
  Timestamp createdAt = Timestamp.now();
  List<SithPlayerData> sithPlayers = [];
  int turn = 1;
  String phase = "pick-chancellor";
  String electionResult = "";
  List<dynamic> policyDraw = [];
  List<dynamic> policyHand = [];
  List<dynamic> policyDiscard = [];
  int policiesEnactedLoy = 0;
  int policiesEnactedSep = 0;
  String policyResult = "";

  SithGameData();

  SithGameData.fromJson(String newid, Map<String, dynamic> json)
      : id = newid,
        gameID = json['gameID'] as String,
        numPlayers = json['numPlayers'] as int,
        createdAt = json['createdAt'] as Timestamp,
        sithPlayers = List<SithPlayerData>.from(
            json['sithPlayers'].map((model) => SithPlayerData.fromJson(model))),
        turn = json['turn'] as int,
        phase = json['phase'] as String,
        electionResult = json['electionResult'] as String,
        policyDraw = json['policyDraw'],
        policyHand = json['policyHand'],
        policyDiscard = json['policyDiscard'],
        policiesEnactedLoy = json['policiesEnactedLoy'],
        policiesEnactedSep = json['policiesEnactedSep'],
        policyResult = json['policyResult'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'gameID': gameID,
        'numPlayers': numPlayers,
        'createdAt': createdAt,
        'sithPlayers': sithPlayers.map((e) => e.toJson()),
        'turn': turn,
        'phase': phase,
        'electionResult': electionResult,
        'policyDraw': policyDraw,
        'policyHand': policyHand,
        'policyDiscard': policyDiscard,
        'policiesEnactedLoy': policiesEnactedLoy,
        'policiesEnactedSep': policiesEnactedSep,
        'policyResult': policyResult,
      };

  Future<void> addRemote() async {
    await FirebaseFirestore.instance.collection('sith_game_data').add({
      'gameID': gameID,
      'numPlayers': numPlayers,
      'createdAt': Timestamp.now(),
      'sithPlayers': sithPlayers.map((e) => e.toJson()).toList(),
      'turn': turn,
      'phase': phase,
      'electionResult': electionResult,
      'policyDraw': policyDraw,
      'policyHand': policyHand,
      'policyDiscard': policyDiscard,
      'policiesEnactedLoy': policiesEnactedLoy,
      'policiesEnactedSep': policiesEnactedSep,
      'policyResult': policyResult,
    }).then((value) => id = value.id);
  }

  static Future<SithGameData> getRemote(id) async {
    final ref = await FirebaseFirestore.instance
        .collection('sith_game_data')
        .doc(id)
        .get();

    if (ref.data() != null) {
      final data = ref.data()!;
      return SithGameData.fromJson(id, data);
    } else {
      return SithGameData();
    }
  }

  Future<void> setRemote() async {
    await FirebaseFirestore.instance.collection('sith_game_data').doc(id).set({
      'gameID': gameID,
      'numPlayers': numPlayers,
      'createdAt': Timestamp.now(),
      'sithPlayers': sithPlayers.map((e) => e.toJson()).toList(),
      'turn': turn,
      'phase': phase,
      'electionResult': electionResult,
      'policyDraw': policyDraw,
      'policyHand': policyHand,
      'policyDiscard': policyDiscard,
      'policiesEnactedLoy': policiesEnactedLoy,
      'policiesEnactedSep': policiesEnactedSep,
      'policyResult': policyResult,
    });
  }
}
