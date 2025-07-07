import 'package:flutter/material.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  int? selectedCoinIndex;

  final List<Map<String, dynamic>> coinOptions = [
    {'coins': 2, 'price': 'IDR 1,000', 'isBigDeal': false},
    {'coins': 40, 'price': 'IDR 19,000', 'isBigDeal': false},
    {
      'coins': 284,
      'price': 'IDR 132,900',
      'isBigDeal': true,
      'originalPrice': 'IDR 132,900',
    },
    {'coins': 815, 'price': 'IDR 380,000', 'isBigDeal': false},
    {'coins': 3715, 'price': 'IDR 1,710,000', 'isBigDeal': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dompet'), leading: const BackButton()),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tabs: Only "Koin" tab, no Beans tab
            // Removed the Row containing "Koin" text as per user request
            const SizedBox(height: 16),
            // Balance card with blue gradient and dollar icon
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3A8DFF), Color(0xFF1C6BFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: const [
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
                        'Saldo rekening',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Coin options container with light gray background
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(coinOptions.length, (index) {
                  final option = coinOptions[index];
                  final isSelected = selectedCoinIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCoinIndex = index;
                      });
                    },
                    child: _buildTopUpOption(
                      option['coins'],
                      option['price'],
                      isBigDeal: option['isBigDeal'],
                      isSelected: isSelected,
                      originalPrice: option['originalPrice'],
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 24),
            // Bayar button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: selectedCoinIndex != null
                    ? () {
                        // Implement payment logic here
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3A8DFF),
                  disabledBackgroundColor: Colors.grey.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Bayar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: selectedCoinIndex != null
                        ? Colors.white
                        : Colors.grey.shade700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopUpOption(
    int coins,
    String price, {
    bool isBigDeal = false,
    bool isSelected = false,
    String? originalPrice,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF3A8DFF) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? const Color(0xFF3A8DFF) : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.monetization_on,
                color: isSelected ? Colors.white : Color(0xFF3A8DFF),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                coins.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Color(0xFF3A8DFF),
                ),
              ),
              if (isBigDeal)
                Container(
                  margin: const EdgeInsets.only(left: 4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'BIG DEAL',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 6,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            price,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white70 : Colors.grey.shade600,
              decoration: isBigDeal ? TextDecoration.lineThrough : null,
            ),
          ),
          if (isBigDeal)
            Text(
              originalPrice ?? '',
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}
