import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import '../config_zego.dart';

class LiveStreamWatchScreen extends StatelessWidget {
  final String liveID;
  final String userName;
  final String userId;

  const LiveStreamWatchScreen({
    super.key,
    required this.liveID,
    required this.userName,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Watch Live Stream')),
      body: SafeArea(
        child: ZegoUIKitPrebuiltLiveStreaming(
          appID: ConfigZego.appId,
          appSign: ConfigZego.appSign,
          userID: userId,
          userName: userName,
          liveID: liveID,
          config: ZegoUIKitPrebuiltLiveStreamingConfig.audience(),
        ),
      ),
    );
  }
}
