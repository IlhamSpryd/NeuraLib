import 'package:athena/models/list_book.dart';
import 'package:athena/views/book_detail_page.dart';
import 'package:flutter/material.dart';

class BookGrid extends StatefulWidget {
  final List<BookDatum> books;
  final Function(int, String) onBorrow;
  final Function(BookDatum) onEdit;
  final Function(int, String) onDelete; // Tambahkan callback untuk delete

  const BookGrid({
    super.key,
    required this.books,
    required this.onBorrow,
    required this.onEdit,
    required this.onDelete, // Tambahkan parameter onDelete
  });

  @override
  State<BookGrid> createState() => _BookGridState();
}

class _BookGridState extends State<BookGrid> with TickerProviderStateMixin {
  late AnimationController _staggerController;
  late List<Animation<double>> _cardAnimations;

  @override
  void initState() {
    super.initState();

    _staggerController = AnimationController(
      duration: Duration(milliseconds: 100 * widget.books.length),
      vsync: this,
    );

    _cardAnimations = List.generate(
      widget.books.length,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _staggerController,
          curve: Interval(
            index / widget.books.length,
            (index + 1) / widget.books.length,
            curve: Curves.easeOutBack,
          ),
        ),
      ),
    );

    _staggerController.forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _staggerController,
      builder: (context, child) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.65,
          ),
          padding: const EdgeInsets.all(20),
          itemCount: widget.books.length,
          itemBuilder: (context, index) {
            final book = widget.books[index];
            final animation = _cardAnimations[index];

            return Transform.scale(
              scale: animation.value,
              child: Transform.translate(
                offset: Offset(0, 50 * (1 - animation.value)),
                child: Opacity(
                  opacity: animation.value.clamp(0.0, 1.0),
                  child: FuturisticBookCard(
                    book: book,
                    onBorrow: () => widget.onBorrow(book.id!, book.title!),
                    onEdit: () => widget.onEdit(book),
                    onDelete: () => widget.onDelete(
                      book.id!,
                      book.title!,
                    ), // Tambahkan onDelete
                    onTap: () => _navigateToBookDetail(
                      book,
                    ), // Tambahkan onTap untuk detail
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _navigateToBookDetail(BookDatum book) {
    // Navigasi ke halaman detail buku
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailPage(
          bookId: book.id!,
          title: book.title ?? 'Unknown Title',
          author: book.author ?? 'Unknown Author',
          stock: book.stock ?? 0,
        ),
      ),
    );
  }
}

class FuturisticBookCard extends StatefulWidget {
  final BookDatum book;
  final VoidCallback onBorrow;
  final VoidCallback onEdit;
  final VoidCallback onDelete; // Tambahkan callback delete
  final VoidCallback onTap; // Tambahkan callback untuk tap

  const FuturisticBookCard({
    super.key,
    required this.book,
    required this.onBorrow,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });

  @override
  State<FuturisticBookCard> createState() => _FuturisticBookCardState();
}

class _FuturisticBookCardState extends State<FuturisticBookCard>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _glowController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeOut));

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  Color _getStatusColor() {
    final stock = widget.book.stock ?? 0;
    if (stock > 5) return const Color(0xFF00D2BE);
    if (stock > 0) return Colors.orange;
    return Colors.red;
  }

  String _getStatusText() {
    final stock = widget.book.stock ?? 0;
    if (stock > 5) return 'Available';
    if (stock > 0) return 'Limited';
    return 'Out of Stock';
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
    required String tooltip,
    double size = 18,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: size, color: color),
        ),
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Buku'),
          content: Text(
            'Apakah Anda yakin ingin menghapus "${widget.book.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onDelete();
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _hoverController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      child: GestureDetector(
        onTap: widget.onTap, // Tambahkan gesture detector untuk tap
        child: AnimatedBuilder(
          animation: Listenable.merge([_scaleAnimation, _glowAnimation]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                height: 260,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withOpacity(
                        0.2 + _glowAnimation.value * 0.1,
                      ),
                      blurRadius: 15 + _glowAnimation.value * 10,
                      offset: const Offset(0, 8),
                    ),
                    if (_isHovered)
                      BoxShadow(
                        color: statusColor.withOpacity(0.4),
                        blurRadius: 25,
                        offset: const Offset(0, 15),
                      ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cover dengan gesture untuk detail
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Container(
                          height: 100,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                statusColor.withOpacity(0.1),
                                statusColor.withOpacity(0.05),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: statusColor.withOpacity(0.2),
                            ),
                          ),
                          child: Icon(
                            Icons.menu_book_rounded,
                            size: 36,
                            color: statusColor,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Title dengan gesture untuk detail
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          widget.book.title ?? 'Unknown Title',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF20639B),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 3),

                      // Author dengan gesture untuk detail
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'By : ${widget.book.author ?? 'Unknown'}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const Spacer(),

                      // Status + Stock
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _getStatusText(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: statusColor,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Stock: ${widget.book.stock ?? 0}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Action Buttons - Tambahkan delete button
                      Row(
                        children: [
                          // Borrow Button
                          Expanded(
                            child: _buildActionButton(
                              icon: Icons.download_rounded,
                              onPressed: widget.onBorrow,
                              color: statusColor,
                              tooltip: 'Borrow Book',
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Edit Button
                          Expanded(
                            child: _buildActionButton(
                              icon: Icons.edit_rounded,
                              onPressed: widget.onEdit,
                              color: Colors.blue,
                              tooltip: 'Edit Book',
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Delete Button
                          Expanded(
                            child: _buildActionButton(
                              icon: Icons.delete_rounded,
                              onPressed: _showDeleteDialog,
                              color: Colors.red,
                              tooltip: 'Delete Book',
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
