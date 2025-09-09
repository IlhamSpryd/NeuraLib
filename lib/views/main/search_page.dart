import 'package:athena/api/book_api.dart';
import 'package:athena/models/list_book.dart';
import 'package:athena/views/book_detail_page.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<Item> _results = []; // Ubah dari BookDatum ke Item
  bool _isLoading = false;

  void _onSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _results = [];
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await BookApi.getBooks(search: query);

      if (result != null && result.data != null && result.data!.items != null) {
        setState(() {
          _results = result.data!.items!;
        });
      } else {
        setState(() {
          _results = [];
        });
      }
    } catch (e) {
      print("Search error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Pencarian gagal: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _results = [];
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildBookCard(Item book) {
    // Ubah dari BookDatum ke Item
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.white, Colors.grey[50]!]),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: book.coverUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    book.coverUrl!,
                    width: 50,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 50,
                        height: 70,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.deepPurple[100]!,
                              Colors.purple[100]!,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.book_rounded,
                          color: Colors.deepPurple[300],
                        ),
                      );
                    },
                  ),
                )
              : Container(
                  width: 50,
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.deepPurple[100]!, Colors.purple[100]!],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.book_rounded,
                    color: Colors.deepPurple[300],
                  ),
                ),
          title: Text(
            book.title ?? 'No Title',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          subtitle: Text(
            book.author ?? 'Unknown Author',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          trailing: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chevron_right_rounded,
              color: Colors.deepPurple,
              size: 20,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BookDetailPage(
                  bookId: book.id!,
                  title: book.title ?? 'No Title',
                  author: book.author ?? 'Unknown Author',
                  stock: book.stock ?? 0,
                  coverUrl: book.coverUrl,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.deepPurple),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: TextField(
          controller: _controller,
          autofocus: true,
          style: const TextStyle(color: Colors.black87),
          cursorColor: Colors.deepPurple,
          decoration: InputDecoration(
            hintText: "Cari buku...",
            hintStyle: TextStyle(color: Colors.grey[600]),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          ),
          onChanged: _onSearch,
        ),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.deepPurple,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text("Mencari...", style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            )
          : _results.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off_rounded,
                    size: 64,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _controller.text.isEmpty
                        ? "Cari buku yang Anda inginkan"
                        : "Tidak ada hasil pencarian",
                    style: TextStyle(color: Colors.grey[500], fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _controller.text.isEmpty
                        ? "Ketik judul buku di atas"
                        : "Coba kata kunci yang berbeda",
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: _results.length,
              itemBuilder: (context, index) => _buildBookCard(_results[index]),
            ),
    );
  }
}
