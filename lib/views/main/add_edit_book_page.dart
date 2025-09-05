// add_edit_book_page.dart - FIXED VERSION
import 'dart:io';
import 'package:athena/api/book_api.dart';
import 'package:athena/models/add_book.dart';
import 'package:flutter/material.dart';

class AddEditBookPage extends StatefulWidget {
  final VoidCallback? onBookAdded; // ✅ JADIKAN OPTIONAL

  const AddEditBookPage({super.key, this.onBookAdded});
  @override
  State<AddEditBookPage> createState() => _AddEditBookPageState();
}

class _AddEditBookPageState extends State<AddEditBookPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _saveBook() async {
    // ✅ VALIDATE FORM FIRST
    if (!_formKey.currentState!.validate()) {
      print('❌ Form validation failed');
      return;
    }

    final stock = int.tryParse(_stockController.text);
    if (stock == null || stock < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Stok harus berupa angka >= 0")),
      );
      return;
    }

    print('💾 Saving book: ${_titleController.text}');

    // ✅ SAFE SETSTATE - CHECK MOUNTED
    if (!mounted) return;
    setState(() => _isSaving = true);

    try {
      final AddBook? response = await BookApi.addBook(
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        stock: stock,
      );

      print("✅ API Response: ${response?.toJson()}");

      // ✅ CRITICAL FIX: CHECK MOUNTED BEFORE ANY UI OPERATION
      if (!mounted) {
        print('⚠️ Widget not mounted, skipping UI operations');
        return;
      }

      if (response != null && response.data != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Buku berhasil ditambahkan!")),
        );

        // ✅ CLEAR FORM
        _titleController.clear();
        _authorController.clear();
        _stockController.clear();

        // ✅ WAIT FOR USER TO SEE SUCCESS MESSAGE
        await Future.delayed(const Duration(milliseconds: 1500));

        // ✅ SAFE NAVIGATION BACK
        _navigateBack();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Gagal menambahkan buku")));

        // ✅ SAFE SETSTATE - CHECK MOUNTED
        if (mounted) {
          setState(() => _isSaving = false);
        }
      }
    } on SocketException {
      // ✅ SAFE ERROR HANDLING
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tidak ada koneksi internet")),
      );

      if (mounted) {
        setState(() => _isSaving = false);
      }
    } catch (e) {
      print('❌ Error saving book: $e');

      // ✅ SAFE ERROR HANDLING
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));

      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  // ✅ NEW METHOD: SAFE NAVIGATION
  void _navigateBack() {
    if (mounted) {
      // ✅ CLEAR FOCUS FIRST TO AVOID KEYBOARD ISSUES
      FocusScope.of(context).unfocus();

      // ✅ USE NAVIGATOR.MAYBEPOP FOR SAFETY
      Navigator.maybePop(context).then((_) {
        // ✅ SAFE SETSTATE AFTER NAVIGATION
        if (mounted) {
          setState(() => _isSaving = false);
        }
      });
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    TextInputType type = TextInputType.text,
    bool obscureText = false,
    IconData? prefixIcon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.black87, fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54, fontSize: 14),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: Colors.grey)
            : null,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
      ),
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          "Tambah Buku",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.3,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // ✅ SAFE NAVIGATION BACK
            _navigateBack();
          },
        ),
      ),
      body: GestureDetector(
        // ✅ ADD TAP TO DISMISS KEYBOARD
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(
                  controller: _titleController,
                  label: "Judul Buku",
                  validator: (val) => val == null || val.isEmpty
                      ? "Judul tidak boleh kosong"
                      : null,
                  prefixIcon: Icons.book,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _authorController,
                  label: "Penulis",
                  validator: (val) => val == null || val.isEmpty
                      ? "Penulis tidak boleh kosong"
                      : null,
                  prefixIcon: Icons.person,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _stockController,
                  label: "Stok",
                  type: TextInputType.number,
                  validator: (val) => val == null || val.isEmpty
                      ? "Stok tidak boleh kosong"
                      : null,
                  prefixIcon: Icons.confirmation_num,
                ),
                const SizedBox(height: 28),
                ElevatedButton(
                  onPressed: _isSaving ? null : _saveBook,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Simpan",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
