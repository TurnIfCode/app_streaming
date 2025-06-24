import 'package:flutter/material.dart';
import 'home.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  String _otpCode = '';
  bool _loading = false;

  void _submitOtp() {
    if (_formKey.currentState!.validate()) {
      // Implement OTP verification logic here
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Kode OTP berhasil diverifikasi')));
      // Navigate to Home screen after successful OTP verification
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width > 600;

    return Scaffold(
      appBar: AppBar(title: Text('Verifikasi OTP')),
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
                    labelText: 'Kode OTP',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mohon masukkan kode OTP';
                    }
                    if (value.length != 6) {
                      return 'Kode OTP harus 6 digit';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _otpCode = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _submitOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child: _loading
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          )
                        : Text('Verifikasi'),
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
