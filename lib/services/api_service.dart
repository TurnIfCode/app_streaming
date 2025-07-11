import 'dart:async';
import 'dart:io';

import '../models/models.dart';
import '../config.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Example usage of default API domain
  final String _baseUrl = Config.apiBaseUrl;

  int _idCounter = 0;

  String _generateId() {
    _idCounter++;
    return _idCounter.toString();
  }

  User? _currentUser;

  final List<Host> _hosts = [
    Host(
      id: 'host1@example.com',
      name: 'Host A',
      description: 'Live streaming gaming and chat',
      imageUrl: 'https://example.com/images/host1.jpg',
      viewersCount: 569,
    ),
    Host(
      id: 'host2@example.com',
      name: 'Host B',
      description: 'Music and entertainment live',
      imageUrl: 'https://example.com/images/host2.jpg',
      viewersCount: 128,
    ),
    Host(
      id: 'host3@example.com',
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

  Future<Map<String, dynamic>> login(String username, String password) async {
    String baseUrl = _baseUrl.endsWith('/')
        ? _baseUrl.substring(0, _baseUrl.length - 1)
        : _baseUrl;
    final url = Uri.parse('$baseUrl/api/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'X-CSRF-TOKEN': ''},
      body: jsonEncode({'username': username, 'password': password}),
    );

    final Map<String, dynamic> responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', responseData['token']);
      await prefs.setString('user_id', responseData['user']['id']);
      _currentUser = User.fromJson(responseData['user']);
      return {
        'statusCode': response.statusCode,
        'success': true,
        'message': responseData['message'],
        'user': _currentUser,
        'token': responseData['token'],
      };
    } else if (response.statusCode == 400) {
      return {
        'statusCode': response.statusCode,
        'success': false,
        'message': responseData['message'],
      };
    } else {
      return {
        'statusCode': response.statusCode,
        'success': false,
        'message': 'Terjadi kesalahan pada server',
      };
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await prefs.remove('user_id');
  }

  Future<Map<String, dynamic>> register({
    required String username,
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    // Remove trailing slash from _baseUrl if present
    String baseUrl = _baseUrl.endsWith('/')
        ? _baseUrl.substring(0, _baseUrl.length - 1)
        : _baseUrl;
    final url = Uri.parse('$baseUrl/api/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'name': name,
        'email': email,
        'phone_number': phoneNumber,
        'password': password,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 400) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return {
        'statusCode': response.statusCode,
        'success': responseData['success'],
        'message': responseData['message'],
      };
    } else {
      return {
        'statusCode': response.statusCode,
        'success': false,
        'message': 'Terjadi kesalahan pada server',
      };
    }
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
      users.add(
        User(
          id: userId,
          username: 'User $userId',
          name: '',
          email: '',
          phoneNumber: '',
          isHost: false,
          coins: 0,
          userPhoto: null,
        ),
      );
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

  Future<Map<String, dynamic>> fetchProfile() async {
    String baseUrl = _baseUrl.endsWith('/')
        ? _baseUrl.substring(0, _baseUrl.length - 1)
        : _baseUrl;
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    final userId = prefs.getString('user_id');
    if (token == null || token.isEmpty || userId == null || userId.isEmpty) {
      return {
        'statusCode': 401,
        'success': false,
        'message': 'Unauthenticated.',
      };
    }
    final url = Uri.parse('$baseUrl/api/profile/$userId');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      if (response.headers['content-type']?.contains('application/json') ??
          false) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        _currentUser = User.fromJson(responseData['data']);
        return {
          'statusCode': response.statusCode,
          'success': true,
          'message': responseData['message'] ?? 'Success',
          'data': responseData['data'],
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': 'Unexpected response format',
        };
      }
    } else if (response.statusCode == 401) {
      if (response.headers['content-type']?.contains('application/json') ??
          false) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': responseData['message'] ?? 'Unauthenticated.',
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': 'Unauthenticated.',
        };
      }
    } else {
      return {
        'statusCode': response.statusCode,
        'success': false,
        'message': 'Terjadi kesalahan pada server',
      };
    }
  }

  Future<Map<String, dynamic>> uploadProfilePhoto(File imageFile) async {
    String baseUrl = _baseUrl.endsWith('/')
        ? _baseUrl.substring(0, _baseUrl.length - 1)
        : _baseUrl;
    final url = Uri.parse('$baseUrl/api/profile/upload-photo');
    final token = await getToken();
    if (token == null) {
      return {'success': false, 'message': 'User not authenticated'};
    }
    try {
      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(
        await http.MultipartFile.fromPath('photo', imageFile.path),
      );
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'success': true,
          'message': responseData['message'] ?? 'Upload successful',
          'data': responseData['data'],
        };
      } else {
        return {
          'success': false,
          'message': 'Upload failed with status code ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Upload failed: $e'};
    }
  }

  Future<Map<String, dynamic>> uploadProfilePhotoBase64(
    String base64Image,
  ) async {
    String baseUrl = _baseUrl.endsWith('/')
        ? _baseUrl.substring(0, _baseUrl.length - 1)
        : _baseUrl;
    final url = Uri.parse('$baseUrl/api/change-photo');
    final token = await getToken();
    if (token == null) {
      return {'success': false, 'message': 'User not authenticated'};
    }
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'image': base64Image}),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'success': responseData['success'] ?? true,
          'message': responseData['message'] ?? 'Upload successful',
          'data': responseData['data'],
        };
      } else {
        return {
          'success': false,
          'message': 'Upload failed with status code ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Upload failed: $e'};
    }
  }

  Future<List<Coin>> fetchCoins() async {
    String baseUrl = _baseUrl.endsWith('/')
        ? _baseUrl.substring(0, _baseUrl.length - 1)
        : _baseUrl;
    final url = Uri.parse('$baseUrl/api/coin');
    final response = await http.get(
      url,
      headers: {'accept': 'application/json', 'X-CSRF-TOKEN': ''},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData['success'] == true && responseData['data'] != null) {
        final List<dynamic> data = responseData['data'];
        return data.map((json) => Coin.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load coins: ${responseData['message']}');
      }
    } else {
      throw Exception('Failed to load coins: HTTP ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> fetchWallet(String userId, String token) async {
    String baseUrl = _baseUrl.endsWith('/')
        ? _baseUrl.substring(0, _baseUrl.length - 1)
        : _baseUrl;
    final url = Uri.parse('$baseUrl/api/wallet/$userId');
    final response = await http.get(
      url,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
        'X-CSRF-TOKEN': '',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData;
    } else {
      throw Exception('Failed to load wallet: HTTP ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> startLiveStream(String liveId) async {
    String baseUrl = _baseUrl.endsWith('/')
        ? _baseUrl.substring(0, _baseUrl.length - 1)
        : _baseUrl;
    final url = Uri.parse('$baseUrl/api/live-stream/start');
    final token = await getToken();

    print('INI DIA TOKEN NYA : ${token}');

    if (token == null || token.isEmpty) {
      return {
        'statusCode': 401,
        'success': false,
        'message': 'Unauthorized: Token is null or empty',
      };
    }

    final response = await http.post(
      url,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'X-CSRF-TOKEN': '',
      },
      body: jsonEncode({'live_id': liveId}),
    );

    print('INI DIA RESPONSENYA TOL : ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      HostStream? hostStream;
      if (responseData['success'] == true && responseData['data'] != null) {
        hostStream = HostStream.fromJson(responseData['data']);
      }
      return {
        'statusCode': response.statusCode,
        'success': true,
        'data': responseData,
        'hostStream': hostStream,
      };
    } else {
      return {
        'statusCode': response.statusCode,
        'success': false,
        'message': 'Failed to start live stream',
      };
    }
  }

  Future<Map<String, dynamic>> endLiveStream(String liveId) async {
    String baseUrl = _baseUrl.endsWith('/')
        ? _baseUrl.substring(0, _baseUrl.length - 1)
        : _baseUrl;
    final url = Uri.parse('$baseUrl/live-stream/end');
    final response = await http.post(
      url,
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
        'X-CSRF-TOKEN': '',
      },
      body: jsonEncode({'live_id': liveId}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return {
        'statusCode': response.statusCode,
        'success': true,
        'data': responseData,
      };
    } else {
      return {
        'statusCode': response.statusCode,
        'success': false,
        'message': 'Failed to end live stream',
      };
    }
  }
}
