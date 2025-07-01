import 'dart:async';
import '../models/models.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  int _idCounter = 0;

  String _generateId() {
    _idCounter++;
    return _idCounter.toString();
  }

  User? _currentUser;

  final List<Host> _hosts = [
    Host(
      id: 'host1',
      name: 'Host A',
      description: 'Live streaming gaming and chat',
      imageUrl: 'https://example.com/images/host1.jpg',
      viewersCount: 569,
    ),
    Host(
      id: 'host2',
      name: 'Host B',
      description: 'Music and entertainment live',
      imageUrl: 'https://example.com/images/host2.jpg',
      viewersCount: 128,
    ),
    Host(
      id: 'host3',
      name: 'Host C',
      description: 'Travel and lifestyle streaming',
      imageUrl: 'https://example.com/images/host3.jpg',
      viewersCount: 100,
    ),
  ];

  final List<Gift> _gifts = [
    Gift(
      id: 'gift1',
      name: 'Flower',
      cost: 10,
      animationAsset: 'assets/flower.json',
    ),
    Gift(
      id: 'gift2',
      name: 'Heart',
      cost: 20,
      animationAsset: 'assets/heart.json',
    ),
    Gift(
      id: 'gift3',
      name: 'Dragon',
      cost: 100,
      animationAsset: 'assets/dragon.json',
    ),
  ];

  final List<Transaction> _transactions = [];

  Future<User> login(String username) async {
    // Simulate API delay
    await Future.delayed(Duration(seconds: 1));
    _currentUser = User(id: _generateId(), username: username, coins: 0);
    return _currentUser!;
  }

  Future<bool> verifyDeposit(int amount) async {
    // Simulate admin verification delay
    await Future.delayed(Duration(seconds: 2));
    if (_currentUser != null) {
      _currentUser!.coins += amount;
      return true;
    }
    return false;
  }

  List<Host> getHosts() {
    return _hosts;
  }

  List<Gift> getGifts() {
    return _gifts;
  }

  User? getCurrentUser() {
    return _currentUser;
  }

  Future<bool> sendGift(String hostId, String giftId) async {
    if (_currentUser == null) return false;
    final gift = _gifts.firstWhere(
      (g) => g.id == giftId,
      orElse: () => throw Exception('Gift not found'),
    );
    if (_currentUser!.coins < gift.cost) return false;

    Host? host;
    try {
      host = _hosts.firstWhere((h) => h.id == hostId);
    } catch (e) {
      host = null;
    }
    if (host == null) return false;

    // Deduct coins from user
    _currentUser!.coins -= gift.cost;

    // Add coins and gifts to host
    host.coinsReceived += gift.cost;
    host.giftsReceived += 1;

    // Record transaction
    _transactions.add(
      Transaction(
        id: _generateId(),
        userId: _currentUser!.id,
        hostId: hostId,
        giftId: giftId,
        coinsSpent: gift.cost,
        timestamp: DateTime.now(),
      ),
    );

    // Simulate API delay
    await Future.delayed(Duration(milliseconds: 500));
    return true;
  }

  List<Host> getTopStreamers({int limit = 10}) {
    List<Host> sorted = List.from(_hosts);
    sorted.sort((a, b) => b.coinsReceived.compareTo(a.coinsReceived));
    return sorted.take(limit).toList();
  }

  List<User> getTopGifters({int limit = 10}) {
    // Aggregate coins spent by user from transactions
    Map<String, int> userSpent = {};
    for (var tx in _transactions) {
      userSpent[tx.userId] = (userSpent[tx.userId] ?? 0) + tx.coinsSpent;
    }
    // Create dummy users for demonstration
    List<User> users = [];
    userSpent.forEach((userId, spent) {
      users.add(User(id: userId, username: 'User $userId', coins: 0));
    });
    users.sort(
      (a, b) => (userSpent[b.id] ?? 0).compareTo(userSpent[a.id] ?? 0),
    );
    return users.take(limit).toList();
  }

  Host? getHostById(String hostId) {
    try {
      return _hosts.firstWhere((h) => h.id == hostId);
    } catch (e) {
      return null;
    }
  }

  List<Transaction> getTransactions() {
    return _transactions;
  }
}
