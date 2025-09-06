import 'package:athena/api/book_api.dart';
import 'package:athena/models/list_book.dart';
import 'package:athena/views/book_detail_page.dart';
import 'package:athena/views/main/search_page.dart';
import 'package:athena/widgets/book_grid.dart';
import 'package:athena/widgets/carousel_banner.dart';
import 'package:athena/widgets/category_list.dart';
import 'package:athena/widgets/recommendation_header.dart';
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

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
            ),
          ),
          SizedBox(height: 16),
          Text('Memuat buku...', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildErrorState(dynamic error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, size: 50, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            'Terjadi kesalahan',
            style: TextStyle(color: Colors.grey[700], fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: TextStyle(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _loadBooks, child: const Text('Coba Lagi')),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu_book_rounded, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Tidak ada buku tersedia',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Tambahkan buku baru untuk memulai',
            style: TextStyle(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Athena Library',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.black87,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.search_rounded, color: Colors.grey[700]),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchPage()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshBooks,
        color: Colors.deepPurple,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Cari buku...',
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: Colors.grey[600],
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ),

              // Carousel Banner
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: CarouselBanner(),
              ),
              const SizedBox(height: 24),

              // Category List
              const CategoryList(),
              const SizedBox(height: 24),

              // Recommendation Header
              const RecommendationHeader(),
              const SizedBox(height: 16),

              // Book Grid dengan FutureBuilder
              FutureBuilder<ListBookItem?>(
                future: _booksFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const BookGridShimmer();
                  } else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: _buildErrorState(snapshot.error),
                    );
                  } else if (!snapshot.hasData ||
                      snapshot.data?.data == null ||
                      snapshot.data!.data!.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: _buildEmptyState(),
                    );
                  } else {
                    final books = snapshot.data!.data!;
                    return BookGrid(books: books);
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
