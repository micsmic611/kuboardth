
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kuboardverth/component/button.dart';
import 'package:kuboardverth/component/textfield.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key,required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //texteditcontroller
  final emailtextcontroller =TextEditingController();
  final passwordtextcontroller = TextEditingController();

  //signIn
  void SignIn() async {
    //show loading circle
    showDialog(context: context, builder: (context)=> const Center(child: CircularProgressIndicator(),
    ),
    );
    if (emailtextcontroller.text.isEmpty && passwordtextcontroller.text.isEmpty) {
      displayMessage("กรุณากรอกอีเมล และรหัสผ่าน");
      return;
    }
    // Check if email is empty
    if (emailtextcontroller.text.isEmpty) {
      displayMessage("กรุณากรอก อีเมล");
      return;
    }

    // Check if password is empty
    if (passwordtextcontroller.text.isEmpty) {
      displayMessage("กรุณากรอก รหัสผ่าน");
      return;
    }
    //try signin
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailtextcontroller.text,
          password: passwordtextcontroller.text);

      //pop loading circle
      if(context.mounted) Navigator.pop(context);
    }on FirebaseAuthException catch(e){
      //pop loading circle
      Navigator.pop(context);
      //display error message
        displayMessage(e.code);
    }
  }
  //display dialog message
  void displayMessage(String message){
    showDialog(context: context,
      builder: (context)=>AlertDialog(
        title: Text(message),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('asset/icon.png', width: 300, height: 250),
                  //logo
                  const SizedBox(height: 10,),
                  //welcome back message
                  Text("Welcome to Ku board",style:
                    TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),),
                  const SizedBox(height: 25,),
                  //email textfield
                  Mytextfield(
                      controller: emailtextcontroller,
                      hintText: 'Email',
                      obscureText: false),
                  const SizedBox(height: 10,),
              
                  //password textfield
                  Mytextfield(
                      controller: passwordtextcontroller,
                      hintText: 'password',
                      obscureText: true),
                  const SizedBox(height: 15,),
                  //signin button
                  MyButton(
                    onTap: SignIn,
                    text: 'Sign In',
                  ),
                  const SizedBox(height: 15,),
                  //goto register page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Not a member ??"),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text("Register now",style:
                      TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                      ),
                    ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

  }
}
