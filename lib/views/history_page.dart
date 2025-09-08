import 'package:athena/api/borrow_api.dart';
import 'package:athena/api/history_api.dart';
import 'package:athena/models/history_book.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<HistoryBook?> _historyFuture;
  bool _isLoading = false;
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _loadHistory();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  void _loadHistory() {
    if (_isMounted) {
      setState(() {
        _historyFuture = HistoryApi.getMyHistory();
      });
    }
  }

  Future<void> _returnBook(int borrowId) async {
    if (_isMounted) {
      setState(() => _isLoading = true);
    }

    try {
      await BorrowApi.returnBook(borrowId);

      if (_isMounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Buku berhasil dikembalikan!",
              style: GoogleFonts.inter(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
        _loadHistory(); // Refresh history
      }
    } catch (e) {
      if (_isMounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Error: $e",
              style: GoogleFonts.inter(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (_isMounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Riwayat Pinjaman",
          style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: FutureBuilder<HistoryBook?>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: GoogleFonts.inter(),
              ),
            );
          } else if (!snapshot.hasData ||
              snapshot.data!.data == null ||
              snapshot.data!.data!.isEmpty) {
            return Center(
              child: Text(
                "Tidak ada riwayat pinjaman",
                style: GoogleFonts.inter(),
              ),
            );
          } else {
            final historyData = snapshot.data!.data!;

            return RefreshIndicator(
              onRefresh: () async {
                _loadHistory();
                await Future.delayed(const Duration(seconds: 1));
              },
              child: ListView.builder(
                itemCount: historyData.length,
                itemBuilder: (context, index) {
                  final item = historyData[index];
                  final isReturned = item.returnDate != null;

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        item.book?.title ?? 'Unknown Book',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.book?.author ?? 'Unknown Author',
                            style: GoogleFonts.inter(),
                          ),
                          Text(
                            "Dipinjam: ${_formatDate(item.borrowDate)}",
                            style: GoogleFonts.inter(),
                          ),
                          if (isReturned)
                            Text(
                              "Dikembalikan: ${_formatDate(item.returnDate is DateTime ? item.returnDate as DateTime? : null)}",
                              style: GoogleFonts.inter(),
                            ),
                          if (!isReturned)
                            Text(
                              "Status: Belum dikembalikan",
                              style: GoogleFonts.inter(color: Colors.red),
                            ),
                        ],
                      ),
                      trailing: !isReturned && !_isLoading
                          ? ElevatedButton(
                              onPressed: () => _returnBook(item.id!),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                "Kembalikan",
                                style: GoogleFonts.inter(),
                              ),
                            )
                          : isReturned
                          ? Icon(Icons.check, color: Colors.green)
                          : CircularProgressIndicator(color: primaryColor),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
