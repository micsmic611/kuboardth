import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kuboardverth/component/likebutton.dart';

import 'likebutton.dart';

class WallNews extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final List<String> likes;

  const WallNews({
    Key? key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,
  }) : super(key: key);

  @override
  State<WallNews> createState() => _WallNewsState();
}

class _WallNewsState extends State<WallNews> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  late bool isLiked;

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    DocumentReference postRef =
    FirebaseFirestore.instance.collection('User News').doc(widget.postId);

    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.message,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 20),
          Row(
            children: [
              Column(
                children: [
                  LikeButton(
                    isliked: isLiked,
                    onTap: toggleLike,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.likes.length.toString(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
            ],
          ),
        ],
      ),
    );
  }
}
