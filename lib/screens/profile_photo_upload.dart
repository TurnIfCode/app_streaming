import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/api_service.dart';
import '../models/models.dart';

class ProfilePhotoUploadScreen extends StatefulWidget {
  final User user;
  const ProfilePhotoUploadScreen({super.key, required this.user});

  @override
  _ProfilePhotoUploadScreenState createState() =>
      _ProfilePhotoUploadScreenState();
}

class _ProfilePhotoUploadScreenState extends State<ProfilePhotoUploadScreen> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final ApiService _apiService = ApiService();

  bool _loading = false;
  String? _errorMessage;

  User get _user => widget.user;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _showPickOptionsDialog(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              title: Text('Pilih dari album'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              title: Text('Ambil foto'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final bytes = await _imageFile!.readAsBytes();
      final base64Image = base64Encode(bytes);

      final result = await _apiService.uploadProfilePhotoBase64(base64Image);

      setState(() {
        _loading = false;
      });

      if (result['success'] == true) {
        if (mounted) {
          Navigator.pop(context, true);
        }
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Upload gagal.';
        });
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _errorMessage = 'Terjadi kesalahan saat mengupload foto.';
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
    final primaryColor = Colors.blueAccent;

    ImageProvider? userPhoto;
    if (_user.userPhoto != null && _user.userPhoto!.image.isNotEmpty) {
      try {
        String userPhotoBase64 = _user.userPhoto!.image;
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
      appBar: AppBar(
        title: Text('Unggah Avatar'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => _showPickOptionsDialog(context),
                    child: Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        image: _imageFile != null
                            ? DecorationImage(
                                image: FileImage(_imageFile!),
                                fit: BoxFit.cover,
                              )
                            : (userPhoto != null
                                  ? DecorationImage(
                                      image: userPhoto,
                                      fit: BoxFit.cover,
                                    )
                                  : null),
                      ),
                      child: _imageFile == null && userPhoto == null
                          ? Center(
                              child: Text(
                                _user.name.isNotEmpty
                                    ? _user.name[0].toUpperCase()
                                    : '',
                                style: TextStyle(
                                  fontSize: 100,
                                  color: primaryColor,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _uploadImage,
                    icon: Icon(Icons.upload),
                    label: Text('Unggah'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Informasi Akun',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildAccountInfoRow(
                    Icons.person_outline,
                    'Nama',
                    _user.name,
                  ),
                  _buildAccountInfoRow(
                    Icons.alternate_email,
                    'Username',
                    _user.username,
                  ),
                  _buildAccountInfoRow(
                    Icons.email_outlined,
                    'Email',
                    _user.email,
                  ),
                  _buildAccountInfoRow(
                    Icons.phone_android,
                    'Telepon',
                    _user.phoneNumber,
                  ),
                ],
              ),
            ),
    );
  }
}
