import 'package:flutter/material.dart';
import '../services/api_service.dart';

class LiveStreamScreen extends StatefulWidget {
  final String hostId;
  final String hostName;

  const LiveStreamScreen({
    super.key,
    required this.hostId,
    required this.hostName,
  });

  @override
  _LiveStreamScreenState createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends State<LiveStreamScreen> {
  final ApiService _apiService = ApiService();
  int userCoins = 0;
  int hostCoinsReceived = 0;
  bool _loading = false;

  late List gifts;
  final List<String> comments = [];
  final Set<String> commenters = {};
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = _apiService.getCurrentUser();
    userCoins = user?.coins ?? 0;
    final host = _apiService.getHostById(widget.hostId);
    hostCoinsReceived = host?.coinsReceived ?? 0;
    gifts = _apiService.getGifts();
  }

  void sendGift(String giftId, int cost) async {
    if (_loading) return;
    if (userCoins < cost) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Not enough coins')));
      return;
    }
    setState(() {
      _loading = true;
    });
    bool success = await _apiService.sendGift(widget.hostId, giftId);
    if (success) {
      final user = _apiService.getCurrentUser();
      final host = _apiService.getHostById(widget.hostId);
      setState(() {
        userCoins = user?.coins ?? 0;
        hostCoinsReceived = host?.coinsReceived ?? 0;
        _loading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gift sent successfully')));
    } else {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to send gift')));
    }
  }

  void sendComment() {
    final text = _commentController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        comments.add(text);
        commenters.add('User${comments.length}'); // Dummy user name for demo
        _commentController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final isWideScreen = width > 600;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Fullscreen video placeholder
            Positioned.fill(
              child: Container(
                color: Colors.black,
                child: Center(
                  child: Text(
                    'Live Stream Video Placeholder',
                    style: TextStyle(fontSize: 24, color: Colors.white54),
                  ),
                ),
              ),
            ),
            // Comments list overlay at bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 120,
              height: 150,
              child: Container(
                color: Colors.black.withOpacity(0.4),
                child: ListView.builder(
                  reverse: true,
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[comments.length - 1 - index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      child: Text(
                        comment,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Comment input field at bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 60,
              child: Container(
                color: Colors.black.withOpacity(0.6),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Enter comment',
                          hintStyle: TextStyle(color: Colors.white70),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.black54,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 0,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: sendComment,
                    ),
                  ],
                ),
              ),
            ),
            // Gift buttons overlay at bottom right
            Positioned(
              right: 8,
              bottom: 180,
              height: 100,
              child: Container(
                color: Colors.black.withOpacity(0.4),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: gifts.length,
                  itemBuilder: (context, index) {
                    final gift = gifts[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.card_giftcard, color: Colors.white),
                        label: Text(
                          '\${gift.name} (\${gift.cost})',
                          style: TextStyle(fontSize: 12),
                        ),
                        onPressed: _loading
                            ? null
                            : () => sendGift(gift.id, gift.cost),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue,
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // User list overlay at top right
            Positioned(
              right: 8,
              top: 8,
              width: 120,
              height: 100,
              child: Container(
                color: Colors.black.withOpacity(0.4),
                child: ListView(
                  children: commenters
                      .map(
                        (user) => Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 4,
                          ),
                          child: Text(
                            user,
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            // Back button top left
            Positioned(
              top: 8,
              left: 8,
              child: SafeArea(
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
