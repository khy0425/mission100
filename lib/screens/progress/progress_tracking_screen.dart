import 'package:flutter/material.dart';
import '../../models/user_profile.dart';

/// Stub screen for backward compatibility
/// This screen is deprecated - use ProgressScreen instead
class ProgressTrackingScreen extends StatelessWidget {
  final UserProfile userProfile;

  const ProgressTrackingScreen({
    super.key,
    required this.userProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
      ),
      body: const Center(
        child: Text('This screen is deprecated. Please use the new Progress screen.'),
      ),
    );
  }
}
