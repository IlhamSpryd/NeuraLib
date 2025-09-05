// import 'package:athena/api/book_api.dart';
// import 'package:athena/models/history_book.dart';
// import 'package:flutter/material.dart';
// import '../api/book_api.dart';
// import '../models/history_book.dart';

// class HistoryPage extends StatefulWidget {
//   const HistoryPage({super.key});

//   @override
//   State<HistoryPage> createState() => _HistoryPageState();
// }

// class _HistoryPageState extends State<HistoryPage> {
//   late Future<List<HistoryBook>> _history;

//   @override
//   void initState() {
//     super.initState();
//     _loadHistory();
//   }

//   void _loadHistory() {
//     _history = _fetchHistory();
//   }

//   Future<List<HistoryBook>> _fetchHistory() async {
//     try {
//       final history = await BookApi.getHistorySelf();
//       return history?.data ?? [];
//     } catch (e) {
//       debugPrint("Error fetching history: $e");
//       return [];
//     }
//   }

//   Future<void> _returnBook(int borrowId) async {
//     try {
//       await BookApi.returnBook(borrowId);
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Book returned!")));
//       setState(() => _loadHistory());
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error: $e")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Riwayat Pinjaman"),
//         backgroundColor: Colors.blue,
//         elevation: 0,
//       ),
//       body: FutureBuilder<List<HistoryBook>>(
//         future: _history,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text("Tidak ada riwayat pinjaman"));
//           } else {
//             final history = snapshot.data!;
//             return ListView.builder(
//               itemCount: history.length,
//               itemBuilder: (context, index) {
//                 final item = history[index];
//                 final isReturned = item.returnedAt != null;

//                 return Card(
//                   margin: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 8,
//                   ),
//                   child: ListTile(
//                     leading: Image.network(
//                       item.book.cover ?? "https://picsum.photos/50/70",
//                       width: 50,
//                       fit: BoxFit.cover,
//                     ),
//                     title: Text(item.book.title),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(item.book.author),
//                         Text("Dipinjam: ${item.borrowedAt}"),
//                         if (isReturned)
//                           Text("Dikembalikan: ${item.returnedAt}"),
//                       ],
//                     ),
//                     trailing: !isReturned
//                         ? ElevatedButton(
//                             onPressed: () => _returnBook(item.id),
//                             child: const Text("Return"),
//                           )
//                         : const Icon(Icons.check, color: Colors.green),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
