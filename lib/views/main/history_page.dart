import 'package:athena/api/book_api.dart';
import 'package:athena/models/history_book.dart';
import 'package:athena/utils/shared_preferences.dart';
import 'package:athena/views/sub%20page/book_detail_page.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with TickerProviderStateMixin {
  late Future<Historybook> _activeBorrowsFuture;
  late Future<Historybook> _borrowHistoryFuture;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  int _currentTabIndex = 0;
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadData();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  // Load current user data from SharedPreferences
  void _loadUserData() async {
    final userId = await SharedPreferencesHelper.getUserId();
    setState(() {
      _currentUserId = userId;
    });
  }

  void _loadData() {
    setState(() {
      _activeBorrowsFuture = BookApi.getActiveBorrows();
      _borrowHistoryFuture = BookApi.getBorrowHistory();
    });
  }

  Future<void> _returnBook(int borrowId, String bookTitle) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      await BookApi.returnBook(borrowId);

      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully returned: $bookTitle'),
            backgroundColor: Colors.green,
          ),
        );
        _loadData(); // Refresh data
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to return book: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _navigateToBookDetail(Datum borrow) {
    if (borrow.book == null) return;

    final book = borrow.book!;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailPage(
          bookId: book.id,
          title: book.title,
          author: book.author,
          coverUrl: book.coverUrl,
          stock: book.stock,
        ),
      ),
    );
  }

  // Filter borrows for current user only
  List<Datum> _filterMyBorrows(List<Datum> allBorrows) {
    if (_currentUserId == null) return allBorrows;

    return allBorrows
        .where((borrow) => borrow.userId == _currentUserId)
        .toList();
  }

  // Filter active borrows (not returned yet)
  List<Datum> _filterActiveBorrows(List<Datum> borrows) {
    return borrows.where((borrow) => borrow.returnDate == null).toList();
  }

  // Filter returned borrows (history)
  List<Datum> _filterReturnedBorrows(List<Datum> borrows) {
    return borrows.where((borrow) => borrow.returnDate != null).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'My Borrows',
          style: theme.textTheme.headlineLarge?.copyWith(fontSize: 22),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              // Tab Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTabButton(
                          'Active Borrows',
                          0,
                          colorScheme,
                        ),
                      ),
                      Expanded(
                        child: _buildTabButton('History', 1, colorScheme),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Content based on selected tab
              Expanded(
                child: _currentTabIndex == 0
                    ? _buildActiveBorrows()
                    : _buildBorrowHistory(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String text, int index, ColorScheme colorScheme) {
    final isSelected = _currentTabIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _currentTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildActiveBorrows() {
    return FutureBuilder<Historybook>(
      future: _activeBorrowsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        if (snapshot.hasError) {
          return _buildErrorState(snapshot.error.toString());
        }

        if (!snapshot.hasData ||
            snapshot.data!.data == null ||
            snapshot.data!.data!.isEmpty) {
          return _buildEmptyState('No active borrows');
        }

        // Filter for current user's active borrows
        final allBorrows = snapshot.data!.data!;
        final myBorrows = _filterMyBorrows(allBorrows);
        final activeBorrows = _filterActiveBorrows(myBorrows);

        if (activeBorrows.isEmpty) {
          return _buildEmptyState('No active borrows');
        }

        return _buildBorrowsList(activeBorrows, true);
      },
    );
  }

  Widget _buildBorrowHistory() {
    return FutureBuilder<Historybook>(
      future: _borrowHistoryFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        if (snapshot.hasError) {
          return _buildErrorState(snapshot.error.toString());
        }

        if (!snapshot.hasData ||
            snapshot.data!.data == null ||
            snapshot.data!.data!.isEmpty) {
          return _buildEmptyState('No borrow history');
        }

        // Filter for current user's returned borrows
        final allBorrows = snapshot.data!.data!;
        final myBorrows = _filterMyBorrows(allBorrows);
        final returnedBorrows = _filterReturnedBorrows(myBorrows);

        if (returnedBorrows.isEmpty) {
          return _buildEmptyState('No borrow history');
        }

        return _buildBorrowsList(returnedBorrows, false);
      },
    );
  }

  Widget _buildBorrowsList(List<Datum> borrows, bool isActive) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: borrows.length,
      itemBuilder: (context, index) {
        final borrow = borrows[index];
        return TweenAnimationBuilder(
          duration: Duration(milliseconds: 600 + (index * 100)),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, double value, child) {
            return Transform.translate(
              offset: Offset(0, 50 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: _buildBorrowCard(borrow, isActive),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBorrowCard(Datum borrow, bool isActive) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final book = borrow.book;

    return GestureDetector(
      onTap: () => _navigateToBookDetail(borrow),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Book Cover
                  Container(
                    width: 60,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: book?.coverUrl != null
                          ? DecorationImage(
                              image: NetworkImage(book!.coverUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                      color: colorScheme.primary.withOpacity(0.1),
                    ),
                    child: book?.coverUrl == null
                        ? Icon(
                            Icons.book_outlined,
                            color: colorScheme.primary,
                            size: 30,
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book?.title ?? 'Unknown Book',
                          style: theme.textTheme.titleLarge,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'by ${book?.author ?? 'Unknown Author'}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Borrowed: ${borrow.borrowDate.toString().split(' ')[0]}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              if (!isActive && borrow.returnDate != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.check_circle, size: 16, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      'Returned: ${borrow.returnDate?.toString().split(' ')[0]}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              if (isActive)
                ElevatedButton(
                  onPressed: () =>
                      _returnBook(borrow.id, book?.title ?? 'Book'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Return Book'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text('Error loading data', textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _currentTabIndex == 0
                ? 'You haven\'t borrowed any books yet'
                : 'Your borrow history will appear here',
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
