import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(NewsApp());
}

class NewsApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'News App',
        theme: ThemeData(
        primarySwatch: Colors.blue,
    ),
    home: MyHomePage(title:'TechCrunch News'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();


}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Article>> _getArticles() async {
    http.Response response = await http.get(
     Uri.parse("https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=a97cbcd6b09e4341964830e6f4b70820")
    );
    var jsonData = json.decode(response.body);

    List<Article> articles = [];

    for (var article in jsonData["articles"]) {
      Article newArticle = Article(article["author"], article["title"], article["description"],
          article["url"], article["urlToImage"]);
      articles.add(newArticle);
    }

    return articles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          child: FutureBuilder(
            future: _getArticles(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: Text("Loading..."),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            snapshot.data[index].urlToImage
                        ),
                      ),
                      title: Text(snapshot.data[index].title),
                      subtitle: Text(snapshot.data[index].description),
                    );
                  },
                );
              }
            },
          ),
        ));
  }
}

class Article {
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;

  Article(this.author, this.title, this.description, this.url, this.urlToImage);
}
