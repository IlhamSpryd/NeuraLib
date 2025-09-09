import 'dart:ui';

import 'package:athena/api/authentication_api.dart';
import 'package:athena/api/user_api.dart';
import 'package:athena/models/user_models.dart';
import 'package:athena/preference/shared_preferences.dart';
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
  UserModel? _userData;
  bool _isLoading = true;
  final Map<String, dynamic> _currentBook = {
    'title': 'Seni Menikmati Hidup',
    'author': 'James Clear',
    'progress': 65,
    'cover': null,
  };

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final userData = await UserApi.getProfile();
      if (userData != null) {
        setState(() {
          _userData = userData;
          _userName = userData.data.user.name;
          _userEmail = userData.data.user.email;
          _isLoading = false;
        });

        await SharedPreferencesHelper.saveUser(
          id: userData.data.user.id,
          name: userData.data.user.name,
          email: userData.data.user.email,
        );
      }
    } catch (e) {
      print("Error loading profile: $e");
      final name = await SharedPreferencesHelper.getUserName();
      final email = await SharedPreferencesHelper.getUserEmail();
      setState(() {
        _userName = name ?? "Pengguna";
        _userEmail = email ?? "Email tidak tersedia";
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "Konfirmasi Logout",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                Divider(height: 1, color: Colors.grey[200]),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "Apakah Anda yakin ingin keluar?",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ),
                Divider(height: 1, color: Colors.grey[200]),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                              ),
                            ),
                          ),
                          child: Text(
                            "Batal",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      VerticalDivider(width: 1, color: Colors.grey[200]),
                      Expanded(
                        child: TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            try {
                              await AuthApi.logout();
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/login',
                                (route) => false,
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Logout gagal: ${e.toString()}",
                                  ),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                            }
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                          ),
                          child: Text(
                            "Keluar",
                            style: TextStyle(
                              color: Colors.red[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$label berhasil disalin"),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey[700],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildGlassCard({required Widget child, EdgeInsets? margin}) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.8), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: child,
        ),
      ),
    );
  }

  Widget _buildMenuTile(String title, {IconData? icon, VoidCallback? onTap}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: icon != null
          ? Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.deepPurple, size: 20),
            )
          : null,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          color: Colors.grey[800],
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: Colors.grey[400],
        size: 22,
      ),
      onTap: onTap,
      minLeadingWidth: 20,
    );
  }

  Widget _buildCurrentBookSection() {
    return _buildGlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sedang Dibaca",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 50,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[50],
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.menu_book_rounded,
                    color: Colors.deepPurple[300],
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentBook['title'],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _currentBook['author'],
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: _currentBook['progress'] / 100,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.deepPurple,
                        ),
                        borderRadius: BorderRadius.circular(4),
                        minHeight: 6,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_currentBook['progress']}% selesai',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  // Aksi lanjut membaca
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.deepPurple.withOpacity(0.1),
                  foregroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Lanjutkan Membaca",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.only(
        top: 70,
        bottom: 30,
      ), // Diperbesar padding topnya
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.deepPurple.shade100, Colors.deepPurple.shade50],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // Avatar dengan efek glassmorphism - dipindahkan ke bawah
          const SizedBox(height: 20), // Tambahan space di atas avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.9),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      _userName!.isNotEmpty ? _userName![0].toUpperCase() : "?",
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20), // Diperbesar jaraknya
          // Nama pengguna
          Text(
            _userName!,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8), // Diperbesar jaraknya
          // Email dengan tombol salin
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    _userEmail!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _copyToClipboard(_userEmail!, "Email"),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.copy_rounded,
                      color: Colors.deepPurple,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: Center(
          child: SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Profil Saya",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),

            // Buku yang sedang dibaca
            _buildSectionTitle("Aktivitas Membaca"),
            _buildCurrentBookSection(),

            // Akun Section
            _buildSectionTitle("Pengaturan Akun"),
            _buildGlassCard(
              child: Column(
                children: [
                  _buildMenuTile("Transaksi", icon: Icons.receipt_rounded),
                  const Divider(height: 1, indent: 20, endIndent: 20),
                  _buildMenuTile(
                    "Wishlist",
                    icon: Icons.favorite_border_rounded,
                  ),
                  const Divider(height: 1, indent: 20, endIndent: 20),
                  _buildMenuTile(
                    "Paket Langganan",
                    icon: Icons.card_membership_rounded,
                  ),
                  const Divider(height: 1, indent: 20, endIndent: 20),
                  _buildMenuTile("Ubah Kata Sandi", icon: Icons.lock_rounded),
                  const Divider(height: 1, indent: 20, endIndent: 20),
                  _buildMenuTile(
                    "Aktivasi Kode Kupon",
                    icon: Icons.local_offer_rounded,
                  ),
                ],
              ),
            ),

            // Pengaturan Section
            _buildSectionTitle("Pengaturan Aplikasi"),
            _buildGlassCard(
              child: Column(
                children: [
                  _buildMenuTile(
                    "Pengingat Membaca Harian",
                    icon: Icons.notifications_rounded,
                  ),
                  const Divider(height: 1, indent: 20, endIndent: 20),
                  _buildMenuTile(
                    "Pengajuan Konten",
                    icon: Icons.description_rounded,
                  ),
                  const Divider(height: 1, indent: 20, endIndent: 20),
                  _buildMenuTile(
                    "Hapus Preview Konten",
                    icon: Icons.delete_outline_rounded,
                  ),
                ],
              ),
            ),

            // Bantuan Section
            _buildSectionTitle("Bantuan & Informasi"),
            _buildGlassCard(
              child: Column(
                children: [
                  _buildMenuTile(
                    "Syarat & Ketentuan",
                    icon: Icons.description_rounded,
                  ),
                  const Divider(height: 1, indent: 20, endIndent: 20),
                  _buildMenuTile(
                    "Kebijakan Privasi",
                    icon: Icons.security_rounded,
                  ),
                  const Divider(height: 1, indent: 20, endIndent: 20),
                  _buildMenuTile(
                    "Layanan Pelanggan",
                    icon: Icons.support_agent_rounded,
                  ),
                  const Divider(height: 1, indent: 20, endIndent: 20),
                  _buildMenuTile(
                    "Tentang Athena Library",
                    icon: Icons.info_outline_rounded,
                  ),
                ],
              ),
            ),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _logout,
                  icon: Icon(Icons.logout_rounded, color: Colors.red[600]),
                  label: Text(
                    "Keluar Akun",
                    style: TextStyle(
                      color: Colors.red[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.red.shade100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.red.withOpacity(0.05),
                  ),
                ),
              ),
            ),

            // Version Info
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Athena Library v1.0",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
