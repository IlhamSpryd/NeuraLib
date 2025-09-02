// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import '../api/book_api.dart';
// import '../models/list_book.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late Future<List<BookData>> _books;

//   final List<String> banners = [
//     "https://picsum.photos/800/300?1",
//     "https://picsum.photos/800/300?2",
//     "https://picsum.photos/800/300?3",
//   ];

//   final List<Map<String, String>> categories = [
//     {"name": "Fiksi", "icon": "📚"},
//     {"name": "Sains", "icon": "🔬"},
//     {"name": "Sejarah", "icon": "🏛️"},
//     {"name": "Teknologi", "icon": "💻"},
//     {"name": "Agama", "icon": "☪️"},
//     {"name": "Psikologi", "icon": "🧠"},
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _books = _fetchBooks();
//   }

//   Future<List<BookData>> _fetchBooks() async {
//     final listBook = await BookApi.getBooks();
//     return listBook?.data ?? [];
//   }

//   Future<void> _borrowBook(int bookId) async {
//     try {
//       await BookApi.borrowBook(bookId);
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Book borrowed!")));
//       setState(() => _books = _fetchBooks());
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
//         title: const Text("Athena Library"),
//         backgroundColor: Colors.blue,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Banner carousel
//             CarouselSlider(
//               options: CarouselOptions(
//                 height: 180,
//                 autoPlay: true,
//                 enlargeCenterPage: true,
//               ),
//               items: banners.map((url) {
//                 return ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: Image.network(
//                     url,
//                     fit: BoxFit.cover,
//                     width: double.infinity,
//                   ),
//                 );
//               }).toList(),
//             ),

//             const SizedBox(height: 20),

//             // Kategori horizontal
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Text(
//                 "Kategori",
//                 style: Theme.of(context).textTheme.titleLarge,
//               ),
//             ),
//             const SizedBox(height: 10),
//             SizedBox(
//               height: 80,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: categories.length,
//                 itemBuilder: (context, index) {
//                   final category = categories[index];
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: Column(
//                       children: [
//                         CircleAvatar(
//                           radius: 28,
//                           backgroundColor: Colors.blue.shade100,
//                           child: Text(
//                             category["icon"]!,
//                             style: const TextStyle(fontSize: 24),
//                           ),
//                         ),
//                         const SizedBox(height: 5),
//                         Text(
//                           category["name"]!,
//                           style: const TextStyle(fontSize: 12),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),

//             const SizedBox(height: 20),

//             // Rekomendasi buku dari API
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Text(
//                 "Rekomendasi Buku",
//                 style: Theme.of(context).textTheme.titleLarge,
//               ),
//             ),
//             const SizedBox(height: 10),
//             FutureBuilder<List<BookData>>(
//               future: _books,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text("Error: ${snapshot.error}"));
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(child: Text("No books available"));
//                 } else {
//                   final books = snapshot.data!;
//                   return GridView.builder(
//                     physics: const NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     padding: const EdgeInsets.all(16),
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           childAspectRatio: 0.65,
//                           crossAxisSpacing: 16,
//                           mainAxisSpacing: 16,
//                         ),
//                     itemCount: books.length,
//                     itemBuilder: (context, index) {
//                       final book = books[index];
//                       return GestureDetector(
//                         onTap: () => _borrowBook(book.id),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(12),
//                                 child: Image.network(
//                                   book.cover ?? "https://picsum.photos/200/300",
//                                   fit: BoxFit.cover,
//                                   width: double.infinity,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               book.title,
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 14,
//                               ),
//                             ),
//                             Text(
//                               book.author,
//                               style: const TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   );
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
