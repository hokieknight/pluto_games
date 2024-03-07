class SecretSithPlayerData {
  String id;
  String name;
  String? membership;
  String? role;
  bool isViceChair = false;
  bool isPrimeChancellor = false;
  bool isPrevViceChair = false;
  bool isPrevPrimeChancellor = false;
  String? currentVote;

  SecretSithPlayerData({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'membership': membership,
        'role': role,
        'isViceChair': isViceChair,
        'isPrimeChancellor': isPrimeChancellor,
        'isPrevViceChair': isPrevViceChair,
        'isPrevPrimeChancellor': isPrevPrimeChancellor,
        'currentVote': currentVote,
      };
}
