import 'dart:math' as math;
import 'dart:ui';

import 'package:athena/api/book_api.dart';
import 'package:athena/models/list_book.dart';
import 'package:athena/utils/shared_preferences.dart';
import 'package:athena/views/main/addBookPage.dart';
import 'package:athena/views/sub%20page/book_detail_page.dart';
import 'package:athena/views/sub%20page/search_page.dart';
import 'package:athena/widgets/book_grid.dart';
import 'package:athena/widgets/carousel_banner.dart' as carousel;
import 'package:athena/widgets/recommendation_header.dart' as recommendation;
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late Future<Listbook?> _booksFuture;
  final TextEditingController _searchTextController = TextEditingController();
  String _searchQuery = "";
  String? _userName;
  String? _userEmail;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // Enhanced Animation Controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _searchAnimationController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late AnimationController _atmosphereController;
  late AnimationController _particleController;

  // Enhanced Animations
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _searchAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _atmosphereAnimation;
  late Animation<double> _particleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadBooks();
    _loadUserData();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );

    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _atmosphereController = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    );

    _particleController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    // Initialize animations with enhanced curves
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
        );

    _searchAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _searchAnimationController,
        curve: Curves.bounceOut,
      ),
    );

    _floatingAnimation = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _atmosphereAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _atmosphereController, curve: Curves.linear),
    );

    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.easeInOut),
    );

    // Start animations
    _fadeController.forward();
    _slideController.forward();
    _searchAnimationController.forward();
    _floatingController.repeat(reverse: true);
    _pulseController.repeat(reverse: true);
    _atmosphereController.repeat();
    _particleController.repeat(reverse: true);
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
            color: (color ?? Colors.white).withOpacity(opacity),
            borderRadius: borderRadius ?? BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
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

  Widget _buildBookCover(
    String? coverUrl, {
    double width = 100,
    double height = 150,
  }) {
    if (coverUrl == null || coverUrl.isEmpty) {
      return _buildGlassMorphicContainer(
        child: SizedBox(
          width: width,
          height: height,
          child: Center(
            child: Icon(
              Icons.auto_stories_rounded,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
              size: 40,
            ),
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        coverUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildGlassMorphicContainer(
            child: SizedBox(
              width: width,
              height: height,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                      : null,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildGlassMorphicContainer(
            child: SizedBox(
              width: width,
              height: height,
              child: Center(
                child: Icon(
                  Icons.error_outline,
                  color: Colors.red.withOpacity(0.6),
                  size: 40,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _navigateToBookDetail(Item book) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => BookDetailPage(
          bookId: book.id!,
          title: book.title ?? 'Unknown Title',
          author: book.author ?? 'Unknown Author',
          coverUrl: book.coverUrl,
          stock: book.stock ?? 0,
          onBookBorrowed: _refreshBooks,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
      ),
    );
  }

  Future<void> _loadUserData() async {
    try {
      final userName = await SharedPreferencesHelper.getUserName();
      final userEmail = await SharedPreferencesHelper.getUserEmail();

      if (mounted) {
        setState(() {
          _userName = userName ?? 'Neural User';
          _userEmail = userEmail;
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
      if (mounted) {
        setState(() {
          _userName = 'Neural User';
          _userEmail = null;
        });
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _searchAnimationController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    _atmosphereController.dispose();
    _particleController.dispose();
    _searchTextController.dispose();
    super.dispose();
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

  void _navigateToSearchPage() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SearchPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
            ),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
      ),
    );
  }

  Future<void> _refreshBooks() async {
    _loadBooks();
    await _loadUserData();
    await Future.delayed(const Duration(milliseconds: 800));
  }

  Future<void> _borrowBook(int bookId, String bookTitle) async {
    try {
      final result = await BookApi.borrowBook(bookId);

      if (mounted) {
        _refreshBooks();
        _showCustomSnackBar(
          'Neural sync completed! "$bookTitle" acquired',
          Icons.cloud_download_rounded,
          Theme.of(context).colorScheme.secondary,
        );
      }
    } catch (e) {
      if (mounted) {
        _showCustomSnackBar(
          'Neural sync failed: $e',
          Icons.error_outline_rounded,
          Colors.red,
        );
      }
    }
  }

  Future<void> _deleteBook(int bookId, String bookTitle) async {
    try {
      final result = await BookApi.deleteBook(bookId);

      if (mounted) {
        _refreshBooks();
        _showCustomSnackBar(
          'Data purged: "$bookTitle" deleted',
          Icons.delete_sweep_rounded,
          Colors.orange,
        );
      }
    } catch (e) {
      if (mounted) {
        _showCustomSnackBar(
          'Deletion failed: $e',
          Icons.error_outline_rounded,
          Colors.red,
        );
      }
    }
  }

  void _showCustomSnackBar(String message, IconData icon, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: _buildGlassMorphicContainer(
          blur: 20,
          opacity: 0.2,
          color: color,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _navigateToEditBook(Item book) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => AddBookPage(
          bookId: book.id,
          initialTitle: book.title,
          initialAuthor: book.author,
          initialStock: book.stock,
          onBookUpdated: _refreshBooks,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
            child: child,
          );
        },
      ),
    ).then((refreshed) {
      if (refreshed == true) _refreshBooks();
    });
  }

  // Di home_page.dart - GUNAKAN _loadBooks yang sudah ada:
  void _navigateToAddBook() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddBookPage(onBookUpdated: _loadBooks),
      ),
    ).then((refreshed) {
      if (refreshed == true) {
        _loadBooks(); 
      }
    });
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: _buildGlassMorphicContainer(
                    blur: 25,
                    opacity: 0.1,
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.auto_stories_rounded,
                            color: Theme.of(context).colorScheme.primary,
                            size: 28,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            AnimatedBuilder(
              animation: _floatingAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _floatingAnimation.value),
                  child: Text(
                    'Synchronizing neural library...',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      letterSpacing: 1.2,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(dynamic error) {
    String errorMessage = "Neural network disruption detected";

    if (error.toString().contains("No token found")) {
      errorMessage = "Authentication matrix expired";
    } else if (error.toString().contains("HTTP") ||
        error.toString().contains("FormatException")) {
      errorMessage = "Quantum connection unstable";
    }

    return Container(
      margin: const EdgeInsets.all(20),
      child: _buildGlassMorphicContainer(
        opacity: 0.05,
        color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _atmosphereAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _atmosphereAnimation.value,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.red.withOpacity(0.6),
                            Colors.orange.withOpacity(0.6),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.warning_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Text(
                errorMessage,
                style: TextStyle(
                  color: Colors.red.shade300,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Attempting to reestablish connection...',
                style: TextStyle(color: Colors.red.shade200, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _buildGlassMorphicContainer(
                opacity: 0.2,
                color: Colors.red,
                child: InkWell(
                  onTap: _loadBooks,
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.refresh_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Reconnect Neural Link",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: _buildGlassMorphicContainer(
        opacity: 0.05,
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _floatingAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _floatingAnimation.value),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.secondary,
                            Theme.of(context).colorScheme.tertiary,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.3),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.auto_stories_rounded,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              Text(
                'Neural Library Initializing',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Upload your first data matrix\nto begin the neural synchronization',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _buildGlassMorphicContainer(
                opacity: 0.1,
                color: Theme.of(context).colorScheme.primary,
                child: InkWell(
                  onTap: _navigateToAddBook,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_circle_outline, color: Colors.white),
                        const SizedBox(width: 12),
                        Text(
                          'Initialize First Entry',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refreshBooks,
          color: Theme.of(context).colorScheme.primary,
          backgroundColor: Colors.transparent,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 220,
                floating: true,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildGlassMorphicContainer(
                    blur: 30,
                    opacity: 0.1,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.8),
                            Theme.of(
                              context,
                            ).colorScheme.secondary.withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Neural Library',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(
                                              0.8,
                                            ),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 2,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Hello, ${_userName ?? 'User'}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 28,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.5,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  GestureDetector(
                                    onTap: () => _showUserMenu(context),
                                    child: _buildGlassMorphicContainer(
                                      blur: 20,
                                      opacity: 0.3,
                                      borderRadius: BorderRadius.circular(25),
                                      child: SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: _userName != null
                                            ? Center(
                                                child: Text(
                                                  _userName![0].toUpperCase(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              )
                                            : const Icon(
                                                Icons.person_rounded,
                                                color: Colors.white,
                                                size: 24,
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              GestureDetector(
                                onTap: _navigateToSearchPage,
                                child: _buildGlassMorphicContainer(
                                  blur: 25,
                                  opacity: 0.2,
                                  borderRadius: BorderRadius.circular(28),
                                  child: Container(
                                    height: 56,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.search_rounded,
                                          color: Colors.white.withOpacity(0.8),
                                          size: 24,
                                        ),
                                        const SizedBox(width: 16),
                                        Text(
                                          'Search Books...',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(
                                              0.8,
                                            ),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                    child: carousel.CarouselBanner(),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: recommendation.RecommendationHeader(),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              SliverToBoxAdapter(
                child: FutureBuilder<Listbook?>(
                  future: _booksFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildLoadingState();
                    } else if (snapshot.hasError) {
                      return _buildErrorState(snapshot.error);
                    } else if (!snapshot.hasData ||
                        snapshot.data?.data?.items == null ||
                        snapshot.data!.data!.items!.isEmpty) {
                      return _buildEmptyState();
                    } else {
                      final books = snapshot.data!.data!.items!;
                      return SlideTransition(
                        position: _slideAnimation,
                        child: BookGrid(
                          books: books,
                          onBorrow: _borrowBook,
                          onEdit: _navigateToEditBook,
                          onDelete: _deleteBook,
                        ),
                      );
                    }
                  },
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  void _showUserMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              _buildMenuTile(
                icon: Icons.person_rounded,
                title: 'Neural Profile',
                onTap: () => Navigator.pop(context),
              ),
              _buildMenuTile(
                icon: Icons.settings_rounded,
                title: 'System Settings',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/settings');
                },
              ),
              _buildMenuTile(
                icon: Icons.logout_rounded,
                title: 'Disconnect',
                isDestructive: true,
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: ListTile(
          leading: Icon(
            icon,
            color: isDestructive
                ? Colors.red
                : Theme.of(context).colorScheme.primary,
          ),
          title: Text(
            title,
            style: TextStyle(
              color: isDestructive
                  ? Colors.red
                  : Theme.of(context).textTheme.titleMedium?.color,
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: onTap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
    );
  }
}
