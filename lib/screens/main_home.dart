import 'package:flutter/material.dart';
import 'home.dart';
import 'live_stream_watch.dart'; // Corrected import for live stream screen
import 'host_profile.dart';
import 'leaderboard.dart';
import 'wallet.dart';
import '../services/api_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';
import 'profile.dart'; // Added import for ProfileScreen

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _selectedIndex = 0;
  final ApiService _apiService = ApiService();

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    final user = ApiService().getCurrentUser();
    _pages = [
      HomeScreen(),
      LeaderboardScreen(),
      if (user != null)
        LiveStreamWatchScreen(
          liveID: user.id,
          userName: user.username,
          userId: user.id,
        )
      else
        LiveStreamWatchScreen(liveID: '', userName: '', userId: ''),
      WalletScreen(),
      ProfileScreen(), // Changed from UserProfileScreen to ProfileScreen
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Rank',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.videocam),
            label: 'Live Streaming',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
