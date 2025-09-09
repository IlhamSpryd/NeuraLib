import 'dart:io';
import 'dart:ui';

import 'package:athena/api/book_api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AddBookPage extends StatefulWidget {
  final int? bookId;
  final String? initialTitle;
  final String? initialAuthor;
  final int? initialStock;
  final String? initialCoverUrl;
  final String? initialDescription;
  final String? initialIsbn;
  final int? initialCategoryId;
  final bool isEditMode;
  final VoidCallback? onBookUpdated;

  const AddBookPage({
    super.key,
    this.bookId,
    this.initialTitle,
    this.initialAuthor,
    this.initialStock,
    this.initialCoverUrl,
    this.initialDescription,
    this.initialIsbn,
    this.initialCategoryId,
    this.onBookUpdated,
  }) : isEditMode = bookId != null;

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage>
    with TickerProviderStateMixin {
  // Changed from SingleTickerProviderStateMixin
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  File? _selectedImage;
  String? _imageUrl;
  bool _isSaving = false;
  bool _isUploading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late AnimationController _floatingController;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _floatingAnimation = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    _floatingController.repeat(reverse: true);

    if (widget.isEditMode) {
      _titleController.text = widget.initialTitle ?? '';
      _authorController.text = widget.initialAuthor ?? '';
      _stockController.text = widget.initialStock?.toString() ?? '';
      _descriptionController.text = widget.initialDescription ?? '';
      _isbnController.text = widget.initialIsbn ?? '';
      _imageUrl = widget.initialCoverUrl;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _stockController.dispose();
    _descriptionController.dispose();
    _isbnController.dispose();
    _animationController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _imageUrl = null;
        });
      }
    } catch (e) {
      _showSnackBar("Error memilih gambar: ${e.toString()}", isError: true);
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _imageUrl = null;
        });
      }
    } catch (e) {
      _showSnackBar("Error mengambil foto: ${e.toString()}", isError: true);
    }
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return _buildGlassMorphicContainer(
          blur: 30,
          opacity: 0.1,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Pilih Gambar Cover',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildImageOption(
                      icon: Icons.photo_library_rounded,
                      label: 'Galerry',
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage();
                      },
                      iconColor: Colors.white,
                      textColor: Colors.white,
                    ),
                    _buildImageOption(
                      icon: Icons.camera_alt_rounded,
                      label: 'Camera',
                      onTap: () {
                        Navigator.pop(context);
                        _takePhoto();
                      },
                      iconColor: Colors.white,
                      textColor: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageOption({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
  Color iconColor = Colors.white,
  Color textColor = Colors.white, 
}) {
  return GestureDetector(
    onTap: onTap,
    child: _buildGlassMorphicContainer(
      blur: 15,
      opacity: 0.1,
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: iconColor, // 👈 pake warna dari parameter
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textColor, // 👈 pake warna dari parameter
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


  Future<void> _saveBook() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final stock = int.tryParse(_stockController.text);
    if (stock == null || stock < 0) {
      _showSnackBar("Stok harus berupa angka >= 0", isError: true);
      return;
    }

    setState(() => _isSaving = true);

    try {
      String? coverUrl = _imageUrl;

      // Upload image jika ada gambar baru yang dipilih
      if (_selectedImage != null) {
        setState(() => _isUploading = true);
        coverUrl = await BookApi.uploadBookCover(_selectedImage!);
        setState(() => _isUploading = false);
      }

      if (widget.isEditMode) {
        final response = await BookApi.updateBook(
          id: widget.bookId!,
          title: _titleController.text.trim(),
          author: _authorController.text.trim(),
          stock: stock,
          coverUrl: coverUrl,
          description: _descriptionController.text.trim().isNotEmpty
              ? _descriptionController.text.trim()
              : null,
          isbn: _isbnController.text.trim().isNotEmpty
              ? _isbnController.text.trim()
              : null,
        );

        if (response.data != null) {
          _showSnackBar("Buku berhasil diperbarui!", isError: false);
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
          coverUrl: coverUrl,
          description: _descriptionController.text.trim().isNotEmpty
              ? _descriptionController.text.trim()
              : null,
          isbn: _isbnController.text.trim().isNotEmpty
              ? _isbnController.text.trim()
              : null,
        );

        if (response.data != null) {
          _showSnackBar("Buku berhasil ditambahkan!", isError: false);
          if (widget.onBookUpdated != null) {
            widget.onBookUpdated!();
          }
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      _showSnackBar("Error: ${e.toString()}", isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
          _isUploading = false;
        });
      }
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildGlassMorphicContainer({
    required Widget child,
    double blur = 15,
    double opacity = 0.1,
    Color? color,
    BorderRadius? borderRadius,
    List<BoxShadow>? boxShadow,
  }) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: (color ?? Theme.of(context).colorScheme.surface).withOpacity(
              opacity,
            ),
            borderRadius: borderRadius ?? BorderRadius.circular(24),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow:
                boxShadow ??
                [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    TextInputType type = TextInputType.text,
    IconData? prefixIcon,
    int maxLines = 1,
    String? hintText,
  }) {
    return _buildGlassMorphicContainer(
      blur: 10,
      opacity: 0.05,
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        maxLines: maxLines,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
          prefixIcon: prefixIcon != null
              ? Icon(
                  prefixIcon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 22,
                )
              : null,
          filled: true,
          fillColor: Colors.transparent,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: 1.5,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildImageSection() {
    return _buildGlassMorphicContainer(
      blur: 15,
      opacity: 0.1,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.image_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Cover Buku',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: _showImagePicker,
                child: AnimatedBuilder(
                  animation: _floatingAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _floatingAnimation.value),
                      child: Container(
                        width: 160,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.3),
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.05),
                              Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.1),
                            ],
                          ),
                        ),
                        child: _selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : _imageUrl != null && _imageUrl!.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.network(
                                  _imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _buildImagePlaceholder();
                                  },
                                ),
                              )
                            : _buildImagePlaceholder(),
                      ),
                    );
                  },
                ),
              ),
            ),
            if (_isUploading) ...[
              const SizedBox(height: 12),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Mengupload gambar...',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_photo_alternate_rounded,
          size: 48,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
        ),
        const SizedBox(height: 12),
        Text(
          'Tambah Cover',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          'Ketuk untuk memilih',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          widget.isEditMode ? "Edit Buku" : "Tambah Buku",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: _buildGlassMorphicContainer(
          blur: 30,
          opacity: 0.1,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  Theme.of(context).colorScheme.secondary.withOpacity(0.8),
                ],
              ),
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildImageSection(),
                      const SizedBox(height: 24),
                      _buildGlassMorphicContainer(
                        blur: 15,
                        opacity: 0.1,
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              _buildTextField(
                                controller: _titleController,
                                label: "Judul Buku",
                                hintText: "Masukkan judul buku",
                                validator: (val) => val == null || val.isEmpty
                                    ? "Judul tidak boleh kosong"
                                    : null,
                                prefixIcon: Icons.book_rounded,
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                controller: _authorController,
                                label: "Penulis",
                                hintText: "Masukkan nama penulis",
                                validator: (val) => val == null || val.isEmpty
                                    ? "Penulis tidak boleh kosong"
                                    : null,
                                prefixIcon: Icons.person_rounded,
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                controller: _stockController,
                                label: "Stok",
                                hintText: "Masukkan jumlah stok",
                                type: TextInputType.number,
                                validator: (val) => val == null || val.isEmpty
                                    ? "Stok tidak boleh kosong"
                                    : null,
                                prefixIcon: Icons.inventory_2_rounded,
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                controller: _isbnController,
                                label: "ISBN (Opsional)",
                                hintText: "Masukkan nomor ISBN",
                                validator: (val) => null,
                                prefixIcon: Icons.numbers_rounded,
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                controller: _descriptionController,
                                label: "Deskripsi (Opsional)",
                                hintText: "Masukkan deskripsi buku",
                                maxLines: 4,
                                validator: (val) => null,
                                prefixIcon: Icons.description_rounded,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildGlassMorphicContainer(
                        blur: 20,
                        opacity: 0.1,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                        child: ElevatedButton(
                          onPressed: (_isSaving || _isUploading)
                              ? null
                              : _saveBook,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: (_isSaving || _isUploading)
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onPrimary,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      _isUploading
                                          ? "Mengupload..."
                                          : "Menyimpan...",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onPrimary,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  widget.isEditMode
                                      ? "Update Buku"
                                      : "Tambah Buku",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
