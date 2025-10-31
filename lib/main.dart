import 'package:flutter/material.dart';
import 'package:tgsprak4/api_service.dart';
import 'package:tgsprak4/article_model.dart';

void main() {
  runApp(const BeritaApp());
}

class BeritaApp extends StatelessWidget {
  const BeritaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Aplikasi Berita",
      debugShowCheckedModeBanner: false,
      home: BeritaScreen(),
    );
  }
}

class BeritaScreen extends StatefulWidget {
  const BeritaScreen({super.key});

  @override
  State<BeritaScreen> createState() => _BeritaScreenState();
}

class _BeritaScreenState extends State<BeritaScreen> {
  late Future<List<Article>> _articlesFuture;
  @override
  void initState() {
    super.initState();
    _articlesFuture = ApiService().fetchArticles();
  }

  Future<void> _refreshArticles() async {
    setState(() {
      _articlesFuture = ApiService().fetchArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Berita terbaru")),
      body: RefreshIndicator(
        onRefresh: _refreshArticles,
        child: FutureBuilder<List<Article>>(
          future: _articlesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error : ${snapshot.error}'));
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final articles = snapshot.data!;
              return ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];
                  return Card(
                    margin: EdgeInsets.all(10),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (article.urlToImage != null)
                            Image.network(
                              article.urlToImage!,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.image_not_supported,
                                  size: 50,
                                );
                              },
                            ),
                          SizedBox(height: 10),
                          Text(article.title!),
                          SizedBox(height: 10),
                          Text(article.description! ?? 'Tidak ada deskripsi'),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text("Tidak ada berita"));
            }
          },
        ),
      ),
    );
  }
}
