import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BlogHomePage extends StatelessWidget {
  const BlogHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Makaleler ana sayfası"),
        backgroundColor: Colors.green,
      ),
      body: AllArticles(),
    );
  }
}

class AllArticles extends StatefulWidget {
  @override
  _AllArticlesState createState() => _AllArticlesState();
}

class _AllArticlesState extends State<AllArticles> {
  final Stream<QuerySnapshot> _allblogs =
      FirebaseFirestore.instance.collection('articles').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _allblogs,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return ListTile(
              title: Text(data['title']),
              subtitle: Text(data['content']),
            );
          }).toList(),
        );
      },
    );
  }
}
