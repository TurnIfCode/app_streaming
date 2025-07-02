import 'package:flutter/material.dart';
import 'home.dart';
import 'live_stream.dart';
import 'host_profile.dart';
import 'leaderboard.dart';
import 'wallet.dart';
import '../services/api_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';

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
    _pages = [
      HomeScreen(),
      LeaderboardScreen(),
      LiveStreamStartScreen(),
      WalletScreen(),
      UserProfileScreen(),
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

class LiveStreamStartScreen extends StatefulWidget {
  const LiveStreamStartScreen({super.key});

  @override
  _LiveStreamStartScreenState createState() => _LiveStreamStartScreenState();
}

class _LiveStreamStartScreenState extends State<LiveStreamStartScreen> {
  bool _cameraPermissionGranted = false;
  bool _micPermissionGranted = false;
  bool _isStreaming = false;

  CameraController? _cameraController;
  List<CameraDescription>? _cameras;

  Future<void> _requestPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final micStatus = await Permission.microphone.request();

    setState(() {
      _cameraPermissionGranted = cameraStatus.isGranted;
      _micPermissionGranted = micStatus.isGranted;
    });
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      // Select front camera
      CameraDescription? frontCamera;
      for (var camera in _cameras!) {
        if (camera.lensDirection == CameraLensDirection.front) {
          frontCamera = camera;
          break;
        }
      }
      final selectedCamera = frontCamera ?? _cameras![0];
      _cameraController = CameraController(
        selectedCamera,
        ResolutionPreset.max, // Use max resolution for full screen
      );
      await _cameraController!.initialize();
      if (mounted) {
        setState(() {});
      }
    }
  }

  void _startStreaming() async {
    if (_cameraPermissionGranted && _micPermissionGranted) {
      await _initializeCamera();
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
    _cameraController?.dispose();
    _cameraController = null;
    setState(() {
      _isStreaming = false;
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
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
                  _cameraController != null &&
                          _cameraController!.value.isInitialized
                      ? Expanded(child: CameraPreview(_cameraController!))
                      : Container(
                          color: Colors.black,
                          child: Center(
                            child: Text(
                              'Initializing camera...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
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
                onPressed: () {
                  final user = ApiService().getCurrentUser();
                  if (user != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LiveStreamScreen(
                          liveID: user.id,
                          userName: user.username,
                          isHost: true,
                          userId: user.id,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('User not logged in')),
                    );
                  }
                },
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
