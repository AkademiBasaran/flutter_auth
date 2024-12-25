import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  TextEditingController docId = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  var responseTitle = "";
  var responseContent = "";

  getArticle() {
    FirebaseFirestore.instance
        .collection("articles")
        .doc(docId.text)
        .get()
        .then((response) {
      if (response.data() != null) {
        setState(() {
          responseTitle = response.data()?['title'] ?? "";
          responseContent = response.data()?['content'] ?? "";
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Makale bulunamadı")));
      }
    });
  }

  addArticle() {
    FirebaseFirestore.instance
        .collection("articles")
        .doc(title.text)
        .set(<String, dynamic>{
      'userId': auth.currentUser?.uid,    
      'title': title.text,
      'content': content.text
    }).whenComplete(() {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Makale başarıyla eklendi")));
    });
  }

  updateArticle() {
    FirebaseFirestore.instance
        .collection("articles")
        .doc(docId.text)
        .update(<String, dynamic>{
      'title': title.text,
      'content': content.text
    }).whenComplete(() {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Makale başarıyla güncellendi")));
    });
  }

  deleteArticle() {
    FirebaseFirestore.instance
        .collection("articles")
        .doc(docId.text)
        .delete()
        .whenComplete(() {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Makale başarıyla silindi")));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Blog Sayfası"),
        backgroundColor: Color.fromARGB(255, 50, 214, 52),
      ),
      body: Container(
        margin: EdgeInsets.all(50),
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: docId,
                decoration: InputDecoration(labelText: "Dokuman Adı"),
              ),
              TextField(
                controller: title,
                decoration: InputDecoration(labelText: "Başlık"),
              ),
              TextField(
                controller: content,
                decoration: InputDecoration(labelText: "İçerik"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: addArticle, child: Text("Ekle")),
                  ElevatedButton(
                      onPressed: updateArticle, child: Text("Güncelle")),
                  ElevatedButton(onPressed: deleteArticle, child: Text("Sil")),
                  ElevatedButton(onPressed: getArticle, child: Text("Getir")),
                ],
              ),
              ListTile(
                title: Text(responseTitle),
                subtitle: Text(responseContent),
              )
            ],
          ),
        ),
      ),
    );
  }
}
