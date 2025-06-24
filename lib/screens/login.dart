import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/api_service.dart';
import 'main_home.dart';
import 'register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _userInput = '';
  String _password = '';
  bool _loading = false;
  final ApiService _apiService = ApiService();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });
      try {
        await _apiService.login(_userInput);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainHomeScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal masuk: $e')));
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  void _loginWithGoogle() async {
    setState(() {
      _loading = true;
    });
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        // You can add additional authentication logic here if needed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainHomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Login Google dibatalkan')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal login dengan Google: $e')));
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width > 600;

    return Scaffold(
      appBar: AppBar(title: Text('Masuk Akun')),
      body: Center(
        child: Container(
          width: isTablet ? 400 : double.infinity,
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Telepon atau Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mohon masukkan telepon atau email';
                    }
                    if (!RegExp(
                          r'^[\w\.\-]+@[\w\-]+\.[a-zA-Z]{2,4}$',
                        ).hasMatch(value) &&
                        !RegExp(r'^\+?[0-9]{7,15}$').hasMatch(value)) {
                      return 'Masukkan nomor telepon atau email yang valid';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _userInput = value;
                    });
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mohon masukkan password';
                    }
                    if (value.length < 8) {
                      return 'Password minimal 8 karakter';
                    }
                    if (!RegExp(r'^(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
                      return 'Password harus mengandung huruf kapital dan angka';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: _loading
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          )
                        : Text('Masuk'),
                  ),
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Image.asset(
                      'assets/google_logo.png',
                      height: 24,
                      width: 24,
                    ),
                    label: Text('Masuk dengan Google'),
                    onPressed: _loading ? null : _loginWithGoogle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      side: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Belum punya akun?',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    child: Text('Daftar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
