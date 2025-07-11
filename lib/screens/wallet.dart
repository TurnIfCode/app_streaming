import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';
import 'payment.dart'; // Import PaymentScreen

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  int? selectedCoinIndex;
  List<Coin> coins = [];
  Wallet? wallet;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
    // Set default selectedCoinIndex to 0 to show the Bayar button enabled
    selectedCoinIndex = 0;
  }

  Future<void> _fetchData() async {
    try {
      final userId = await ApiService().getUserId();
      final token = await ApiService().getToken();
      if (userId == null || token == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }
      final results = await Future.wait([
        ApiService().fetchCoins(),
        ApiService().fetchWallet(userId, token),
      ]);
      final fetchedCoins = results[0] as List<Coin>;
      final fetchedWalletResponse = results[1] as Map<String, dynamic>;
      setState(() {
        coins = fetchedCoins;
        wallet = Wallet.fromJson(fetchedWalletResponse['data']);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Optionally handle error, e.g., show a snackbar
    }
  }

  String _formatPrice(int price) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'IDR ',
      decimalDigits: 0,
    );
    return formatter.format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dompet'), leading: const BackButton()),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
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
                      children: [
                        const Icon(
                          Icons.monetization_on,
                          size: 40,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              wallet != null
                                  ? _formatPrice(wallet!.amount)
                                  : '0',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Saldo rekening',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
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
                      children: List.generate(coins.length, (index) {
                        final coin = coins[index];
                        final isSelected = selectedCoinIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCoinIndex = index;
                            });
                          },
                          child: _buildTopUpOption(
                            coin.coinAmount,
                            _formatPrice(coin.price),
                            isBigDeal: coin.isBigDeal == 1,
                            isSelected: isSelected,
                            originalPrice: coin.isBigDeal == 1
                                ? _formatPrice(coin.finalPrice)
                                : null,
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: selectedCoinIndex != null
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PaymentScreen(),
                                ),
                              );
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
