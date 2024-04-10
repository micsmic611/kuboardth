

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kuboardverth/auth/auth_service.dart';

import 'chatpage.dart';

class HomechatPage extends StatefulWidget {
  const HomechatPage({super.key});

  @override
  State<HomechatPage> createState() => _HomePageState();
}

class _HomePageState extends State<HomechatPage> {
  //insatance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //sgin user out
  void  signOut(){
    //get auth Service
    final authService = Provider.of<AuthService>(context, listen: false);

    authService.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Theme.of(context).colorScheme.inverseSurface,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.surface),

        title: Text('Chat Page',style: TextStyle(color: Colors.white),
        ),
        actions: [
        ],
      ),
      body: _buildUserList(),
    );
  }

  //build a list of users except for the current logged in user
  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection('Users').snapshots(),
      builder: (context, snapshot){
        if (snapshot.hasError){
          return const Text('Error');
        }

        if(snapshot.connectionState == ConnectionState.waiting){
          return const Text('Loading.....');
        }

        return ListView(
          children: snapshot.data!.docs.map<Widget>((doc) => _buildUserListItem(doc))
              .toList(),
        );

      },
    );
  }

  // build individdual user list items
  Widget _buildUserListItem(DocumentSnapshot document){
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    //display all user  except current user
    if(_auth.currentUser!.email != data['email']){
      return ListTile(
        title: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: Text(data['username'])),
        onTap: () {
          //pass the clicked user's UID to the chat page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverUserEmail: data['email'],
                receiverUserID: data['uid'],
              ),
            ),
          );
        },
      );
    } else {
      //return empty container
      return Container();
    }
  }
}
