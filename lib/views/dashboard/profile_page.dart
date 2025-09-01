import 'package:athena/preference/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:athena/api/authentication_api.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _userName;
  String? _userEmail;
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final name = await SharedPreferencesHelper.getUserName();
    final email = await SharedPreferencesHelper.getUserEmail();
    final token = await AuthenticationAPI.getToken();

    setState(() {
      _userName = name ?? "Guest";
      _userEmail = email ?? "No email";
      _token = token ?? "";
    });
  }

  Future<void> _logout() async {
    await AuthenticationAPI.logout();
    await SharedPreferencesHelper.clearAll();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, "/login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: _userName == null || _userEmail == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      _userName!.isNotEmpty ? _userName![0].toUpperCase() : "?",
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _userName!,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _userEmail!,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),
                  ListTile(
                    leading: const Icon(Icons.vpn_key),
                    title: const Text("Token"),
                    subtitle: Text(_token ?? ""),
                  ),
                  // Bisa ditambah menu lain seperti edit profile, settings, dll
                ],
              ),
            ),
    );
  }
}
