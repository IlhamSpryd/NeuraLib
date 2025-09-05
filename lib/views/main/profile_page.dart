import 'package:athena/preference/shared_preferences.dart';
import 'package:athena/views/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileBody extends StatefulWidget {
  const ProfileBody({super.key});

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  String? _userName;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final name = await SharedPreferencesHelper.getUserName();
    final email = await SharedPreferencesHelper.getUserEmail();
    setState(() {
      _userName = name ?? "Guest";
      _userEmail = email ?? "No email";
    });
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("$label berhasil disalin")));
  }

  @override
  Widget build(BuildContext context) {
    if (_userName == null || _userEmail == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // Custom AppBar dengan SafeArea
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 48), // space kiri
                const Text(
                  "Profile",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  icon: SizedBox(
                    width: 24,
                    height: 24,
                    child: Image.asset("assets/images/settings-sliders.png"),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.deepPurpleAccent,
                  child: Text(
                    _userName!.isNotEmpty ? _userName![0].toUpperCase() : "?",
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Nama & Email
                Text(
                  _userName!,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _userEmail!,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),

                // Tombol Edit Profil
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, "/edit_profile").then((
                      updated,
                    ) {
                      if (updated == true) _loadProfileData();
                    });
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit Profil"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Info Cards
                _buildInteractiveInfoCard(
                  "Nama",
                  _userName!,
                  icon: Icons.person,
                ),
                const SizedBox(height: 20),
                _buildInteractiveInfoCard(
                  "Email",
                  _userEmail!,
                  icon: Icons.email,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInteractiveInfoCard(
    String title,
    String value, {
    required IconData icon,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => _copyToClipboard(value, title),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurpleAccent.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.deepPurpleAccent, size: 30),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.copy, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}
