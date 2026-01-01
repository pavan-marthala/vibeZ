import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:music/core/features/request_permission/bloc/request_permission_bloc.dart';
import 'package:music/core/routes/app_routes.dart';
import 'package:permission_handler/permission_handler.dart';

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
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.music_note,
                  size: 100,
                  color: Colors.deepPurple,
                ),
                const SizedBox(height: 32),
                const Text(
                  'Welcome to vibeZ',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'We need some permissions to provide you the best music experience',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                BlocBuilder<RequestPermissionBloc, RequestPermissionState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        _PermissionItem(
                          icon: Icons.audiotrack,
                          title: 'Music Library Access',
                          description: 'To read and play your music files',
                          isGranted: state.isAudioGranted,
                        ),
                        const SizedBox(height: 16),
                        _PermissionItem(
                          icon: Icons.notifications,
                          title: 'Notifications',
                          description: 'To show playback controls and updates',
                          isGranted: state.isNotificationGranted,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 48),
                BlocBuilder<RequestPermissionBloc, RequestPermissionState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!state.allGranted) {
                            context.read<RequestPermissionBloc>().add(
                              RequestPermission(),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          state.allGranted
                              ? 'All Permissions Granted'
                              : 'Grant Permissions',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                BlocBuilder<RequestPermissionBloc, RequestPermissionState>(
                  builder: (context, state) {
                    // Show "Open Settings" button if permissions were permanently denied
                    if (state.hasCheckedPermissions && !state.allGranted) {
                      return TextButton(
                        onPressed: () async {
                          await openAppSettings();
                          // Check permissions again when user returns from settings
                          if (context.mounted) {
                            context.read<RequestPermissionBloc>().add(
                              CheckPermissionStatus(),
                            );
                          }
                        },
                        child: const Text(
                          'Open Settings',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
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
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isGranted
                ? Colors.green.withOpacity(0.1)
                : Colors.deepPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isGranted ? Colors.green : Colors.deepPurple,
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
                      ),
                    ),
                  ),
                  if (isGranted)
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 20,
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
