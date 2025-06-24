class User {
  final String id;
  final String username;
  int coins;

  User({required this.id, required this.username, this.coins = 0});
}

class Host {
  final String id;
  final String name;
  final String description;
  int coinsReceived;
  int giftsReceived;

  Host({
    required this.id,
    required this.name,
    required this.description,
    this.coinsReceived = 0,
    this.giftsReceived = 0,
  });
}

class Gift {
  final String id;
  final String name;
  final int cost;
  final String animationAsset;

  Gift({
    required this.id,
    required this.name,
    required this.cost,
    required this.animationAsset,
  });
}

class Transaction {
  final String id;
  final String userId;
  final String hostId;
  final String giftId;
  final int coinsSpent;
  final DateTime timestamp;

  Transaction({
    required this.id,
    required this.userId,
    required this.hostId,
    required this.giftId,
    required this.coinsSpent,
    required this.timestamp,
  });
}
