// // inbox_page.dart
// import 'package:flutter/material.dart';
// import 'package:athena/api/book_api.dart';
// import 'package:athena/models/list_book.dart'; // Ganti ke model Listbook
// import 'package:google_fonts/google_fonts.dart';

// class InboxPage extends StatefulWidget {
//   const InboxPage({super.key});

//   @override
//   State<InboxPage> createState() => _InboxPageState();
// }

// class _InboxPageState extends State<InboxPage> with TickerProviderStateMixin {
//   late Future<Listbook> _booksFuture;
//   late AnimationController _fadeController;
//   late Animation<double> _fadeAnimation;
//   late AnimationController _slideController;
//   late Animation<Offset> _slideAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _loadBooks();

//     _fadeController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

//     _slideController = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );
//     _slideAnimation =
//         Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
//           CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
//         );

//     _fadeController.forward();
//     _slideController.forward();
//   }

//   @override
//   void dispose() {
//     _fadeController.dispose();
//     _slideController.dispose();
//     super.dispose();
//   }

//   void _loadBooks() {
//     setState(() {
//       _booksFuture = BookApi.returnBook(); // Panggil API Listbook
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;

//     return Scaffold(
//       backgroundColor: colorScheme.surface,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: colorScheme.surface,
//         surfaceTintColor: Colors.transparent,
//         title: Text(
//           'Daftar Buku',
//           style: theme.textTheme.headlineLarge?.copyWith(fontSize: 22),
//         ),
//       ),
//       body: FadeTransition(
//         opacity: _fadeAnimation,
//         child: SlideTransition(
//           position: _slideAnimation,
//           child: FutureBuilder<Listbook>(
//             future: _booksFuture,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return _buildLoadingState();
//               }

//               if (snapshot.hasError) {
//                 return _buildErrorState(snapshot.error.toString());
//               }

//               if (!snapshot.hasData ||
//                   snapshot.data!.data == null ||
//                   snapshot.data!.data!.items == null ||
//                   snapshot.data!.data!.items!.isEmpty) {
//                 return _buildEmptyState();
//               }

//               final books = snapshot.data!.data!.items!;
//               return _buildBooksList(books);
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBooksList(List<Item> books) {
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: books.length,
//       itemBuilder: (context, index) {
//         final book = books[index];
//         return TweenAnimationBuilder(
//           duration: Duration(milliseconds: 600 + (index * 100)),
//           tween: Tween<double>(begin: 0, end: 1),
//           builder: (context, double value, child) {
//             return Transform.translate(
//               offset: Offset(0, 50 * (1 - value)),
//               child: Opacity(opacity: value, child: _buildBookCard(book)),
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _buildBookCard(Item book) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       decoration: BoxDecoration(
//         color: colorScheme.surface,
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(
//           color: colorScheme.outline.withOpacity(0.2),
//           width: 1.5,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: colorScheme.primary.withOpacity(0.05),
//             blurRadius: 20,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   width: 64,
//                   height: 64,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(18),
//                     border: Border.all(
//                       color: colorScheme.primary.withOpacity(0.3),
//                       width: 1,
//                     ),
//                     image: book.coverUrl != null
//                         ? DecorationImage(
//                             image: NetworkImage(book.coverUrl!),
//                             fit: BoxFit.cover,
//                           )
//                         : null,
//                     color: colorScheme.primary.withOpacity(0.1),
//                   ),
//                   child: book.coverUrl == null
//                       ? Icon(
//                           Icons.book_outlined,
//                           color: colorScheme.primary,
//                           size: 32,
//                         )
//                       : null,
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         book.title ?? 'Judul tidak tersedia',
//                         style: theme.textTheme.titleLarge,
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         book.author ?? 'Penulis tidak diketahui',
//                         style: theme.textTheme.bodyLarge?.copyWith(
//                           fontWeight: FontWeight.w500,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Icon(
//                   Icons.inventory_2_outlined,
//                   size: 18,
//                   color: colorScheme.primary,
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   'Stok: ${book.stock ?? 0}',
//                   style: theme.textTheme.bodyMedium?.copyWith(
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLoadingState() {
//     final colorScheme = Theme.of(context).colorScheme;

//     return Center(
//       child: CircularProgressIndicator(
//         valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
//         strokeWidth: 3,
//       ),
//     );
//   }

//   Widget _buildErrorState(String error) {
//     return Center(
//       child: Text(
//         'Gagal memuat data: $error',
//         style: Theme.of(context).textTheme.bodyLarge,
//         textAlign: TextAlign.center,
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Text(
//         'Tidak ada buku tersedia.',
//         style: Theme.of(context).textTheme.bodyLarge,
//       ),
//     );
//   }
// }
