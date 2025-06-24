import 'package:flutter/material.dart';

class HostProfileScreen extends StatelessWidget {
  final String hostName;
  final int totalGifts;
  final int totalCoins;

  const HostProfileScreen({
    super.key,
    required this.hostName,
    this.totalGifts = 0,
    this.totalCoins = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Host Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(hostName, style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.card_giftcard),
              title: Text('Total Gifts Received'),
              trailing: Text('$totalGifts'),
            ),
            ListTile(
              leading: Icon(Icons.monetization_on),
              title: Text('Total Coins Earned'),
              trailing: Text('$totalCoins'),
            ),
          ],
        ),
      ),
    );
  }
}
