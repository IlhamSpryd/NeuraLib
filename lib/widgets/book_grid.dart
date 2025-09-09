import 'package:athena/models/list_book.dart';
import 'package:athena/views/book_detail_page.dart';
import 'package:flutter/material.dart';

class BookGrid extends StatelessWidget {
  final List<Item> books;
  final Function(int, String) onBorrow;
  final Function(Item) onEdit;
  final Function(int, String) onDelete;

  const BookGrid({
    super.key,
    required this.books,
    required this.onBorrow,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 20,
        childAspectRatio: 0.72,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return ModernBookCard(
          book: book,
          onBorrow: () => onBorrow(book.id!, book.title!),
          onEdit: () => onEdit(book),
          onDelete: () => onDelete(book.id!, book.title!),
          onTap: () => _navigateToBookDetail(context, book),
        );
      },
    );
  }

  void _navigateToBookDetail(BuildContext context, Item book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailPage(
          bookId: book.id!,
          title: book.title ?? 'Unknown Title',
          author: book.author ?? 'Unknown Author',
          stock: book.stock ?? 0,
          coverUrl: book.coverUrl,
        ),
      ),
    );
  }
}

class ModernBookCard extends StatefulWidget {
  final Item book;
  final VoidCallback onBorrow;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const ModernBookCard({
    super.key,
    required this.book,
    required this.onBorrow,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });

  @override
  State<ModernBookCard> createState() => _ModernBookCardState();
}

class _ModernBookCardState extends State<ModernBookCard> {
  bool _isPressed = false;
  bool _isHovered = false;

  Color get _statusColor {
    final stock = widget.book.stock ?? 0;
    if (stock > 5) return const Color(0xFF00C896);
    if (stock > 0) return const Color(0xFFFF8A65);
    return const Color(0xFFFF5252);
  }

  String get _statusText {
    final stock = widget.book.stock ?? 0;
    if (stock > 5) return 'Available';
    if (stock > 0) return 'Limited';
    return 'Out of Stock';
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isPressed ? 0.96 : (_isHovered ? 1.02 : 1.0),
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isHovered
                    ? const Color(0xFFE0E0E0)
                    : const Color(0xFFF0F0F0),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF000000).withOpacity(0.04),
                  blurRadius: _isHovered ? 12 : 4,
                  offset: Offset(0, _isHovered ? 4 : 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Book Cover Section
                Expanded(
                  flex: 4,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF000000).withOpacity(0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Book Cover Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child:
                                widget.book.coverUrl != null &&
                                    widget.book.coverUrl!.isNotEmpty
                                ? Image.network(
                                    widget.book.coverUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return _buildPlaceholderCover();
                                    },
                                  )
                                : _buildPlaceholderCover(),
                          ),
                        ),

                        // Status Badge
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF000000,
                                  ).withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: _statusColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.book.stock ?? 0}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: _statusColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Quick Actions Overlay (shown on hover)
                        if (_isHovered)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Column(
                              children: [
                                _buildQuickActionButton(
                                  icon: Icons.visibility_outlined,
                                  onPressed: widget.onTap,
                                ),
                                const SizedBox(height: 6),
                                _buildQuickActionButton(
                                  icon: Icons.download_outlined,
                                  onPressed: widget.onBorrow,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // Book Info Section
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Expanded(
                          flex: 2,
                          child: Text(
                            widget.book.title ?? 'Unknown Title',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A1A),
                              height: 1.3,
                              letterSpacing: -0.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        const SizedBox(height: 4),

                        // Author
                        Text(
                          widget.book.author ?? 'Unknown Author',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF757575),
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 12),

                        // Bottom Section
                        Row(
                          children: [
                            // Status indicator
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _statusText,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: _statusColor,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 8),

                            // Action Menu
                            _buildActionMenu(),
                          ],
                        ),
                      ],
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

  Widget _buildPlaceholderCover() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF5F5F5), Color(0xFFEEEEEE)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu_book_rounded, size: 32, color: Color(0xFFBDBDBD)),
          SizedBox(height: 8),
          Text(
            'No Cover',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFFBDBDBD),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF000000).withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Icon(icon, size: 16, color: const Color(0xFF424242)),
        ),
      ),
    );
  }

  Widget _buildActionMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'borrow':
            widget.onBorrow();
            break;
          case 'edit':
            widget.onEdit();
            break;
          case 'delete':
            _showDeleteDialog();
            break;
        }
      },
      padding: EdgeInsets.zero,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.more_vert_rounded,
          size: 16,
          color: Color(0xFF757575),
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'borrow',
          height: 40,
          child: Row(
            children: [
              Icon(Icons.download_outlined, size: 16, color: _statusColor),
              const SizedBox(width: 8),
              Text(
                'Borrow',
                style: TextStyle(fontSize: 14, color: _statusColor),
              ),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'edit',
          height: 40,
          child: Row(
            children: [
              Icon(Icons.edit_outlined, size: 16, color: Color(0xFF2196F3)),
              SizedBox(width: 8),
              Text(
                'Edit',
                style: TextStyle(fontSize: 14, color: Color(0xFF424242)),
              ),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          height: 40,
          child: Row(
            children: [
              Icon(Icons.delete_outline, size: 16, color: Color(0xFFFF5252)),
              SizedBox(width: 8),
              Text(
                'Delete',
                style: TextStyle(fontSize: 14, color: Color(0xFF424242)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          contentPadding: const EdgeInsets.all(32),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  size: 40,
                  color: Color(0xFFFF8A65),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Delete Book',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Are you sure you want to delete "${widget.book.title}"?\n\nThis action cannot be undone and will permanently remove the book from your library.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF757575),
                  height: 1.4,
                ),
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xFF424242),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onDelete();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5252),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
