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
      // Fallback ke shared preferences
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
        return AlertDialog(
          title: const Text("Konfirmasi Logout"),
          content: const Text("Apakah Anda yakin ingin keluar?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            TextButton(
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
                      content: Text("Logout gagal: ${e.toString()}"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text("Keluar", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$label berhasil disalin"),
        backgroundColor: Colors.deepPurple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildMenuTile(String title, {IconData? icon, VoidCallback? onTap}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: icon != null
          ? Icon(icon, color: Colors.grey[700], size: 22)
          : null,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[800],
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildDeletePreviewSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Preview Konten",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Agar performa aplikasi tetap optimal, hapus konten preview yang tersimpan secara berkala.",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Fitur hapus preview akan segera hadir"),
                    backgroundColor: Colors.deepPurple,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
              ),
              child: const Text("Hapus"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxTile(
    String title,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return CheckboxListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      value: value,
      onChanged: onChanged,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[800],
          fontWeight: FontWeight.w500,
        ),
      ),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Colors.deepPurple,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Akun",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: ListView(
        children: [
          // Profil Pengguna Section
          _buildSectionTitle("Profil Pengguna"),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      _userName!.isNotEmpty ? _userName![0].toUpperCase() : "?",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _userName!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _userEmail!,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.copy_rounded,
                    color: Colors.deepPurple,
                    size: 20,
                  ),
                  onPressed: () => _copyToClipboard(_userEmail!, "Email"),
                ),
              ],
            ),
          ),
          const Divider(height: 32),

          // Akun Section
          _buildSectionTitle("Akun"),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildMenuTile("Transaksi", icon: Icons.receipt_rounded),
                const Divider(height: 1, indent: 20),
                _buildMenuTile("Wishlist", icon: Icons.favorite_border_rounded),
                const Divider(height: 1, indent: 20),
                _buildMenuTile(
                  "Paket Langganan",
                  icon: Icons.card_membership_rounded,
                ),
                const Divider(height: 1, indent: 20),
                _buildMenuTile("Ubah Kata Sandi", icon: Icons.lock_rounded),
                const Divider(height: 1, indent: 20),
                _buildMenuTile(
                  "Aktivasi Kode Kupon",
                  icon: Icons.local_offer_rounded,
                ),
                const Divider(height: 1, indent: 20),
                _buildMenuTile(
                  "Pengingat Membaca Harian",
                  icon: Icons.notifications_rounded,
                ),
                const Divider(height: 1, indent: 20),
                _buildMenuTile(
                  "Pengajuan Konten",
                  icon: Icons.description_rounded,
                ),
              ],
            ),
          ),
          const Divider(height: 32),

          // Preview Konten Section
          _buildSectionTitle("Preview Konten"),
          _buildDeletePreviewSection(),
          const Divider(height: 32),

          // FAQ Section
          _buildSectionTitle("FAQ"),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildCheckboxTile("Syarat & Ketentuan", false, (value) {}),
                const Divider(height: 1, indent: 20),
                _buildCheckboxTile("Kebijakan Privasi", true, (value) {}),
                const Divider(height: 1, indent: 20),
                _buildCheckboxTile("Newsletter", false, (value) {}),
                const Divider(height: 1, indent: 20),
                _buildCheckboxTile("Layanan Pelanggan", false, (value) {}),
                const Divider(height: 1, indent: 20),
                _buildCheckboxTile("Tentang Athena Library", false, (value) {}),
                const Divider(height: 1, indent: 20),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  leading: Icon(
                    Icons.exit_to_app_rounded,
                    color: Colors.red[700],
                    size: 22,
                  ),
                  title: Text(
                    "Keluar Akun",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: _logout,
                ),
              ],
            ),
          ),
          const Divider(height: 32),

          // Version Info
          Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text(
                "Versi 1.0",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
