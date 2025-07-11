import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

import 'package:app_streaming/config_zego.dart';

class LiveStreamWatchScreen extends StatelessWidget {
  final String liveID;
  final String userName;
  final String userId;

  const LiveStreamWatchScreen({
    Key? key,
    required this.liveID,
    required this.userName,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
        appID: ConfigZego
            .appId, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
        appSign: ConfigZego
            .appSign, // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
        userID: userId,
        userName: userName,
        liveID: liveID,
        config: ZegoUIKitPrebuiltLiveStreamingConfig.audience(),
      ),
    );
  }
}
