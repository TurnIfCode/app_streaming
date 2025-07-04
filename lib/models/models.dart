class Host {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int viewersCount;
  int coinsReceived;
  int giftsReceived;

  Host({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.viewersCount,
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

class UserPhoto {
  final String id;
  final String userId;
  final String image;

  UserPhoto({required this.id, required this.userId, required this.image});

  factory UserPhoto.fromJson(Map<String, dynamic> json) {
    return UserPhoto(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      image: json['image'] as String,
    );
  }
}

class User {
  final String id;
  final String username;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final String phoneNumber;
  final bool isHost;
  int coins;
  final UserPhoto? userPhoto;

  User({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.phoneNumber,
    required this.isHost,
    this.coins = 0,
    this.userPhoto,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      emailVerifiedAt: json['email_verified_at'] as String?,
      phoneNumber: json['phone_number'] as String,
      isHost: (json['is_host'] as int) == 1,
      coins: json['coins'] != null ? json['coins'] as int : 0,
      userPhoto: json['user_photo'] != null
          ? UserPhoto.fromJson(json['user_photo'])
          : null,
    );
  }
}
