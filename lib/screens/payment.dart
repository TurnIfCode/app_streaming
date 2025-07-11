import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  File? _transferProof;
  final String bankName = 'Bank BCA';
  final String accountNumber = '123 456 7890';
  final String companyName = 'PT. Nama Perusahaan';
  final String totalAmount = 'Rp 235.125';
  final String paymentDeadline = 'Bayar sebelum 20.00 WIB';

  final ImagePicker _picker = ImagePicker();

  Future<void> _copyToClipboard(String text, String message) async {
    await Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _transferProof = File(pickedFile.path);
      });
    }
  }

  void _submitProof() {
    if (_transferProof == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan upload bukti transfer terlebih dahulu'),
        ),
      );
      return;
    }
    // Implement submission logic here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bukti transfer berhasil dikirim')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF3A8DFF);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
        backgroundColor: primaryColor,
        leading: const BackButton(),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final isTablet = screenWidth > 600;

          final horizontalPadding = isTablet ? screenWidth * 0.1 : 16.0;
          final cardPadding = isTablet ? 24.0 : 16.0;
          final buttonHeight = isTablet ? 56.0 : 48.0;
          final titleFontSize = isTablet ? 36.0 : 28.0;
          final subtitleFontSize = isTablet ? 20.0 : 16.0;
          final bankNameFontSize = isTablet ? 24.0 : 18.0;
          final accountNumberFontSize = isTablet ? 28.0 : 20.0;
          final companyNameFontSize = isTablet ? 20.0 : 16.0;
          final totalLabelFontSize = isTablet ? 24.0 : 18.0;
          final totalAmountFontSize = isTablet ? 32.0 : 24.0;
          final uploadLabelFontSize = isTablet ? 24.0 : 18.0;
          final deadlineFontSize = isTablet ? 18.0 : 14.0;
          final submitButtonFontSize = isTablet ? 22.0 : 18.0;

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pembayaran',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: isTablet ? 8 : 4),
                Text(
                  'Menunggu pembayaran',
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: isTablet ? 24 : 16),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.all(cardPadding),
                    child: Row(
                      children: [
                        // Bank logo placeholder
                        Container(
                          width: isTablet ? 56 : 40,
                          height: isTablet ? 56 : 40,
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'BCA',
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: isTablet ? 20 : 14,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: isTablet ? 20 : 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bankName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: bankNameFontSize,
                                ),
                              ),
                              SizedBox(height: isTablet ? 12 : 8),
                              Text(
                                accountNumber,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: accountNumberFontSize,
                                ),
                              ),
                              SizedBox(height: isTablet ? 6 : 4),
                              Text(
                                companyName,
                                style: TextStyle(fontSize: companyNameFontSize),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _copyToClipboard(
                            accountNumber,
                            'Nomor rekening disalin',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minimumSize: Size(
                              isTablet ? 140 : 100,
                              buttonHeight,
                            ),
                          ),
                          child: const Text(
                            'Salin Nomor\nRekening',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: isTablet ? 24 : 16),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.all(cardPadding),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Tagihan',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: totalLabelFontSize,
                                ),
                              ),
                              SizedBox(height: isTablet ? 12 : 8),
                              Text(
                                totalAmount,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: totalAmountFontSize,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () =>
                              _copyToClipboard(totalAmount, 'Jumlah disalin'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minimumSize: Size(
                              isTablet ? 140 : 100,
                              buttonHeight,
                            ),
                          ),
                          child: const Text('Salin Jumlah'),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: isTablet ? 24 : 16),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.all(cardPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upload Bukti Transfer',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: uploadLabelFontSize,
                          ),
                        ),
                        SizedBox(height: isTablet ? 16 : 12),
                        OutlinedButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.camera_alt_outlined),
                          label: const Text('Upload Foto'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(double.infinity, buttonHeight),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        if (_transferProof != null) ...[
                          SizedBox(height: isTablet ? 16 : 12),
                          Image.file(
                            _transferProof!,
                            height: isTablet ? 200 : 150,
                            fit: BoxFit.cover,
                          ),
                        ],
                        SizedBox(height: isTablet ? 12 : 8),
                        Text(
                          paymentDeadline,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: deadlineFontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: buttonHeight,
                  child: ElevatedButton(
                    onPressed: _submitProof,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Kirim Bukti',
                      style: TextStyle(
                        fontSize: submitButtonFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
