import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../component/button.dart';
import '../component/textfield.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({Key? key, required this.onTap}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();
  final firstNameTextController = TextEditingController();
  final lastNameTextController = TextEditingController();
  final phoneTextController = TextEditingController();

  void signUp() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    if (emailTextController.text.isEmpty) {
      displayMessage("กรุณากรอก อีเมล");
      return;
    }
    if (passwordTextController.text.isEmpty) {
      displayMessage("กรุณากรอก password");
      return;
    }
    if (confirmPasswordTextController.text.isEmpty) {
      displayMessage("กรุณากรอก passwordอีกครั้ง");
      return;
    }
    if (firstNameTextController.text.isEmpty) {
      if(firstNameTextController.text.length > 25) {
      displayMessage("ชื่อ 25 ตัวอักษร");
      return;
    }
      displayMessage("กรุณากรอก ชื่อ");
      return;
    }

    if (lastNameTextController.text.isEmpty) {
      if(lastNameTextController.text.length > 30) {
        displayMessage("ชื่อ 30 ตัวอักษร");
        return;
      }
      displayMessage("กรุณากรอก นามสกุล");
      return;
    }


    if (passwordTextController.text != confirmPasswordTextController.text) {
      Navigator.pop(context);
      displayMessage("กรอกpasswordให้เหมือนกัน!!");
      return;
    }


    if (!isPhoneNumberValid(phoneTextController.text)) {
      Navigator.pop(context);
      displayMessage("เบอร์โทรไม่ถูกต้อง");
      return;
    }

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );

      FirebaseFirestore.instance.collection("Users").doc(userCredential.user!.email!).set({
        'email': emailTextController.text,
        'uid': userCredential.user!.uid,
        'username': emailTextController.text.split('@')[0],
        'bio': 'Empty bio...',
        'firstname': firstNameTextController.text,
        'lastname': lastNameTextController.text,
        'phone': phoneTextController.text,
      });

      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      displayMessage(e.code);
    }
  }

  bool isPhoneNumberValid(String phoneNumber) {
    RegExp regex = RegExp(r'^[0-9]{10}$');
    return regex.hasMatch(phoneNumber);
  }

  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
                  Text(
                    "Let's create an account",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Mytextfield(
                    controller: emailTextController,
                    hintText: 'Email',
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),
                  Mytextfield(
                    controller: passwordTextController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 15),
                  Mytextfield(
                    controller: confirmPasswordTextController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 15),
                  Mytextfield(
                    controller: firstNameTextController,
                    hintText: 'First Name',
                    obscureText: false,
                  ),
                  const SizedBox(height: 15),
                  Mytextfield(
                    controller: lastNameTextController,
                    hintText: 'Last Name',
                    obscureText: false,
                  ),
                  const SizedBox(height: 15),
                  Mytextfield(
                    controller: phoneTextController,
                    hintText: 'Phone Number',
                    obscureText: false,
                  ),
                  const SizedBox(height: 15),
                  MyButton(
                    onTap: signUp,
                    text: 'Sign Up',
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?"),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "Login now",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
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
