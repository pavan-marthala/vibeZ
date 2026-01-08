import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music/core/database/database_helper.dart';
import 'package:music/core/features/shared/bloc/music_library/music_library_bloc.dart';
import 'package:music/core/routes/app_routes.dart';
import 'package:music/core/theme/app_theme.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _appVersion = '${packageInfo.version} (${packageInfo.buildNumber})';
      });
    } catch (e) {
      // Ignore if fails
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: colors.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionHeader(context, 'Media'),
            _buildSettingTile(
              context,
              icon: Icons.folder,
              title: 'Manage Music Folders',
              subtitle: 'Select folders to scan for music',
              onTap: () {
                context.goNamed(AppRoutes.folderSelection);
              },
            ),
            const Divider(height: 32),
            _buildSectionHeader(context, 'Data & Storage'),
            _buildSettingTile(
              context,
              icon: Icons.refresh,
              title: 'Rescan Library',
              subtitle: 'Refresh music library to find new songs',
              onTap: () {
                context.read<MusicLibraryBloc>().add(LoadAudioFiles());
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Scanning library...')),
                );
              },
            ),
            _buildSettingTile(
              context,
              icon: Icons.delete_outline,
              title: 'Clear Playback History',
              subtitle: 'Remove all listening stats and history',
              onTap: () => _showClearHistoryDialog(context),
              isDestructive: true,
            ),
             const Divider(height: 32),
            _buildSectionHeader(context, 'About'),
            _buildSettingTile(
              context,
              icon: Icons.info_outline,
              title: 'Version',
              subtitle: _appVersion.isNotEmpty ? _appVersion : '1.0.0',
              onTap: null, // Just info
            ),
            _buildSettingTile(
              context,
              icon: Icons.code,
              title: 'Source Code',
              subtitle: 'View on GitHub',
              onTap: () async {
                 final Uri url = Uri.parse('https://github.com/pavankalyanmarthala/vibeZ'); // Replace with actual repo if known
                 if (!await launchUrl(url)) {
                   // ignore
                 }
              },
            ),
            const SizedBox(height: 100), // Bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: context.theme.appTypography.labelSmall.copyWith(
          color: context.theme.appColors.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    final colors = context.theme.appColors;
    
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (isDestructive ? colors.error : colors.primary).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon, 
          color: isDestructive ? colors.error : colors.primary,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: context.theme.appTypography.bodyLarge.copyWith(
          color: isDestructive ? colors.error : colors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: context.theme.appTypography.bodySmall.copyWith(
                color: colors.textSecondary,
              ),
            )
          : null,
      onTap: onTap,
      trailing: onTap != null ? Icon(Icons.chevron_right, color: colors.textSecondary) : null,
    );
  }

  Future<void> _showClearHistoryDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear History?'),
          content: const Text(
            'This will permanently delete all your playback history and stats. This action cannot be undone.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Clear', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                await DatabaseHelper.instance.clearAllHistory();
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('History cleared')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
