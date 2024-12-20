import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController userEmail = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> register() async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: userEmail.text, password: password.text)
        .then((response) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(userEmail.text)
          .set({'userEmail': userEmail.text, 'userPassword': password.text});
    }).whenComplete(() {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Kullanıcı Firestore veritabanına başarıyla eklendi")));
    }).whenComplete(() {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Kullanıcı Firebase'e başarıyla eklendi")));
    });
    
  }

  login() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(40),
        child: Center(
          child: Column(
            children: [
              TextFormField(
                controller: userEmail,
                decoration: InputDecoration(label: Text("Email Adresi")),
              ),
              TextFormField(
                controller: password,
                decoration: InputDecoration(label: Text("Şifre")),
              ),
              Row(
                children: [
                  ElevatedButton(onPressed: register, child: Text("Kayıt Ol")),
                  ElevatedButton(onPressed: login, child: Text("Giriş Yap")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
