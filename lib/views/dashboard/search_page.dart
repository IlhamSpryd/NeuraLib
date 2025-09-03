import 'package:athena/views/book_detail_page.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<String> _results = [];

  void _onSearch(String query) {
    // sementara dummy data, nanti bisa ganti API integration
    final allBooks = [
      "Metode Penelitian Kuantitatif",
      "Young Adult: A untuk Amanda",
      "Belajar Machine Learning",
      "Flutter for Beginners",
      "Pemrograman Dart Lanjutan",
      "AI dan Robotika Masa Depan",
    ];

    setState(() {
      _results = allBooks
          .where((book) => book.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,
        title: TextField(
          controller: _controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintText: "Cari buku, video, atau audio...",
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
            border: InputBorder.none,
          ),
          onChanged: _onSearch,
        ),
      ),
      body: _results.isEmpty
          ? Center(
              child: Text(
                "Belum ada hasil pencarian",
                style: TextStyle(color: Colors.grey[400]),
              ),
            )
          : ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(
                    Icons.book,
                    color: Colors.deepPurpleAccent,
                  ),
                  title: Text(
                    _results[index],
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookDetailPage(
                          title: _results[index],
                          author: "Penulis Tidak Diketahui",
                          coverUrl:
                              "https://picsum.photos/200/300?random=$index",
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
