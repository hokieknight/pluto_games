class SithPlayerData {
  String id;
  String name;
  String membership = "";
  String role = "";
  bool isViceChair = false;
  bool isPrimeChancellor = false;
  bool isPrevViceChair = false;
  bool isPrevPrimeChancellor = false;
  String vote = "";
  bool assassinated = false;

  SithPlayerData({
    required this.id,
    required this.name,
  });

  SithPlayerData.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        name = json['name'] as String,
        membership = json['membership'] as String,
        role = json['role'] as String,
        isViceChair = json['isViceChair'] as bool,
        isPrimeChancellor = json['isPrimeChancellor'] as bool,
        isPrevViceChair = json['isPrevViceChair'] as bool,
        isPrevPrimeChancellor = json['isPrevPrimeChancellor'] as bool,
        vote = json['vote'] as String,
        assassinated = json['assassinated'] as bool;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'membership': membership,
        'role': role,
        'isViceChair': isViceChair,
        'isPrimeChancellor': isPrimeChancellor,
        'isPrevViceChair': isPrevViceChair,
        'isPrevPrimeChancellor': isPrevPrimeChancellor,
        'vote': vote,
        'assassinated': assassinated,
      };
}
