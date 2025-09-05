// home_page.dart
import 'package:athena/api/book_api.dart';
import 'package:athena/models/list_book.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<ListBookItem?> _booksFuture;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  void _loadBooks() {
    setState(() {
      _booksFuture = BookApi.getBooks(search: _searchQuery);
    });
  }

  void _onSearchChanged(String value) {
    _searchQuery = value;
    _loadBooks();
  }

  Future<void> _refreshBooks() async {
    _loadBooks();
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Perpustakaan Athena'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Cari buku...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshBooks,
              child: FutureBuilder<ListBookItem?>(
                future: _booksFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, size: 50, color: Colors.red),
                          const SizedBox(height: 16),
                          Text('Error: ${snapshot.error}'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadBooks,
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.data == null || snapshot.data!.data!.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.book, size: 50, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('Tidak ada buku tersedia'),
                        ],
                      ),
                    );
                  } else {
                    final books = snapshot.data!.data!;
                    return ListView.builder(
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        final book = books[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: ListTile(
                            leading: book.coverUrl != null
                                ? Image.network(
                                    book.coverUrl!,
                                    width: 50,
                                    height: 70,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 50,
                                        height: 70,
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.book),
                                      );
                                    },
                                  )
                                : Container(
                                    width: 50,
                                    height: 70,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.book),
                                  ),
                            title: Text(book.title ?? 'No Title'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(book.author ?? 'Unknown Author'),
                                Text('Stok: ${book.stock ?? 0}'),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.info),
                              onPressed: () {
                                // Navigate to book details
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshBooks,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
