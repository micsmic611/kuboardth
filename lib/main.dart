import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kuboardverth/Page/loginpage.dart';
import 'package:kuboardverth/Page/register.dart';
import 'package:kuboardverth/auth/login0rregis.dart';
import 'package:kuboardverth/firebase_options.dart';
import 'package:kuboardverth/theme/darktheme.dart';
import 'package:kuboardverth/theme/lightrheme.dart';
import 'package:kuboardverth/theme/themeprovider.dart';
import 'package:provider/provider.dart';

import 'auth/auth.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);

  runApp( ChangeNotifierProvider(create: (context) => ThemeProvider(),
       child: Myapp(),),
      );
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: AuthPage(),
    );
  }
}
