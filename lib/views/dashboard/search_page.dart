// import 'package:flutter/material.dart';
// import '../api/books_api.dart';
// import '../models/books_model.dart';
// import 'book_detail_page.dart'; 

// class SearchPage extends StatefulWidget {
//   const SearchPage({super.key});

//   @override
//   State<SearchPage> createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   List<Book> books = [];
//   List<Book> filteredBooks = [];
//   final TextEditingController searchController = TextEditingController();
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchBooks();
//   }

//   void fetchBooks() async {
//     try {
//       final fetchedBooks = await getBooks();
//       setState(() {
//         books = fetchedBooks;
//         filteredBooks = fetchedBooks;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       print("Error fetchBooks: $e");
//     }
//   }

//   void filterBooks(String query) {
//     final filtered = books
//         .where(
//           (book) =>
//               book.title.toLowerCase().contains(query.toLowerCase()) ||
//               (book.author?.toLowerCase().contains(query.toLowerCase()) ??
//                   false),
//         )
//         .toList();
//     setState(() {
//       filteredBooks = filtered;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         title: const Text(
//           "Search Books",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 1,
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: TextField(
//               controller: searchController,
//               onChanged: filterBooks,
//               decoration: InputDecoration(
//                 hintText: "Search books...",
//                 prefixIcon: const Icon(Icons.search),
//                 filled: true,
//                 fillColor: Colors.white,
//                 contentPadding: const EdgeInsets.symmetric(
//                   vertical: 0,
//                   horizontal: 16,
//                 ),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : filteredBooks.isEmpty
//                 ? const Center(
//                     child: Text(
//                       'No books found',
//                       style: TextStyle(color: Colors.grey, fontSize: 16),
//                     ),
//                   )
//                 : ListView.separated(
//                     itemCount: filteredBooks.length,
//                     separatorBuilder: (_, __) => const Divider(height: 1),
//                     itemBuilder: (context, index) {
//                       final book = filteredBooks[index];
//                       return ListTile(
//                         leading: book.coverUrl != null
//                             ? Image.network(
//                                 book.coverUrl!,
//                                 width: 50,
//                                 fit: BoxFit.cover,
//                               )
//                             : CircleAvatar(
//                                 backgroundColor: Colors.blue[100],
//                                 child: const Icon(
//                                   Icons.book,
//                                   color: Colors.blue,
//                                 ),
//                               ),
//                         title: Text(
//                           book.title,
//                           style: const TextStyle(fontWeight: FontWeight.w600),
//                         ),
//                         subtitle: Text(book.author ?? "Unknown author"),
//                         trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => BookDetailPage(book: book),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }
