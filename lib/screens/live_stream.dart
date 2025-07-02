import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:app_streaming/config_zego.dart';

// import zego live stream
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class LiveStreamScreen extends StatefulWidget {
  final String liveID;
  final bool isHost;
  final String userName;
  final String userId;

  const LiveStreamScreen({
    super.key,
    required this.liveID,
    required this.isHost,
    required this.userName,
    required this.userId,
  });

  @override
  _LiveStreamScreenState createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends State<LiveStreamScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
        appID: ConfigZego
            .appId, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
        appSign: ConfigZego
            .appSign, // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
        userID: widget.userId,
        userName: widget.userName,
        liveID: widget.liveID,
        config: ZegoUIKitPrebuiltLiveStreamingConfig.host(),
      ),
    );
  }
}
