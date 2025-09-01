// import 'package:flutter/material.dart';
// import 'package:athena/api/authentication_api.dart';
// import 'package:athena/api/books_api.dart';
// import 'package:athena/models/books_model.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   String? _token;
//   String _userName = "";
//   String _userEmail = "";
//   late Future<List<Book>> _booksFuture;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//     _booksFuture = getBooks();
//   }

//   Future<void> _loadUserData() async {
//     final token = await AuthenticationAPI.getToken();
//     final name = await AuthenticationAPI.getUserName();
//     final email = await AuthenticationAPI.getUserEmail();

//     setState(() {
//       _token = token;
//       _userName = name ?? "";
//       _userEmail = email ?? "";
//     });
//   }

//   void _logout() async {
//     await AuthenticationAPI.logout();
//     if (!mounted) return;
//     Navigator.pushReplacementNamed(context, "/login");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 2,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         title: Row(
//           children: [
//             CircleAvatar(
//               backgroundColor: Colors.grey[400],
//               child: Text(
//                 _userName.isNotEmpty ? _userName[0].toUpperCase() : "X",
//                 style: const TextStyle(color: Colors.white),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   _userName.isNotEmpty ? "${_userName}'s Library" : "Library",
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   _userEmail,
//                   style: const TextStyle(fontSize: 12, color: Colors.grey),
//                 ),
//               ],
//             ),
//             const Spacer(),
//             IconButton(
//               icon: const Icon(Icons.logout, color: Colors.black),
//               onPressed: _logout,
//             ),
//           ],
//         ),
//       ),
//       body: _token == null
//           ? const Center(child: CircularProgressIndicator())
//           : FutureBuilder<List<Book>>(
//               future: _booksFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(
//                     child: Text(
//                       "Gagal memuat buku: ${snapshot.error.toString()}",
//                     ),
//                   );
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(child: Text("Belum ada buku tersedia"));
//                 }

//                 final books = snapshot.data!;
//                 return ListView.builder(
//                   padding: const EdgeInsets.all(16),
//                   itemCount: books.length,
//                   itemBuilder: (context, index) {
//                     final book = books[index];
//                     return Card(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       elevation: 3,
//                       margin: const EdgeInsets.symmetric(vertical: 8),
//                       child: ListTile(
//                         leading: book.coverUrl != null
//                             ? Image.network(
//                                 book.coverUrl!,
//                                 width: 50,
//                                 height: 70,
//                                 fit: BoxFit.cover,
//                               )
//                             : Container(
//                                 width: 50,
//                                 height: 70,
//                                 color: Colors.grey[300],
//                                 child: const Icon(
//                                   Icons.book,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                         title: Text(book.title),
//                         subtitle: Text(book.author ?? "Unknown author"),
//                         onTap: () {
//                           // Bisa tambahin detail page nanti
//                         },
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//     );
//   }
// }
