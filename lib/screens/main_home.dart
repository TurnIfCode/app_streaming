import 'package:flutter/material.dart';
import 'home.dart';
import 'live_stream.dart';
import 'host_profile.dart';
import '../services/api_service.dart';
import 'package:permission_handler/permission_handler.dart';

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
    _pages = [HomeScreen(), LiveStreamStartScreen(), UserProfileScreen()];
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.videocam),
            label: 'Live Streaming',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class LiveStreamStartScreen extends StatefulWidget {
  const LiveStreamStartScreen({super.key});

  @override
  _LiveStreamStartScreenState createState() => _LiveStreamStartScreenState();
}

class _LiveStreamStartScreenState extends State<LiveStreamStartScreen> {
  bool _cameraPermissionGranted = false;
  bool _micPermissionGranted = false;
  bool _isStreaming = false;

  Future<void> _requestPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final micStatus = await Permission.microphone.request();

    setState(() {
      _cameraPermissionGranted = cameraStatus.isGranted;
      _micPermissionGranted = micStatus.isGranted;
    });
  }

  void _startStreaming() {
    if (_cameraPermissionGranted && _micPermissionGranted) {
      setState(() {
        _isStreaming = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Camera and microphone permissions are required'),
        ),
      );
    }
  }

  void _stopStreaming() {
    setState(() {
      _isStreaming = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Start Live Streaming')),
      body: Center(
        child: _isStreaming
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.black,
                    height: 400,
                    width: 300,
                    child: Center(
                      child: Text(
                        'Camera Preview Placeholder',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _stopStreaming,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text('Stop Streaming'),
                  ),
                ],
              )
            : ElevatedButton(
                onPressed: _startStreaming,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                ),
                child: Text('Start Live Stream'),
              ),
      ),
    );
  }
}

class UserProfileScreen extends StatelessWidget {
  final ApiService _apiService = ApiService();

  UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = _apiService.getCurrentUser();

    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: user == null
          ? Center(child: Text('No user logged in'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    child: Text(
                      user.username.isNotEmpty ? user.username[0] : '',
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    user.username,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 10),
                  Text("Coins: \${user.coins}"),
                ],
              ),
            ),
    );
  }
}
