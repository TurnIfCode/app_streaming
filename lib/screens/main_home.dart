import 'package:app_streaming/screens/live_stream.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'leaderboard.dart';
import 'wallet.dart';
import '../services/api_service.dart';
import 'profile.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen>
    with WidgetsBindingObserver {
  int _selectedIndex = 0;
  final ApiService _apiService = ApiService();

  List<Widget> _pages = [];
  dynamic _currentUser;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadUserAndPages();
  }

  Future<void> _loadUserAndPages() async {
    final result = await ApiService().fetchProfile();
    if (result['success'] == true) {
      _currentUser = ApiService().getCurrentUser();
    } else {
      _currentUser = null;
    }
    print('Ini Dia User yang Login : $_currentUser');
    setState(() {
      _pages = [
        HomeScreen(),
        LeaderboardScreen(),
        LiveStreamScreen(
          isHost: true,
          userName: _currentUser.username,
          userId: _currentUser.id,
        ),
        WalletScreen(),
        ProfileScreen(),
      ];
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadUserAndPages();
    }
  }

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
    await _loadUserAndPages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Removed the AppBar as per user request
      body: _pages.isNotEmpty
          ? _pages[_selectedIndex]
          : Center(child: CircularProgressIndicator()),
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
