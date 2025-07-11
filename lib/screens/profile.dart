import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/models.dart';
import 'main_home.dart';
import 'profile_photo_upload.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  bool _loading = true;
  String? _errorMessage;
  User? _user;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  void _fetchProfile() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    final result = await _apiService.fetchProfile();
    if (result['statusCode'] == 200 && result['success'] == true) {
      final user = await _apiService.getCurrentUser();
      setState(() {
        _user = user;
        _loading = false;
      });
    } else if (result['statusCode'] == 401) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainHomeScreen()),
        );
      }
    } else {
      setState(() {
        _errorMessage = result['message'] ?? 'Terjadi kesalahan.';
        _loading = false;
      });
    }
  }

  Widget _buildAccountInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          SizedBox(width: 12),
          Text(
            '$label',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor =
        Colors.blueAccent; // Telegram blue or app primary color

    if (_loading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_errorMessage != null) {
      return Scaffold(body: Center(child: Text(_errorMessage!)));
    }

    if (_user == null) {
      return Scaffold(body: Center(child: Text('No profile data')));
    }

    ImageProvider? userPhoto;
    if (_user!.userPhoto != null && _user!.userPhoto!.image.isNotEmpty) {
      try {
        String userPhotoBase64 = _user!.userPhoto!.image;
        if (userPhotoBase64.startsWith('data:image')) {
          final index = userPhotoBase64.indexOf(',');
          if (index != -1) {
            userPhotoBase64 = userPhotoBase64.substring(index + 1);
          }
        }
        final decodedBytes = base64Decode(userPhotoBase64);
        userPhoto = MemoryImage(decodedBytes);
      } catch (e) {
        userPhoto = null;
      }
    }

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor.withOpacity(0.8), primaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 40,
                  left: 16,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            foregroundImage: userPhoto,
                            child: userPhoto == null
                                ? Text(
                                    _user!.name.isNotEmpty
                                        ? _user!.name[0].toUpperCase()
                                        : '',
                                    style: TextStyle(
                                      fontSize: 40,
                                      color: primaryColor,
                                    ),
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () async {
                                if (_user != null) {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProfilePhotoUploadScreen(
                                            user: _user!,
                                          ),
                                    ),
                                  );
                                  if (result == true) {
                                    _fetchProfile();
                                  }
                                }
                              },
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.edit,
                                  size: 18,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        '@${_user!.username}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        _user!.email,
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Account Info',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 12),
                _buildAccountInfoRow(Icons.person_outline, 'Name', _user!.name),
                _buildAccountInfoRow(
                  Icons.phone_android,
                  'Mobile',
                  _user!.phoneNumber,
                ),
                _buildAccountInfoRow(
                  Icons.email_outlined,
                  'Email',
                  _user!.email,
                ),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ElevatedButton.icon(
              onPressed: () async {
                await _apiService.clearToken();
                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainHomeScreen()),
                  );
                }
              },
              icon: Icon(Icons.logout),
              label: Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
