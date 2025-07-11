import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

import 'package:app_streaming/config_zego.dart';

import 'package:uuid/uuid.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:app_streaming/services/api_service.dart';
import 'login.dart';

class LiveStreamScreen extends StatefulWidget {
  final bool isHost;
  final String userName;
  final String userId;
  final VoidCallback? onLiveStreamStarted;
  final VoidCallback? onLiveStreamEnded;

  const LiveStreamScreen({
    Key? key,
    required this.isHost,
    required this.userName,
    required this.userId,
    this.onLiveStreamStarted,
    this.onLiveStreamEnded,
  }) : super(key: key);

  @override
  State<LiveStreamScreen> createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends State<LiveStreamScreen> {
  late final String liveID;
  bool _hasStartedLiveStream = false;

  @override
  void initState() {
    super.initState();
    liveID = const Uuid().v4();
    requestPermissions();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    final statuses = await [Permission.camera, Permission.microphone].request();

    bool cameraDenied = statuses[Permission.camera] != PermissionStatus.granted;
    bool micDenied =
        statuses[Permission.microphone] != PermissionStatus.granted;

    if (cameraDenied || micDenied) {
      bool cameraPermanentlyDenied =
          await Permission.camera.isPermanentlyDenied;
      bool micPermanentlyDenied =
          await Permission.microphone.isPermanentlyDenied;

      if (cameraPermanentlyDenied || micPermanentlyDenied) {
        // Show dialog to open app settings
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Permission Required'),
            content: Text(
              'Camera and microphone permissions are permanently denied. Please enable them in system settings.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  openAppSettings();
                  Navigator.of(context).pop();
                },
                child: Text('Settings'),
              ),
            ],
          ),
        );
      } else {
        // Show snackbar for normal denial
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Camera and microphone permissions are required to start live streaming.',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ZegoUIKitPrebuiltLiveStreaming(
          appID: ConfigZego
              .appId, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
          appSign: ConfigZego
              .appSign, // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
          userID: widget.userId,
          userName: widget.userName,
          liveID: liveID,
          events: ZegoUIKitPrebuiltLiveStreamingEvents(
            onStateUpdated: (state) async {
              if (_hasStartedLiveStream) return;
              _hasStartedLiveStream = true;
              try {
                final result = await ApiService().startLiveStream(liveID);
                if (result['success'] != true) {
                  if (mounted) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  }
                } else {
                  SystemChrome.setEnabledSystemUIMode(
                    SystemUiMode.immersiveSticky,
                  );
                  if (widget.onLiveStreamStarted != null) {
                    widget.onLiveStreamStarted!();
                  }
                }
              } catch (e) {
                if (mounted) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                }
              }
            },
          ),
          config: ZegoUIKitPrebuiltLiveStreamingConfig.host()
            ..turnOnMicrophoneWhenJoining = true
            ..turnOnCameraWhenJoining = true
            ..confirmDialogInfo = ZegoLiveStreamingDialogInfo(
              title: "Apakah anda yakin?",
              message: "Ingin menghentikan live?",
              cancelButtonName: "Batal",
              confirmButtonName: "Berhenti",
            ),
        ),
      ),
    );
  }
}
