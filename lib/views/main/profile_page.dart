import 'dart:io';

import 'package:athena/api/book_api.dart';
import 'package:athena/api/user_api.dart';
import 'package:athena/models/history_book.dart';
import 'package:athena/models/user_models.dart';
import 'package:athena/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _userName = "Pengguna";
  String _userEmail = "-";
  int _borrowedBooksCount = 0;
  int _historyCount = 0;
  bool _isLoading = true;
  File? _avatarImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final UserModel? userData = await UserApi.getProfile();
      final Historybook borrows = await BookApi.getMyBorrows();

      if (userData != null) {
        final name = userData.data.user.name;
        final email = userData.data.user.email;
        final userId = userData.data.user.id;

        final borrowCount = borrows.data != null
            ? borrows.data!.where((borrow) => borrow.returnDate == null).length
            : 0;

        final historyCount = borrows.data != null
            ? borrows.data!.where((borrow) => borrow.returnDate != null).length
            : 0;

        await SharedPreferencesHelper.saveUser(
          id: userId,
          name: name,
          email: email,
        );

        if (!mounted) return;
        setState(() {
          _userName = name;
          _userEmail = email;
          _borrowedBooksCount = borrowCount;
          _historyCount = historyCount;
          _isLoading = false;
        });
      } else {
        _loadFromSharedPreferences();
      }
    } catch (e) {
      print("Error loading profile: $e");
      _loadFromSharedPreferences();
    }
  }

  Future<void> _loadFromSharedPreferences() async {
    final name = await SharedPreferencesHelper.getUserName() ?? "Pengguna";
    final email = await SharedPreferencesHelper.getUserEmail() ?? "-";

    if (!mounted) return;
    setState(() {
      _userName = name;
      _userEmail = email;
      _borrowedBooksCount = 0;
      _historyCount = 0;
      _isLoading = false;
    });
  }

  Future<void> _pickAvatar() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 300,
        maxHeight: 300,
        imageQuality: 80,
      );

      if (pickedFile != null && mounted) {
        setState(() => _avatarImage = File(pickedFile.path));
      }
    } catch (e) {
      print("Error picking avatar: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memilih gambar: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _refreshProfile() async {
    setState(() => _isLoading = true);
    await _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Memuat profil...",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshProfile,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProfile,
        color: Theme.of(context).primaryColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Profile Avatar
              Center(
                child: GestureDetector(
                  onTap: _pickAvatar,
                  child: Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 3,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: _avatarImage != null
                              ? FileImage(_avatarImage!)
                              : null,
                          backgroundColor: Colors.grey[200],
                          child: _avatarImage == null
                              ? Text(
                                  _userName.isNotEmpty
                                      ? _userName[0].toUpperCase()
                                      : "?",
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // User Name
              Text(
                _userName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              // User Email
              Text(
                _userEmail,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),
              // Stats Card
              _buildStatsCard(),
              const SizedBox(height: 24),
              // Action Buttons
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Statistik",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  icon: Icons.book,
                  label: "Dipinjam",
                  value: _borrowedBooksCount.toString(),
                ),
                _buildStatItem(
                  icon: Icons.history,
                  label: "Riwayat",
                  value: _historyCount.toString(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 30, color: Theme.of(context).primaryColor),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.edit, color: Theme.of(context).primaryColor),
            title: Text("Edit Profil", style: TextStyle(color: Colors.white)),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
            onTap: () {
              _showEditProfileDialog();
            },
          ),
          Divider(color: Colors.white, height: 1),
          ListTile(
            leading: Icon(Icons.history, color: Theme.of(context).primaryColor),
            title: Text(
              "Riwayat Peminjaman",
              style: TextStyle(color: Colors.white),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.white,
            ),
            onTap: () {},
          ),
          Divider(color: Colors.grey[200], height: 1),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("Keluar", style: TextStyle(color: Colors.red)),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
            onTap: () {
              _showLogoutDialog();
            },
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _userName);
    final emailController = TextEditingController(text: _userEmail);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Edit Profil",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Nama",
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                style: TextStyle(color: Colors.grey[800]),
              ),
              SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.grey[800]),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[600],
                    ),
                    child: Text("Batal"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final newName = nameController.text;
                      final newEmail = emailController.text;

                      if (newName.isNotEmpty && newEmail.isNotEmpty) {
                        try {
                          final updatedUser = await UserApi.updateProfile(
                            name: newName,
                            email: newEmail,
                          );

                          if (updatedUser != null) {
                            setState(() {
                              _userName = newName;
                              _userEmail = newEmail;
                            });

                            await SharedPreferencesHelper.saveUser(
                              id: updatedUser.data.user.id,
                              name: newName,
                              email: newEmail,
                            );

                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Profil berhasil diperbarui'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Gagal memperbarui profil: $e'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: Text("Simpan"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.logout, size: 48, color: Colors.red),
              SizedBox(height: 16),
              Text(
                "Konfirmasi Keluar",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Apakah Anda yakin ingin keluar?",
                style: TextStyle(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[600],
                    ),
                    child: Text("Batal"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await SharedPreferencesHelper.clearUser();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: Text("Keluar"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
