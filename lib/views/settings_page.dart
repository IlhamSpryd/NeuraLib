import 'package:athena/api/authentication_api.dart';
import 'package:athena/preference/shared_preferences.dart';
import 'package:athena/views/main/profile_page.dart';
import 'package:athena/widgets/slacktile.dart';
import 'package:athena/widgets/switchtile.dart';
import 'package:flutter/material.dart';

import '../widgets/section_card.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool darkMode = false;
  bool mobilePush = true;
  bool activityWorkspace = true;
  bool alwaysEmail = false;
  bool pageUpdates = true;
  bool workspaceDigest = true;
  int slackMode = 0;

  String? _userName;
  String? _userEmail;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadDarkModePreference();
  }

  Future<void> _loadUserProfile() async {
    try {
      final name = await SharedPreferencesHelper.getUserName();
      final email = await SharedPreferencesHelper.getUserEmail();

      setState(() {
        _userName = name;
        _userEmail = email;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = "Gagal memuat data user";
        _isLoading = false;
      });
    }
  }

  Future<void> _loadDarkModePreference() async {
    final isDark = await SharedPreferencesHelper.getDarkMode();
    setState(() {
      darkMode = isDark;
    });
  }

  Future<void> _toggleDarkMode(bool value) async {
    setState(() {
      darkMode = value;
    });
    await SharedPreferencesHelper.setDarkMode(value);
  }

  String get slackLabel {
    switch (slackMode) {
      case 1:
        return 'Mentions';
      case 2:
        return 'All';
      default:
        return 'Off';
    }
  }

  Future<void> _pickSlackMode() async {
    final result = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SlackOption(
                label: 'Off',
                selected: slackMode == 0,
                onTap: () => Navigator.pop(ctx, 0),
              ),
              SlackOption(
                label: 'Mentions',
                selected: slackMode == 1,
                onTap: () => Navigator.pop(ctx, 1),
              ),
              SlackOption(
                label: 'All',
                selected: slackMode == 2,
                onTap: () => Navigator.pop(ctx, 2),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
    if (result != null) {
      setState(() => slackMode = result);
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Apakah kamu yakin ingin keluar?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            child: const Text("Keluar", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await AuthApi.logout();
      await SharedPreferencesHelper.clearAll();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(body: Center(child: Text(_error!)));
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // Profile Section
          SectionCard(
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.deepPurpleAccent,
                  child: Text(
                    _userName != null && _userName!.isNotEmpty
                        ? _userName![0].toUpperCase()
                        : "?",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  _userName ?? "Guest",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(_userEmail ?? "noemail@example.com"),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileBody()),
                    ).then((_) => _loadUserProfile());
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // General Settings
          Text(
            'General Settings',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          SectionCard(
            children: [
              SwitchTile(
                title: 'Dark Mode',
                subtitle: 'Use dark theme for the app',
                value: darkMode,
                onChanged: _toggleDarkMode,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Notifications Section
          Text(
            'Notifications',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          SectionCard(
            children: [
              SwitchTile(
                title: 'Mobile push notifications',
                subtitle:
                    'Receive push notifications on mentions and comments via your mobile app',
                value: mobilePush,
                onChanged: (v) => setState(() => mobilePush = v),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Logout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout_sharp, color: Colors.white),
              label: const Text(
                "Keluar",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
