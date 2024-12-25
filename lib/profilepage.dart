import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/BlogPage.dart';
import 'package:flutter_auth/blogHome.dart';
import 'package:flutter_auth/main.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil Sayfası"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => BlogHomePage()),
                  (Route<dynamic> route) => true);
            },
          ),
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((result) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => HomePage()),
                      (Route<dynamic> route) => true);
                });
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => BlogPage()),
                (Route<dynamic> route) => true);
          }),
      body: Container(
        child: AllArticles(),
      ),
    );
  }
}

class AllArticles extends StatefulWidget {
  @override
  _AllArticlesState createState() => _AllArticlesState();
}

class _AllArticlesState extends State<AllArticles> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    Query userArticles = FirebaseFirestore.instance
        .collection("articles")
        .where("userId", isEqualTo: auth.currentUser?.uid);

    return StreamBuilder<QuerySnapshot>(
      stream: userArticles.snapshots(),
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
