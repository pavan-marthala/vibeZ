import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:music/core/features/request_permission/bloc/request_permission_bloc.dart';
import 'package:music/core/routes/app_routes.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class RequestPermissionScreen extends StatelessWidget {
  const RequestPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RequestPermissionBloc, RequestPermissionState>(
      listener: (context, state) {
        if (state.allGranted) {
          context.go(AppRoutes.home);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.music_note,
                    size: 100,
                    color: Color(0xFF1ED760),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Welcome to vibeZ',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    Platform.isIOS
                        ? 'vibeZ needs access to your music library and notifications to work properly'
                        : 'We need some permissions to provide you the best music experience',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFFB3B3B3),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  BlocBuilder<RequestPermissionBloc, RequestPermissionState>(
                    builder: (context, state) {
                      return Column(
                        children: [
                          _PermissionItem(
                            icon: Icons.audiotrack,
                            title: Platform.isIOS
                                ? 'Music Library'
                                : 'Storage Access',
                            description: Platform.isIOS
                                ? 'Access your music library'
                                : 'Read and play your music files',
                            isGranted: state.isAudioGranted,
                          ),
                          const SizedBox(height: 16),
                          _PermissionItem(
                            icon: Icons.notifications,
                            title: 'Notifications',
                            description: 'Show playback controls',
                            isGranted: state.isNotificationGranted,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 48),
                  BlocBuilder<RequestPermissionBloc, RequestPermissionState>(
                    builder: (context, state) {
                      return Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: state.allGranted
                                  ? null
                                  : () {
                                      context.read<RequestPermissionBloc>().add(
                                        RequestPermission(),
                                      );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1ED760),
                                foregroundColor: Colors.black,
                                disabledBackgroundColor: const Color(0xFF282828),
                                disabledForegroundColor: const Color(0xFFB3B3B3),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              child: Text(
                                state.allGranted
                                    ? '✓ All Permissions Granted'
                                    : 'Grant Permissions',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          if (state.hasCheckedPermissions &&
                              !state.allGranted) ...[
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () async {
                                  await openAppSettings();
                                  // Wait a bit and then check permissions
                                  await Future.delayed(
                                    const Duration(milliseconds: 500),
                                  );
                                  if (context.mounted) {
                                    context.read<RequestPermissionBloc>().add(
                                      CheckPermissionStatus(),
                                    );
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF1ED760),
                                  side: const BorderSide(
                                    color: Color(0xFF1ED760),
                                    width: 2,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                child: const Text(
                                  'Open Settings',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              Platform.isIOS
                                  ? 'Open Settings → vibeZ → Enable Media & Apple Music and Notifications'
                                  : 'Open Settings to manually enable permissions',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6A6A6A),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PermissionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isGranted;

  const _PermissionItem({
    required this.icon,
    required this.title,
    required this.description,
    this.isGranted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF181818),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isGranted ? const Color(0xFF1ED760) : const Color(0xFF282828),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isGranted
                  ? const Color(0xFF1ED760).withValues(alpha: 0.2)
                  : const Color(0xFF282828),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isGranted
                  ? const Color(0xFF1ED760)
                  : const Color(0xFFB3B3B3),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (isGranted)
                      const Icon(
                        Icons.check_circle,
                        color: Color(0xFF1ED760),
                        size: 20,
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFB3B3B3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
