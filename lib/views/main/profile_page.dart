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
  String _userName = "Reader";
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
      final Historybook borrows = await BookApi.getActiveBorrows();

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
    final name = await SharedPreferencesHelper.getUserName() ?? "Reader";
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
          content: const Text('Failed to select image'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color surfaceColor = Theme.of(context).colorScheme.surface;
    final Color onSurface = Theme.of(context).colorScheme.onSurface;
    final Color secondaryColor = Theme.of(context).colorScheme.secondary;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: surfaceColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Loading your profile...",
                style: TextStyle(
                  fontSize: 16,
                  color: onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: surfaceColor,
      body: RefreshIndicator(
        onRefresh: _refreshProfile,
        color: primaryColor,
        backgroundColor: surfaceColor,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 220,
              floating: false,
              pinned: true,
              backgroundColor: surfaceColor,
              elevation: 0,
              automaticallyImplyLeading: false,
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  return FlexibleSpaceBar(
                    title: constraints.maxHeight > 130
                        ? null
                        : Text(
                            _userName,
                            style: TextStyle(
                              color: onSurface,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                    centerTitle: true,
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [surfaceColor, surfaceColor.withOpacity(0.9)],
                        ),
                      ),
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),
                            _buildAvatarSection(primaryColor),
                            const SizedBox(height: 16),
                            _buildUserInfoSection(onSurface),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildStatsSection(
                      surfaceColor,
                      onSurface,
                      primaryColor,
                      secondaryColor,
                    ),
                    const SizedBox(height: 24),
                    _buildActionSection(surfaceColor, onSurface, primaryColor),
                    const SizedBox(height: 24),
                    _buildPreferencesSection(
                      surfaceColor,
                      onSurface,
                      primaryColor,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSection(Color primaryColor) {
    return GestureDetector(
      onTap: _pickAvatar,
      child: Stack(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _avatarImage != null
                  ? Colors.transparent
                  : primaryColor.withOpacity(0.1),
              border: Border.all(
                color: primaryColor.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: _avatarImage != null
                ? ClipOval(
                    child: Image.file(
                      _avatarImage!,
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                    ),
                  )
                : Center(
                    child: Text(
                      _userName.isNotEmpty ? _userName[0].toUpperCase() : "R",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                  ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(Icons.camera_alt, size: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoSection(Color onSurface) {
    return Column(
      children: [
        Text(
          _userName,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _userEmail,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(
    Color surfaceColor,
    Color onSurface,
    Color primaryColor,
    Color secondaryColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Reading Activity",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.menu_book_rounded,
                  label: "Currently Reading",
                  value: _borrowedBooksCount.toString(),
                  color: primaryColor,
                  onSurface: onSurface,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.library_books_rounded,
                  label: "Books Finished",
                  value: _historyCount.toString(),
                  color: secondaryColor,
                  onSurface: onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required Color onSurface,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionSection(
    Color surfaceColor,
    Color onSurface,
    Color primaryColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildActionTile(
            icon: Icons.person_outline_rounded,
            title: "Edit Profile",
            subtitle: "Update your personal information",
            onTap: _showEditProfileDialog,
            onSurface: onSurface,
            primaryColor: primaryColor,
          ),
          _buildDivider(onSurface),
          _buildActionTile(
            icon: Icons.history_rounded,
            title: "Reading History",
            subtitle: "View your reading journey",
            onTap: () {},
            onSurface: onSurface,
            primaryColor: primaryColor,
          ),
          _buildDivider(onSurface),
          _buildActionTile(
            icon: Icons.add,
            title: "Add Books",
            subtitle: "View your reading journey",
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/addBooks');
            },
            onSurface: onSurface,
            primaryColor: primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesSection(
    Color surfaceColor,
    Color onSurface,
    Color primaryColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildActionTile(
            icon: Icons.settings_outlined,
            title: "Settings",
            subtitle: "App preferences and configuration",
            onTap: () {},
            onSurface: onSurface,
            primaryColor: primaryColor,
          ),
          _buildDivider(onSurface),
          _buildActionTile(
            icon: Icons.help_outline_rounded,
            title: "Help & Support",
            subtitle: "Get help with the app",
            onTap: () {},
            onSurface: onSurface,
            primaryColor: primaryColor,
          ),
          _buildDivider(onSurface),
          _buildActionTile(
            icon: Icons.logout_rounded,
            title: "Sign Out",
            subtitle: "Log out from your account",
            onTap: _showLogoutDialog,
            isDestructive: true,
            onSurface: onSurface,
            primaryColor: primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color onSurface,
    required Color primaryColor,
    bool isDestructive = false,
  }) {
    final Color tileColor = isDestructive ? Colors.red : primaryColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: tileColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: tileColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isDestructive ? tileColor : onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: onSurface.withOpacity(0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(Color onSurface) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        color: onSurface.withOpacity(0.1),
        height: 1,
        thickness: 1,
      ),
    );
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _userName);
    final emailController = TextEditingController(text: _userEmail);
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color surfaceColor = Theme.of(context).colorScheme.surface;
    final Color onSurface = Theme.of(context).colorScheme.onSurface;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Edit Profile",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: onSurface,
                ),
              ),
              const SizedBox(height: 24),
              _buildTextField(
                controller: nameController,
                label: "Name",
                icon: Icons.person_outline_rounded,
                onSurface: onSurface,
                surfaceColor: surfaceColor,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: emailController,
                label: "Email",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                onSurface: onSurface,
                surfaceColor: surfaceColor,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        foregroundColor: onSurface.withOpacity(0.7),
                        side: BorderSide(color: onSurface.withOpacity(0.2)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final newName = nameController.text.trim();
                        final newEmail = emailController.text.trim();

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
                              _showSuccessSnackBar(
                                'Profile updated successfully',
                              );
                            }
                          } catch (e) {
                            _showErrorSnackBar('Failed to update profile');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Save",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color onSurface,
    required Color surfaceColor,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(color: onSurface),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: onSurface.withOpacity(0.6)),
        prefixIcon: Icon(icon, color: onSurface.withOpacity(0.6)),
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: onSurface.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: onSurface.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color surfaceColor = Theme.of(context).colorScheme.surface;
    final Color onSurface = Theme.of(context).colorScheme.onSurface;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.logout_rounded, size: 28, color: Colors.red),
              ),
              const SizedBox(height: 20),
              Text(
                "Sign Out",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Are you sure you want to sign out of your account?",
                style: TextStyle(
                  fontSize: 14,
                  color: onSurface.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        foregroundColor: onSurface.withOpacity(0.7),
                        side: BorderSide(color: onSurface.withOpacity(0.2)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
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
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Sign Out",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
