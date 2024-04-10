import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kuboardverth/Page/ProfilePage.dart';
import 'package:kuboardverth/Page/groupchat/group.dart';
import 'package:kuboardverth/Page/setting.dart';
import 'package:kuboardverth/Page/showchat.dart';
import 'package:kuboardverth/component/textfield.dart';
import 'package:kuboardverth/component/wallpost.dart';

import '../component/drawer.dart';
import 'newpage.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //user
  final currentUser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();
  void signOut(){
    FirebaseAuth.instance.signOut();
  }

  //post message
  void postMessage(){
//only post if there something in the textfield
  if(textController.text.isNotEmpty){
    //store in firebase
    FirebaseFirestore.instance.collection("User Posts").add({
    'UserEmail':currentUser.email,
    'Message':textController.text,
    'TimeStamp':Timestamp.now(),
      'Likes':[],
    });
  }
  //clear the textfield
    setState(() {
      textController.clear();
    });
  }

  //navigate to profile
  void gotoProfilePage(){
    //pop menu drawer
    Navigator.pop(context);

    //go to profile page
    Navigator.push(
      context,
      MaterialPageRoute(
      builder: (context)=> const ProfilePage(),
    ),
    );
  }
  void gotoChatPage(){
    //pop menu drawer
    Navigator.pop(context);

    //go to profile page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context)=>  HomechatPage(),
      ),
    );
  }
  void gotosettingPage(){
    //pop menu drawer
    Navigator.pop(context);

    //go to profile page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context)=> const SettingPage(),
      ),
    );
  }
  void gotoNewpage(){
    //pop menu drawer
    Navigator.pop(context);

    //go to profile page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context)=> pagenew(),
      ),
    );
  }
  void gotoGrouppage(){
    //pop menu drawer
    Navigator.pop(context);

    //go to profile page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context)=> GroupChatHomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(title: Text("ku board",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.grey[900],

        iconTheme: const IconThemeData(color: Colors.white),
      ),

      drawer: MyDrawer(
          onProfileTap:gotoProfilePage,
          onSignOut:signOut,
          onChataTap: gotoChatPage,
          onSettingTap:gotosettingPage,
          onNewpage: gotoNewpage,
          onGroupTap: gotoGrouppage,
      ),
      body: Center(
        child: Column(
          children: [
            //the wall
            Expanded(
              child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("User Posts").
              orderBy("TimeStamp",descending: false)
                .snapshots(),
                builder: (context,snapshot){
                if(snapshot.hasData)
                  {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context,index){

                          //get message
                      final post =snapshot.data!.docs[index];
                      return WallPost(
                          message: post['Message'],
                          user: post['UserEmail'],
                          postId: post.id,
                          likes:List<String>.from(post['Likes']??[]),
                      );
                    },
                    );
                  }else if(snapshot.hasError){
                  return Center(child: Text('ERROR:${snapshot.hasError}'),
                  );
                }
                return const Center(child: CircularProgressIndicator(),
                );
                },
            ),
            ),
            //post message
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(children: [
                  //textfield
                Expanded(
                  child:
                  Mytextfield(
                  controller: textController,
                    hintText: 'write something on wall',
                    obscureText: false,
                ),

                ),
                //post
                IconButton(onPressed: postMessage, icon: const Icon(Icons.arrow_circle_up))
              ],
              ),
            ),
            //login as
            Text("logged in as:" + currentUser.email!,
            style: TextStyle(color: Colors.white),),
          ],
        ),
      ),
    );
  }
}
