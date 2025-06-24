import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> topStreamers = [
    {'name': 'Host A', 'giftsReceived': 500},
    {'name': 'Host B', 'giftsReceived': 300},
    {'name': 'Host C', 'giftsReceived': 200},
  ];

  final List<Map<String, dynamic>> topGifters = [
    {'name': 'User X', 'giftsSent': 400},
    {'name': 'User Y', 'giftsSent': 350},
    {'name': 'User Z', 'giftsSent': 250},
  ];

  LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Leaderboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Top Streamers',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: topStreamers.length,
              itemBuilder: (context, index) {
                final streamer = topStreamers[index];
                return ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(streamer['name']),
                  trailing: Text('${streamer['giftsReceived']} gifts'),
                );
              },
            ),
            Divider(),
            Text('Top Gifters', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: topGifters.length,
              itemBuilder: (context, index) {
                final gifter = topGifters[index];
                return ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(gifter['name']),
                  trailing: Text('${gifter['giftsSent']} gifts'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
