import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_dustbin/screens/home_screen.dart';
import 'package:smart_dustbin/screens/login/login_screen.dart';

class NavigatePage extends StatefulWidget {
  static const String id = 'navigate-screen';

  const NavigatePage({Key? key}) : super(key: key);

  @override
  _NavigatePageState createState() => _NavigatePageState();
}

class _NavigatePageState extends State<NavigatePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, userSnapshot) {
        print("Stream Builder Called");
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          print("Stream Builder loading");
          return const CircularProgressIndicator();
        }
        if (userSnapshot.hasData) {
          print("Stream Builder hasdata");
          return const HomeScreen();
        }
        print("Stream Builder before data");
        return const LoginScreen();
      },
    );
  }
}
