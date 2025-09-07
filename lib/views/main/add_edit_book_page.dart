import 'package:athena/api/book_api.dart';
import 'package:flutter/material.dart';

class AddEditBookPage extends StatefulWidget {
  final int? bookId;
  final String? initialTitle;
  final String? initialAuthor;
  final int? initialStock;
  final bool isEditMode;
  final VoidCallback? onBookUpdated;

  const AddEditBookPage({
    super.key,
    this.bookId,
    this.initialTitle,
    this.initialAuthor,
    this.initialStock,
    this.onBookUpdated,
  }) : isEditMode = bookId != null;

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
  void initState() {
    super.initState();

    if (widget.isEditMode) {
      _titleController.text = widget.initialTitle ?? '';
      _authorController.text = widget.initialAuthor ?? '';
      _stockController.text = widget.initialStock?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _saveBook() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final stock = int.tryParse(_stockController.text);
    if (stock == null || stock < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Stok harus berupa angka >= 0"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      if (widget.isEditMode) {
        final response = await BookApi.updateBook(
          id: widget.bookId!,
          title: _titleController.text.trim(),
          author: _authorController.text.trim(),
          stock: stock,
        );

        if (response != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Buku berhasil diperbarui!"),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          if (widget.onBookUpdated != null) {
            widget.onBookUpdated!();
          }
          Navigator.pop(context, true);
        }
      } else {
        final response = await BookApi.addBook(
          title: _titleController.text.trim(),
          author: _authorController.text.trim(),
          stock: stock,
        );

        if (response != null && response.data != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Buku berhasil ditambahkan!"),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          if (widget.onBookUpdated != null) {
            widget.onBookUpdated!();
          }
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
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
      style: const TextStyle(color: Colors.black87, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: Colors.deepPurple)
            : null,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.isEditMode ? "Edit Buku" : "Tambah Buku",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.grey[50]!],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _titleController,
                          label: "Judul Buku",
                          validator: (val) => val == null || val.isEmpty
                              ? "Judul tidak boleh kosong"
                              : null,
                          prefixIcon: Icons.book_rounded,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _authorController,
                          label: "Penulis",
                          validator: (val) => val == null || val.isEmpty
                              ? "Penulis tidak boleh kosong"
                              : null,
                          prefixIcon: Icons.person_rounded,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _stockController,
                          label: "Stok",
                          type: TextInputType.number,
                          validator: (val) => val == null || val.isEmpty
                              ? "Stok tidak boleh kosong"
                              : null,
                          prefixIcon: Icons.inventory_2_rounded,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                ElevatedButton(
                  onPressed: _isSaving ? null : _saveBook,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
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
                      : Text(
                          widget.isEditMode ? "Update Buku" : "Tambah Buku",
                          style: const TextStyle(
                            fontSize: 16,
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
