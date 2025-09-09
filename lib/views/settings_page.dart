import 'package:athena/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeNotifier; // ✅ terima dari main.dart

  const SettingsPage({super.key, required this.themeNotifier});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkMode = false;

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

    // ✅ update global theme
    widget.themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings", style: GoogleFonts.spaceGrotesk()),
        backgroundColor: theme.colorScheme.surface,
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
        ],
      ),
    );
  }
}
