import 'dart:ui';

import 'package:athena/models/list_book.dart';
import 'package:athena/views/sub%20page/book_detail_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
        crossAxisSpacing: 20,
        mainAxisSpacing: 24,
        childAspectRatio: 0.72,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => BookDetailPage(
          bookId: book.id!,
          title: book.title ?? 'Unknown Title',
          author: book.author ?? 'Unknown Author',
          stock: book.stock ?? 0,
          coverUrl: book.coverUrl,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 0.2);
          const end = Offset.zero;
          const curve = Curves.easeInOutQuart;
          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
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
    if (stock > 5) return const Color.fromARGB(255, 0, 0, 0);
    if (stock > 0) return const Color.fromARGB(255, 0, 0, 0);
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
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
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
                            color: Colors.white.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              // Book Cover Image - Updated to use CachedNetworkImage
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child:
                                      widget.book.coverUrl != null &&
                                          widget.book.coverUrl!.isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: widget.book.coverUrl!,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              _buildPlaceholderCover(),
                                          errorWidget: (context, url, error) =>
                                              _buildPlaceholderCover(),
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
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: _statusColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${widget.book.stock ?? 0}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: _statusColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Quick Actions Overlay (shown on hover)
                              if (_isHovered)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          _buildQuickActionButton(
                                            icon: Icons.visibility_outlined,
                                            onPressed: widget.onTap,
                                          ),
                                          const SizedBox(width: 12),
                                          _buildQuickActionButton(
                                            icon: Icons.download_outlined,
                                            onPressed: widget.onBorrow,
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
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF1A1A1A),
                                    height: 1.3,
                                    letterSpacing: -0.3,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                              const SizedBox(height: 6),

                              // Author
                              Text(
                                widget.book.author ?? 'Unknown Author',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black.withOpacity(0.6),
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
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _statusColor.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        _statusText,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
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
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.7),
            Colors.white.withOpacity(0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu_book_rounded,
            size: 36,
            color: Colors.black.withOpacity(0.3),
          ),
          const SizedBox(height: 8),
          Text(
            'No Cover',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black.withOpacity(0.4),
              fontWeight: FontWeight.w600,
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
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, size: 20, color: const Color(0xFF424242)),
        ),
      ),
    );
  }

  Widget _buildActionMenu() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.4)),
      ),
      child: PopupMenuButton<String>(
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.more_vert_rounded,
            size: 18,
            color: Colors.black.withOpacity(0.6),
          ),
        ),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'borrow',
            height: 42,
            child: Row(
              children: [
                Icon(Icons.download_outlined, size: 18, color: _statusColor),
                const SizedBox(width: 10),
                Text(
                  'Borrow',
                  style: TextStyle(fontSize: 14, color: _statusColor),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'edit',
            height: 42,
            child: const Row(
              children: [
                Icon(Icons.edit_outlined, size: 18, color: Color(0xFF2196F3)),
                SizedBox(width: 10),
                Text(
                  'Edit',
                  style: TextStyle(fontSize: 14, color: Color(0xFF424242)),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'delete',
            height: 42,
            child: const Row(
              children: [
                Icon(Icons.delete_outline, size: 18, color: Color(0xFFFF5252)),
                SizedBox(width: 10),
                Text(
                  'Delete',
                  style: TextStyle(fontSize: 14, color: Color(0xFF424242)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(40),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.white.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    margin: const EdgeInsets.only(top: 32),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0).withOpacity(0.7),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Icon(
                      Icons.warning_amber_rounded,
                      size: 40,
                      color: const Color(0xFFFF8A65).withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Delete Book',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Are you sure you want to delete "${widget.book.title}"?\n\nThis action cannot be undone and will permanently remove the book from your library.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black.withOpacity(0.6),
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                                side: BorderSide(
                                  color: Colors.black.withOpacity(0.1),
                                  width: 1.5,
                                ),
                              ),
                              backgroundColor: Colors.white.withOpacity(0.6),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
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
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Delete',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
