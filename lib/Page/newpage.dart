import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kuboardverth/component/wallnew.dart';

import '../component/textfield.dart';
import '../component/wallpost.dart';
class pagenew extends StatefulWidget {
  const pagenew({
    super.key
  });

  @override
  State<pagenew> createState() => _pagenewState();
}

class _pagenewState extends State<pagenew> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser!;
  void signOut() {
    FirebaseAuth.instance.signOut();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("new",
        style: TextStyle(color: Theme.of(context).colorScheme.surface),
        ),
        backgroundColor:  Theme.of(context).colorScheme.inverseSurface,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.surface),
      ),

      body: Center(
        child: Column(
            children: [
              SizedBox(height: 15,),
              Text(
                "ข่าวจากมหาวิทยาลัยเกษตรศาสตร์",
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
        //the wall
        Expanded(
        child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("User News").snapshots(),
        /*orderBy("TimeStamp",descending: false)
            .snapshots(),*/
        builder: (context,snapshot){
          if(snapshot.hasData)
          {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context,index){

                //get message
                final post =snapshot.data!.docs[index];
                return WallNews(
                  user: post['name'],
                  message: post['Message'],
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

            ],
        ),
      ),
    );
  }
}



