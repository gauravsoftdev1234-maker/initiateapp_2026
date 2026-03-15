import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:initiateapp_2026app_2026/view/starting_screens/splash/SplashScreen.dart';

import 'PermissionScreen.dart';
class PermissionGate extends StatefulWidget {
  const PermissionGate({super.key});

  @override
  State<PermissionGate> createState() => _PermissionGateState();
}

class _PermissionGateState extends State<PermissionGate> {

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final location = await Permission.location.status;
    final notification = await Permission.notification.status;

    if (location.isGranted && notification.isGranted) {
      _goToSplash();
    } else {
      _goToPermission();
    }
  }

  void _goToSplash() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SplashScreen()),
    );
  }

  void _goToPermission() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const PermissionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}