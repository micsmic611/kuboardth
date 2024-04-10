import 'package:flutter/material.dart';
import 'package:kuboardverth/Page/loginpage.dart';
import 'package:kuboardverth/Page/register.dart';
class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  //initial .show the login page
  bool showloginPage = true;

  //toggle between login or regispage
  void togglePages(){
    setState(() {
      showloginPage =!showloginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showloginPage){
      return LoginPage(onTap: togglePages);
    }else{
      return RegisterPage(onTap: togglePages);
    }
  }
}
