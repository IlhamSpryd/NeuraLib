import 'dart:async';

import 'package:athena/api/book_api.dart';
import 'package:athena/models/add_book.dart';
import 'package:athena/models/list_book.dart';
import 'package:athena/views/main/profile_page.dart';
import 'package:athena/views/main/search_page.dart';
import 'package:athena/widgets/book_grid.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BookDatum> _books = [];
  bool _isLoading = true;
  bool _isFetchingMore = false;
  bool _hasMore = true;
  String? _error;
  int _page = 1;
  final int _limit = 20;
  final ScrollController _scrollController = ScrollController();

  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _fetchBooks();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? "Ilham"; // default jika kosong
    });
  }

  Future<void> _fetchBooks({bool loadMore = false}) async {
    if (loadMore) {
      setState(() => _isFetchingMore = true);
    } else {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      final response = await BookApi.getBooks(page: _page, limit: _limit);

      if (response != null && response.data != null) {
        setState(() {
          if (loadMore) {
            _books.addAll(response.data!);
          } else {
            _books = response.data!;
          }
          if (response.data!.length < _limit) _hasMore = false;
        });
      } else {
        setState(() {
          if (!loadMore) _error = "Tidak ada buku ditemukan";
          _hasMore = false;
        });
      }
    } catch (e) {
      setState(() {
        if (!loadMore) _error = e.toString();
      });
    } finally {
      if (loadMore) {
        setState(() => _isFetchingMore = false);
      } else {
        setState(() => _isLoading = false);
      }
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isFetchingMore &&
        _hasMore &&
        !_isLoading) {
      _page++;
      _fetchBooks(loadMore: true);
    }
  }

  // 🔹 Converter Data -> BookDatum
  BookDatum convertDataToBookDatum(Data data) {
    return BookDatum(
      id: data.id,
      title: data.title,
      author: data.author,
      stock: data.stock,
      coverUrl:
          "https://via.placeholder.com/300x400?text=${Uri.encodeComponent(data.title ?? 'Book')}",
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.deepPurple.shade900,
            expandedHeight: 60,
            title: _buildSearchBar(context),
          ),
          SliverToBoxAdapter(
            child: _isLoading
                ? const BookGridShimmer()
                : _error != null
                ? SizedBox(
                    height: 400,
                    child: Center(
                      child: Text(
                        _error!,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                : BookGrid(books: _books),
          ),
          if (_isFetchingMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SearchPage()),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "Cari buku...",
                style: TextStyle(color: Colors.grey[700], fontSize: 14),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileBody()),
                );
              },
              borderRadius: BorderRadius.circular(27),
              child: CircleAvatar(
                radius: 15,
                backgroundColor: Colors.blueGrey,
                child: Text(
                  _userName != null && _userName!.isNotEmpty
                      ? _userName![0].toUpperCase()
                      : "?",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
