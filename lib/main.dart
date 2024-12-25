import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/profilepage.dart';
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
      debugShowCheckedModeBanner: false,
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

  Future<void> login() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: userEmail.text, password: password.text)
        .then((user) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => ProfilePage()),
          (Route<dynamic> route) => false);
    }).whenComplete(() => print("Giriş yapıldı"));
  }

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
              SizedBox(
                height: 30.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
