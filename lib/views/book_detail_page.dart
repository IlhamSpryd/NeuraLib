// import 'package:flutter/material.dart';
// import 'package:athena/api/book_api.dart';
// import 'package:athena/models/list_book.dart';

// class BookDetailPage extends StatefulWidget {
//   final Datum book;
//   const BookDetailPage({super.key, required this.book});

//   @override
//   State<BookDetailPage> createState() => _BookDetailPageState();
// }

// class _BookDetailPageState extends State<BookDetailPage> {
//   bool _isBorrowing = false;
//   String? _message;
//   late Datum book;

//   @override
//   void initState() {
//     super.initState();
//     book = widget.book;
//   }

//   Future<void> _borrowBook() async {
//     // Check if book is available
//     if (book.stock != null && book.stock! < 1) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Buku tidak tersedia untuk dipinjam")),
//       );
//       return;
//     }

//     setState(() {
//       _isBorrowing = true;
//       _message = null;
//     });

//     try {
//       final result = await BookApi.borrowBook(book.id!);

//       setState(() {
//         _isBorrowing = false;
//         _message = result?.message ?? "Berhasil meminjam buku!";

//         // Update the book stock locally
//         if (book.stock != null) {
//           book.stock = book.stock! - 1;
//         }
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(_message!), backgroundColor: Colors.green),
//       );
//     } catch (e) {
//       setState(() {
//         _isBorrowing = false;
//         _message = "Gagal meminjam buku: ${e.toString()}";
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(_message!), backgroundColor: Colors.red),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(book.title ?? "Detail Buku"),
//         backgroundColor: Colors.blue[700],
//         foregroundColor: Colors.white,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Book cover
//             Center(
//               child: Container(
//                 width: 150,
//                 height: 220,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   color: Colors.grey[200],
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.5),
//                       spreadRadius: 2,
//                       blurRadius: 5,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                   image: const DecorationImage(
//                     image: AssetImage("assets/images/book_placeholder.png"),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),

//             // Title
//             Text(
//               book.title ?? "Tanpa Judul",
//               style: const TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blueGrey,
//               ),
//             ),

//             const SizedBox(height: 12),

//             // Author
//             Row(
//               children: [
//                 const Icon(Icons.person_outline, size: 18, color: Colors.grey),
//                 const SizedBox(width: 8),
//                 Text(
//                   "Penulis: ${book.author ?? "-"}",
//                   style: const TextStyle(fontSize: 16, color: Colors.black87),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 8),

//             // Stock
//             Row(
//               children: [
//                 const Icon(
//                   Icons.inventory_2_outlined,
//                   size: 18,
//                   color: Colors.grey,
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   "Stok: ${book.stock ?? 0}",
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: (book.stock != null && book.stock! > 0)
//                         ? Colors.green
//                         : Colors.red,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 8),

//             // Category (if available)
//             if (book.category != null)
//               Row(
//                 children: [
//                   const Icon(
//                     Icons.category_outlined,
//                     size: 18,
//                     color: Colors.grey,
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     "Kategori: ${book.category}",
//                     style: const TextStyle(fontSize: 16, color: Colors.black87),
//                   ),
//                 ],
//               ),

//             const Divider(height: 32),

//             // Description (if available)
//             if (book.description != null) ...[
//               const Text(
//                 "Deskripsi",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 book.description!,
//                 textAlign: TextAlign.justify,
//                 style: const TextStyle(fontSize: 16, height: 1.5),
//               ),
//               const SizedBox(height: 24),
//             ],

//             // Borrow button - only show if book is available
//             if (book.stock != null && book.stock! > 0)
//               Center(
//                 child: SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: _isBorrowing ? null : _borrowBook,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue[700],
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: _isBorrowing
//                         ? const SizedBox(
//                             width: 20,
//                             height: 20,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               color: Colors.white,
//                             ),
//                           )
//                         : const Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(Icons.bookmark_add_outlined),
//                               SizedBox(width: 8),
//                               Text(
//                                 "Pinjam Buku",
//                                 style: TextStyle(fontSize: 16),
//                               ),
//                             ],
//                           ),
//                   ),
//                 ),
//               ),

//             // Show message if book is out of stock
//             if (book.stock != null && book.stock! < 1)
//               Center(
//                 child: Column(
//                   children: [
//                     const Icon(
//                       Icons.error_outline,
//                       size: 40,
//                       color: Colors.red,
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       "Buku sedang tidak tersedia",
//                       style: TextStyle(color: Colors.red, fontSize: 16),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       "Stok akan tersedia kembali: ${book.stock ?? 0}",
//                       style: const TextStyle(color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
