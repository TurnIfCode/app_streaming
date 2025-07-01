import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dompet'), leading: BackButton()),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tabs: Only "Koin" tab, no Beans tab
            Row(
              children: [
                Text(
                  'Koin',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.orange,
                    decorationThickness: 3,
                  ),
                ),
                SizedBox(width: 16),
                // Beans tab removed
              ],
            ),
            SizedBox(height: 16),
            // Balance card with plain Koin (coin) icon and text, no dollar logo
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade200, Colors.orange.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.monetization_on, size: 40, color: Colors.white),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '0',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Saldo rekening >',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Removed card below balance (not included)
            // Google Wallet card with top-up options, no "Google Wallet" text, coin icon instead of diamond icon
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildTopUpOption(2, 'IDR 1,000'),
                  _buildTopUpOption(40, 'IDR 19,000'),
                  _buildTopUpOption(284, 'IDR 132,900', isBigDeal: true),
                  _buildTopUpOption(815, 'IDR 380,000'),
                  _buildTopUpOption(3715, 'IDR 1,710,000'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopUpOption(int coins, String price, {bool isBigDeal = false}) {
    return Container(
      width: 100,
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Plain coin icon only, no dollar logo
              Icon(Icons.monetization_on, color: Colors.orange, size: 16),
              SizedBox(width: 4),
              Text(
                coins.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              if (isBigDeal)
                Container(
                  margin: EdgeInsets.only(left: 6),
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'BIG DEAL',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            price,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              decoration: isBigDeal ? TextDecoration.lineThrough : null,
            ),
          ),
          if (isBigDeal)
            Text(
              'IDR 132,900',
              style: TextStyle(
                fontSize: 12,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}
