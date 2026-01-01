import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music/core/routes/app_routes.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text('Manage Music Folders'),
              onTap: () {
                context.push(AppRoutes.folderSelection);
              },
            ),
          ],
        ),
      ),
    );
  }
}
