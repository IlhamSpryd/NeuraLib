import 'dart:io';

import 'package:athena/api/book_api.dart';
import 'package:athena/models/add_book.dart'; // Data dipakai untuk return ke HomePage
import 'package:flutter/material.dart';

class AddEditBookPage extends StatefulWidget {
  const AddEditBookPage({super.key});

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
    if (!_formKey.currentState!.validate()) return;

    final stock = int.tryParse(_stockController.text);
    if (stock == null || stock < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Stok harus berupa angka >= 0")),
      );
      return;
    }

    if (mounted) setState(() => _isSaving = true);

    try {
      final AddBook? response = await BookApi.addBook(
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        stock: stock,
      );

      print("DEBUG API RESPONSE: ${response?.toJson()}");

      if (!mounted) return;

      if (response != null && response.data != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Buku berhasil ditambahkan")),
        );

        // 🔹 Kirim data buku baru ke HomePage
        Navigator.pop(context, response.data);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Gagal menambahkan buku")));
      }
    } on SocketException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tidak ada koneksi internet")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isSaving = false);
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
      ),
      body: SingleChildScrollView(
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
                  backgroundColor: Colors.deepPurple.withOpacity(
                    _isSaving ? 0.6 : 1,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
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
    );
  }
}
