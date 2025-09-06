import 'package:athena/views/main/add_edit_book_page.dart';
import 'package:flutter/material.dart';
import 'package:athena/api/book_api.dart';

class BookDetailPage extends StatelessWidget {
  final int bookId;
  final String title;
  final String author;
  final String? coverUrl;
  final int stock;

  const BookDetailPage({
    super.key,
    required this.bookId,
    required this.title,
    required this.author,
    this.coverUrl,
    required this.stock,
  });

  Future<void> _deleteBook(BuildContext context) async {
    try {
      final result = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text(
            "Hapus Buku",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text("Apakah Anda yakin ingin menghapus buku ini?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text("Hapus"),
            ),
          ],
        ),
      );

      if (result == true) {
        await BookApi.deleteBook(bookId);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Buku berhasil dihapus"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal menghapus buku: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detail Buku",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.edit_rounded, color: Colors.deepPurple),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddEditBookPage(
                    bookId: bookId,
                    initialTitle: title,
                    initialAuthor: author,
                    initialStock: stock,
                  ),
                ),
              ).then((refresh) {
                if (refresh == true && context.mounted) {
                  Navigator.pop(context, true);
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.delete_rounded, color: Colors.red),
            onPressed: () => _deleteBook(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover buku dengan shadow
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: coverUrl != null
                      ? Image.network(
                          coverUrl!,
                          width: 180,
                          height: 250,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildPlaceholderCover(),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: 180,
                              height: 250,
                              color: Colors.grey[200],
                              child: Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            );
                          },
                        )
                      : _buildPlaceholderCover(),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Judul buku
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            // Penulis
            Text(
              "Oleh $author",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),

            // Info stok
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: stock > 0 ? Colors.green[50] : Colors.red[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: stock > 0 ? Colors.green[100]! : Colors.red[100]!,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    stock > 0 ? Icons.inventory_rounded : Icons.error_outline,
                    color: stock > 0 ? Colors.green : Colors.red,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    stock > 0 ? "Tersedia ($stock)" : "Stok Habis",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: stock > 0 ? Colors.green[800] : Colors.red[800],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Deskripsi buku
            const Text(
              "Deskripsi",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Buku '$title' karya $author merupakan bacaan yang menarik dengan konten berkualitas tinggi. "
              "Buku ini cocok untuk pembaca yang ingin memperdalam pengetahuan dan wawasan mereka.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Aksi pinjam/baca buku
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Meminjam buku: $title"),
                          backgroundColor: Colors.deepPurple,
                        ),
                      );
                    },
                    icon: const Icon(Icons.menu_book_rounded, size: 20),
                    label: const Text(
                      "Pinjam Buku",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () {
                    // Aksi favorit
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Menambahkan ke favorit: $title"),
                        backgroundColor: Colors.deepPurple,
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.favorite_border_rounded,
                    color: Colors.deepPurple,
                    size: 24,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.deepPurple.withOpacity(0.1),
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Hapus buku button
            Center(
              child: TextButton(
                onPressed: () => _deleteBook(context),
                child: Text(
                  "Hapus Buku",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderCover() {
    return Container(
      width: 180,
      height: 250,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple[100]!, Colors.purple[100]!],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Icon(
          Icons.book_rounded,
          color: Colors.deepPurple[300],
          size: 60,
        ),
      ),
    );
  }
}
