import 'package:athena/api/authentication_api.dart';
import 'package:athena/preference/shared_preferences.dart';
import 'package:athena/views/main/profile_page.dart';
import 'package:athena/widgets/switchtile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/section_card.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool darkMode = false;
  bool mobilePush = true;
  int slackMode = 0;

  String? _userName;
  String? _userEmail;
  bool _isLoading = true;
  String? _error;
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _loadUserProfile();
    _loadDarkModePreference();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    try {
      final name = await SharedPreferencesHelper.getUserName();
      final email = await SharedPreferencesHelper.getUserEmail();

      if (_isMounted) {
        setState(() {
          _userName = name;
          _userEmail = email;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (_isMounted) {
        setState(() {
          _error = "Gagal memuat data user";
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadDarkModePreference() async {
    final isDark = await SharedPreferencesHelper.getDarkMode();
    if (_isMounted) {
      setState(() {
        darkMode = isDark;
      });
    }
  }

  Future<void> _toggleDarkMode(bool value) async {
    if (_isMounted) {
      setState(() {
        darkMode = value;
      });
    }
    await SharedPreferencesHelper.setDarkMode(value);
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          "Konfirmasi",
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Apakah kamu yakin ingin keluar?",
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text("Batal", style: GoogleFonts.inter()),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            child: Text(
              "Keluar",
              style: GoogleFonts.inter(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await AuthApi.logout();
      await SharedPreferencesHelper.clearAll();
      if (_isMounted && context.mounted) {
        Navigator.pushReplacementNamed(context, "/login");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: primaryColor)),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(child: Text(_error!, style: GoogleFonts.inter())),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Settings',
          style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
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
                  backgroundColor: primaryColor,
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
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  _userEmail ?? "noemail@example.com",
                  style: GoogleFonts.inter(),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.edit, color: primaryColor),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileBody()),
                    ).then((_) {
                      if (_isMounted) {
                        _loadUserProfile();
                      }
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // General Settings
          Text(
            'General Settings',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 18,
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
            style: GoogleFonts.spaceGrotesk(
              fontSize: 18,
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
                onChanged: (v) {
                  if (_isMounted) {
                    setState(() => mobilePush = v);
                  }
                },
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
              label: Text(
                "Keluar",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
