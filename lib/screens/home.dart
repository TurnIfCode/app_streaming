import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/models.dart';
import 'live_stream.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  late List<Host> hosts;

  @override
  void initState() {
    super.initState();
    hosts = _apiService.getHosts();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width > 600;

    return Scaffold(
      appBar: AppBar(title: Text('Live Hosts')),
      body: Center(
        child: SizedBox(
          width: isTablet ? 600 : double.infinity,
          child: ListView.builder(
            itemCount: hosts.length,
            itemBuilder: (context, index) {
              final host = hosts[index];
              return ListTile(
                leading: CircleAvatar(child: Text(host.name[0])),
                title: Text(host.name),
                subtitle: Text(host.description),
                trailing: Icon(Icons.videocam),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LiveStreamScreen(
                        hostId: host.id,
                        hostName: host.name,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
