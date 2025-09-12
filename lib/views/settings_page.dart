import 'package:athena/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeNotifier;

  const SettingsPage({super.key, required this.themeNotifier});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkMode = false;
  bool _notifications = true;

  @override
  void initState() {
    super.initState();
    _loadDarkMode();
  }

  Future<void> _loadDarkMode() async {
    final isDark = await SharedPreferencesHelper.getDarkMode();
    if (mounted) {
      setState(() => _darkMode = isDark);
    }
  }

  Future<void> _toggleDarkMode(bool value) async {
    setState(() => _darkMode = value);
    await SharedPreferencesHelper.setDarkMode(value);
    widget.themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings", style: GoogleFonts.spaceGrotesk()),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/dashboard', // bisa diganti ke '/profile' kalau mau
              (route) => false,
            );
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: Text("Dark Mode", style: GoogleFonts.inter(fontSize: 16)),
            subtitle: Text(
              "Use dark theme across the app",
              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
            ),
            value: _darkMode,
            onChanged: _toggleDarkMode,
          ),
          SwitchListTile(
            title: Text(
              "Notifications",
              style: GoogleFonts.inter(fontSize: 16),
            ),
            subtitle: Text(
              "Receive app notifications",
              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
            ),
            value: _notifications,
            onChanged: (value) {
              setState(() => _notifications = value);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text("Account", style: GoogleFonts.inter(fontSize: 16)),
            subtitle: Text(
              "Manage your profile",
              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/edit_profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text("Language", style: GoogleFonts.inter(fontSize: 16)),
            subtitle: Text(
              "Change app language",
              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
            ),
            onTap: () {
              // nanti bisa ditambahin dialog pilih bahasa
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text("About", style: GoogleFonts.inter(fontSize: 16)),
            subtitle: Text(
              "App version 1.0.0",
              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
            ),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "NeuraLib",
                applicationVersion: "1.0.0",
                applicationIcon: const Icon(Icons.book_outlined),
                children: [
                  Text(
                    "A modern digital library app built with Flutter.",
                    style: GoogleFonts.inter(fontSize: 14),
                  ),
                ],
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: Colors.red),
            title: Text(
              "Logout",
              style: GoogleFonts.inter(fontSize: 16, color: Colors.red),
            ),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
