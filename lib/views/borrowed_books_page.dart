// import 'package:athena/api/borrow_api.dart';
// import 'package:flutter/material.dart';
// import 'package:athena/models/history_book.dart';

// class BorrowedBooksPage extends StatefulWidget {
//   const BorrowedBooksPage({super.key});

//   @override
//   State<BorrowedBooksPage> createState() => _BorrowedBooksPageState();
// }

// class _BorrowedBooksPageState extends State<BorrowedBooksPage> {
//   late Future<Historybook?> _borrowedBooksFuture;
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _borrowedBooksFuture = _loadBorrowedBooks();
//   }

//   Future<Historybook?> _loadBorrowedBooks() async {
//     setState(() => _isLoading = true);
//     try {
//       return await BorrowApi.getBorrowedBooks();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error loading borrowed books: $e')),
//       );
//       return null;
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   Future<void> _returnBook(int borrowId) async {
//     setState(() => _isLoading = true);
//     try {
//       await BorrowApi.returnBook(borrowId);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Book returned successfully')),
//       );
//       // Refresh the list
//       setState(() {
//         _borrowedBooksFuture = _loadBorrowedBooks();
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Error returning book: $e')));
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Borrowed Books'),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 0.5,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () {
//               setState(() {
//                 _borrowedBooksFuture = _loadBorrowedBooks();
//               });
//             },
//           ),
//         ],
//       ),
//       body: FutureBuilder<Historybook?>(
//         future: _borrowedBooksFuture,
//         builder: (context, snapshot) {
//           if (_isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.error_outline, size: 64, color: Colors.grey),
//                   const SizedBox(height: 16),
//                   const Text(
//                     'Failed to load borrowed books',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         _borrowedBooksFuture = _loadBorrowedBooks();
//                       });
//                     },
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             );
//           }

//           if (snapshot.hasData && snapshot.data != null) {
//             final historyBook = snapshot.data!;
//             final borrowedBooks = historyBook.data ?? [];

//             // Filter hanya buku yang belum dikembalikan
//             final activeBorrows = borrowedBooks
//                 .where((borrow) => borrow.returnDate == null)
//                 .toList();

//             if (activeBorrows.isEmpty) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(
//                       Icons.menu_book_outlined,
//                       size: 64,
//                       color: Colors.grey,
//                     ),
//                     const SizedBox(height: 16),
//                     const Text(
//                       'No borrowed books',
//                       style: TextStyle(fontSize: 18, color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               );
//             }

//             return ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: activeBorrows.length,
//               itemBuilder: (context, index) {
//                 final borrow = activeBorrows[index];
//                 final book = borrow.book;

//                 return Card(
//                   elevation: 1,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   margin: const EdgeInsets.only(bottom: 16),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Book title
//                         Text(
//                           book?.title ?? 'Unknown Title',
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                           ),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         const SizedBox(height: 8),

//                         // Author name
//                         Text(
//                           book?.author ?? 'Unknown Author',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey[700],
//                           ),
//                         ),
//                         const SizedBox(height: 12),

//                         // Borrow details
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             // Borrow date
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Borrowed: ${_formatDate(borrow.borrowDate)}',
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.grey[600],
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   if (borrow.dueDate != null)
//                                     Text(
//                                       'Due: ${_formatDate(borrow.dueDate)}',
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         color: _isOverdue(borrow.dueDate)
//                                             ? Colors.red
//                                             : Colors.grey[600],
//                                         fontWeight: _isOverdue(borrow.dueDate)
//                                             ? FontWeight.w500
//                                             : FontWeight.normal,
//                                       ),
//                                     ),
//                                 ],
//                               ),
//                             ),

//                             // Return button
//                             IconButton(
//                               icon: const Icon(
//                                 Icons.arrow_back,
//                                 color: Colors.blue,
//                               ),
//                               onPressed: () => _showReturnDialog(borrow.id!),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           }

//           return const Center(child: CircularProgressIndicator());
//         },
//       ),
//     );
//   }

//   String _formatDate(DateTime? date) {
//     if (date == null) return 'Unknown date';
//     return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
//   }

//   bool _isOverdue(DateTime? dueDate) {
//     if (dueDate == null) return false;
//     return DateTime.now().isAfter(dueDate);
//   }

//   void _showReturnDialog(int borrowId) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Return Book'),
//           content: const Text('Are you sure you want to return this book?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _returnBook(borrowId);
//               },
//               child: const Text('Return'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
