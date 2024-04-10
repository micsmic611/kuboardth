
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kuboardverth/component/deletebutton.dart';
import 'package:kuboardverth/component/likebutton.dart';
class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final List<String> likes;
  const WallPost({
    super.key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,

  });

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {

  //user
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isliked = false;
  //comment

  @override
  void initState() {

    super.initState();
    isliked = widget.likes.contains(currentUser.email);
  }

  //toggle like unlike
  void toggleLike(){
    setState(() {
      isliked = !isliked;
    });
    //access the document is firebase
    DocumentReference postRef =FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

    if(isliked){
      //if the post is liked add the user's email to the 'likes' field
      postRef.update({
        'Likes':FieldValue.arrayUnion([currentUser.email])
      });
    }else{
      //if the post is now unliked,remove the user's email from the 'like
    postRef.update({
      'Likes':FieldValue.arrayRemove([currentUser.email])
    });
    }
  }



//delete a post
  void deletePost () {
    //show a dialog box asking for confirmation before delete the post
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Post"),
        content: const Text("Are you sure you want to delete this post?"),
        actions: [
          //CANCEL BUTTON
          TextButton(onPressed: () =>  Navigator.pop(context),
              child: const Text("Cancel"),
          ),

          //DELETE BUTTON
          TextButton(onPressed: () async {
            //delete the comments from firestore first
            // (if you only delete the post ,the comments will still be stored in firestore)
            final commentDocs = await FirebaseFirestore.instance
                .collection("User Posts")
                .doc(widget.postId)
                .collection("Comments")
                .get();
            for (var doc in commentDocs.docs) {
              await FirebaseFirestore.instance
                  .collection("User Posts")
                  .doc(widget.postId)
                  .collection("Comments")
                  .doc(doc.id)
                  .delete();
            }

            // them delete the post
            FirebaseFirestore.instance
            .collection("User Posts")
            .doc(widget.postId)
            .delete()
            .then((value) => print("post deleted"))
            .catchError((error)=> print("failed to delete post: $error"));

            //dismiss the dialog
            Navigator.pop(context);
          },
            child: const Text("Delete"),
          ),
        ],
    ),
    );
  }

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(top: 25,left: 25,right: 25),
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //wallpost
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              //group of text (message + email
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //user
                  Text(widget.user,style: TextStyle(color:Theme.of(context).colorScheme.tertiary,fontWeight: FontWeight.bold,),),
                  const SizedBox(height: 5),
                  //message
                  Text(widget.message,style: TextStyle(color:Theme.of(context).colorScheme.tertiary),),

                ],
              ),

              //delete button
              if (widget.user == currentUser.email)
                DeleteButton(onTap: deletePost),
            ],
          ),
          const SizedBox(width: 20,),
          //button
          Row(
            children: [
              //like
              Column(
                children: [
                  //like button
                  LikeButton(
                    isliked: isliked,
                    onTap: toggleLike,
                  ),
                  const SizedBox(height: 5,),
                  //like count
                  Text(widget.likes.length.toString(),
                    style:  TextStyle(color: Theme.of(context).colorScheme.background),
                  ),
                ],
              ),
              const SizedBox(width: 10,),

            ],
          ),


        ],
      ),
    );
  }
}
