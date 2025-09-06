import 'package:athena/api/borrow_api.dart';
import 'package:athena/api/history_api.dart';
import 'package:athena/models/history_book.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<HistoryBook?> _historyFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    setState(() {
      _historyFuture = HistoryApi.getMyHistory();
    });
  }

  Future<void> _returnBook(int borrowId) async {
    setState(() => _isLoading = true);
    try {
      await BorrowApi.returnBook(borrowId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Buku berhasil dikembalikan!")),
      );
      _loadHistory(); // Refresh history
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Pinjaman"),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: FutureBuilder<HistoryBook?>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.data == null || snapshot.data!.data!.isEmpty) {
            return const Center(child: Text("Tidak ada riwayat pinjaman"));
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
                    child: ListTile(
                      title: Text(item.book?.title ?? 'Unknown Book'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.book?.author ?? 'Unknown Author'),
                          Text("Dipinjam: ${_formatDate(item.borrowDate)}"),
                          if (isReturned)
                            Text("Dikembalikan: ${_formatDate(item.returnDate is DateTime ? item.returnDate as DateTime? : null)}"),
                          if (!isReturned)
                            const Text("Status: Belum dikembalikan", style: TextStyle(color: Colors.red)),
                        ],
                      ),
                      trailing: !isReturned && !_isLoading
                          ? ElevatedButton(
                              onPressed: () => _returnBook(item.id!),
                              child: const Text("Kembalikan"),
                            )
                          : isReturned
                              ? const Icon(Icons.check, color: Colors.green)
                              : const CircularProgressIndicator(),
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
