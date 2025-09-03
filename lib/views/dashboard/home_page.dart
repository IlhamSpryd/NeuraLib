import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:athena/api/book_api.dart';
import 'package:athena/models/list_book.dart';
import 'package:athena/views/add_edit_book_page.dart';
import 'package:athena/views/dashboard/profile_page.dart';
import 'package:athena/widgets/custom_navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<BookDatum> _books = [];
  bool _isLoading = true;
  bool _isFetchingMore = false;
  bool _hasMore = true;
  String? _error;
  int _page = 1;
  final int _limit = 20;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchBooks();
    _scrollController.addListener(_onScroll);
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.deepPurple.shade900,
            expandedHeight: 28,
            title: _buildSearchBar(context),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.white),
                onPressed: () {},
              ),
            ],
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
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddEditBookPage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            );
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
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
            Text(
              "Cari buku...",
              style: TextStyle(color: Colors.grey[700], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================
// BookGrid
// ==========================
class BookGrid extends StatelessWidget {
  final List<BookDatum> books;

  const BookGrid({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      itemCount: books.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final book = books[index];
        return GestureDetector(
          onTap: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: CachedNetworkImage(
                    imageUrl:
                        book.coverUrl ??
                        "https://via.placeholder.com/300x400?text=${Uri.encodeComponent(book.title ?? 'Book')}",
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade800,
                      highlightColor: Colors.grey.shade600,
                      child: Container(color: Colors.grey.shade800),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey.shade800,
                      child: const Icon(
                        Icons.error,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                book.title ?? "Unknown",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                book.author ?? "Unknown",
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}

// ==========================
// Shimmer Placeholder
// ==========================
class BookGridShimmer extends StatelessWidget {
  const BookGridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade800,
          highlightColor: Colors.grey.shade600,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }
}

// ==========================
// SearchPage
// ==========================
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<BookDatum> _books = [];
  bool _isLoading = false;
  String? _error;
  Timer? _debounce;
  String _searchQuery = "";

  final ScrollController _scrollController = ScrollController();
  int _page = 1;
  final int _limit = 20;
  bool _hasMore = true;
  bool _isFetchingMore = false;

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = query;
        _page = 1;
        _hasMore = true;
      });
      _fetchBooks();
    });
  }

  Future<void> _fetchBooks({bool loadMore = false}) async {
    if (_isLoading && !loadMore) return;
    if (loadMore) {
      setState(() => _isFetchingMore = true);
    } else {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      final response = await BookApi.getBooks(
        page: _page,
        limit: _limit,
        search: _searchQuery,
      );

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

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(_onScroll);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade900,
        title: TextField(
          style: const TextStyle(color: Colors.white),
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            hintText: "Cari buku...",
            hintStyle: TextStyle(color: Colors.grey.shade400),
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            filled: true,
            fillColor: Colors.grey.shade900,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
      body: _isLoading && _books.isEmpty
          ? const BookGridShimmer()
          : _error != null && _books.isEmpty
          ? Center(
              child: Text(_error!, style: const TextStyle(color: Colors.white)),
            )
          : GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: _books.length + (_isFetchingMore ? 1 : 0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.6,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                if (index >= _books.length) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }
                final book = _books[index];
                return GestureDetector(
                  onTap: () {},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: CachedNetworkImage(
                            imageUrl:
                                book.coverUrl ??
                                "https://via.placeholder.com/300x400?text=${Uri.encodeComponent(book.title ?? 'Book')}",
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey.shade800,
                              highlightColor: Colors.grey.shade600,
                              child: Container(color: Colors.grey.shade800),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey.shade800,
                              child: const Icon(
                                Icons.error,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        book.title ?? "Unknown",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        book.author ?? "Unknown",
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
