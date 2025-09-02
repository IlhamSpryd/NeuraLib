// import 'package:athena/views/book_detail_page.dart';
// import 'package:flutter/material.dart';
// import 'package:athena/api/book_api.dart';
// import 'package:athena/models/list_book.dart';

// class SearchPage extends StatefulWidget {
//   const SearchPage({super.key});

//   @override
//   State<SearchPage> createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   List<Datum> _allBooks = [];
//   List<Datum> _filteredBooks = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadBooks();
//   }

//   Future<void> _loadBooks() async {
//     try {
//       final result = await BookApi.getBooks();
//       setState(() {
//         _allBooks = result?.data ?? [];
//         _filteredBooks = _allBooks;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() => _isLoading = false);
//     }
//   }

//   void _searchBooks(String query) {
//     final results = _allBooks.where((book) {
//       final title = book.title?.toLowerCase() ?? "";
//       final author = book.author?.toLowerCase() ?? "";
//       return title.contains(query.toLowerCase()) ||
//           author.contains(query.toLowerCase());
//     }).toList();

//     setState(() {
//       _filteredBooks = results;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: TextField(
//           autofocus: true,
//           onChanged: _searchBooks,
//           decoration: const InputDecoration(
//             hintText: "Cari buku...",
//             border: InputBorder.none,
//           ),
//         ),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _filteredBooks.isEmpty
//           ? const Center(child: Text("Tidak ada buku ditemukan"))
//           : ListView.builder(
//               itemCount: _filteredBooks.length,
//               itemBuilder: (context, index) {
//                 final book = _filteredBooks[index];
//                 return Card(
//                   margin: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 6,
//                   ),
//                   child: ListTile(
//                     leading: const Icon(Icons.book, color: Colors.blue),
//                     title: Text(book.title ?? "-"),
//                     subtitle: Text("Author: ${book.author ?? "-"}"),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => BookDetailPage(book: book),
//                         ),
//                       );
//                     },
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
