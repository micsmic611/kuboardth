import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kuboardverth/auth/login0rregis.dart';

import '../Page/Homepage.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
            //user is login
          if(snapshot.hasData){
            return const HomePage();
          }
          //user is not login
          else{
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
