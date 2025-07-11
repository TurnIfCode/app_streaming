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

  Map<String, dynamic> toJson() {
    return {'id': id, 'user_id': userId, 'image': image};
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'phone_number': phoneNumber,
      'is_host': isHost ? 1 : 0,
      'user_photo': userPhoto?.toJson(),
    };
  }
}

class Coin {
  final String id;
  final int coinAmount;
  final int price;
  final int isBigDeal;
  final int finalPrice;

  Coin({
    required this.id,
    required this.coinAmount,
    required this.price,
    required this.isBigDeal,
    required this.finalPrice,
  });

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      id: json['id'] as String,
      coinAmount: json['coin_amount'] as int,
      price: json['price'] as int,
      isBigDeal: json['is_big_deal'] as int,
      finalPrice: json['final_price'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'coin_amount': coinAmount,
      'price': price,
      'is_big_deal': isBigDeal,
      'final_price': finalPrice,
    };
  }
}

class Wallet {
  final String id;
  final String userId;
  final int amount;

  Wallet({required this.id, required this.userId, required this.amount});

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      amount: json['amount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'user_id': userId, 'amount': amount};
  }
}

class HostStream {
  final String id;
  final String userId;
  final String liveId;
  final String username;
  final String status;

  HostStream({
    required this.id,
    required this.userId,
    required this.liveId,
    required this.username,
    required this.status,
  });

  factory HostStream.fromJson(Map<String, dynamic> json) {
    return HostStream(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      liveId: json['live_id'] as String,
      username: json['username'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'live_id': liveId,
      'username': username,
      'status': status,
    };
  }
}

class HostLiveStream {
  final String id;
  final String userId;
  final String liveId;
  final String username;
  final String status;
  final User user;

  HostLiveStream({
    required this.id,
    required this.userId,
    required this.liveId,
    required this.username,
    required this.status,
    required this.user,
  });

  factory HostLiveStream.fromJson(Map<String, dynamic> json) {
    return HostLiveStream(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      liveId: json['live_id'] as String,
      username: json['username'] as String,
      status: json['status'] as String,
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'live_id': liveId,
      'username': username,
      'status': status,
      'user': user.toJson(),
    };
  }
}

class HostLiveStreams {
  final int currentPage;
  final List<HostLiveStream> data;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final List<dynamic> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  HostLiveStreams({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory HostLiveStreams.fromJson(Map<String, dynamic> json) {
    return HostLiveStreams(
      currentPage: json['current_page'] as int,
      data: (json['data'] as List<dynamic>)
          .map((e) => HostLiveStream.fromJson(e as Map<String, dynamic>))
          .toList(),
      firstPageUrl: json['first_page_url'] as String,
      from: json['from'] as int,
      lastPage: json['last_page'] as int,
      lastPageUrl: json['last_page_url'] as String,
      links: json['links'] as List<dynamic>,
      nextPageUrl: json['next_page_url'] as String?,
      path: json['path'] as String,
      perPage: json['per_page'] as int,
      prevPageUrl: json['prev_page_url'] as String?,
      to: json['to'] as int,
      total: json['total'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': data.map((e) => e.toJson()).toList(),
      'first_page_url': firstPageUrl,
      'from': from,
      'last_page': lastPage,
      'last_page_url': lastPageUrl,
      'links': links,
      'next_page_url': nextPageUrl,
      'path': path,
      'per_page': perPage,
      'prev_page_url': prevPageUrl,
      'to': to,
      'total': total,
    };
  }
}
