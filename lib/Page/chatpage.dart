

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kuboardverth/component/chatbubble.dart';
import 'package:kuboardverth/component/my_text_field.dart';
import 'package:kuboardverth/auth/chatservice.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;
  const ChatPage({
    super.key,
    required this.receiverUserEmail,
    required this.receiverUserID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messsageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final co =5;
  void  sendMessage() async{
    //only send message if there is something to send
    if(_messsageController.text.isNotEmpty){
      await _chatService.sendMessages(
          widget.receiverUserID, _messsageController.text);
      // clear the text controller after sending the message
    }
  }
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    //add listener to focus node
    myFocusNode.addListener(() {
      if(myFocusNode.hasFocus){
        //cause  a delay so that the keyboard has time to show up
        //them the amount of remaining space will be calculated,
        //then scroll down
        Future.delayed(const Duration(milliseconds: 500),() => scrollDown(),
        );
      }
    });

    // wait  a bit for listview to be built, then scroll to buttom
    Future.delayed(
      const Duration(milliseconds: 500),
          () => scrollDown(),
    );


  }
  @override
  void dispose() {
    myFocusNode.dispose();
    _messsageController.dispose();
    super.dispose();
  }

  //scroll controller
  final ScrollController _scrollController = ScrollController();
  void scrollDown(){
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiverUserEmail,
        style: TextStyle(color: Colors.white),),
        backgroundColor:Theme.of(context).colorScheme.inverseSurface,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.surface),
      ),
      body: Column(
        children: [
          //message
          Expanded(
            child: _buildMessageList(),
          ),

          //user input
          _buildMessageInput(),

          const SizedBox(height: 25),
        ],
      ),
    );
  }

  //build message list
  Widget _buildMessageList(){
    return StreamBuilder(
      stream: _chatService.getMessages(
          widget.receiverUserID,
          _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot){
        if(snapshot.hasError) {
          return Text('Error' + snapshot.error.toString());
        }

        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading..');
        }

        return ListView(
            controller: _scrollController,
          children : snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot document){
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    //align the messages to the right if the sender is the current user, otherwise to the left
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Text(data['senderEmail']),
            const SizedBox(height: 5,),
            ChatBubble(message: data['message']),
          ],
        ),
      ),
    );
  }
  //build message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [

          //textfield
          Expanded(
            child: MyTextField(
              controller: _messsageController,
              hintText: 'Enter Message',
              obscureText: false,
              focusNode: myFocusNode,
            ),
          ),
          //send button
          IconButton(onPressed:
          sendMessage,
            icon: const Icon(
                Icons.arrow_upward,
                size: 40
            ),
          )
        ],
      ),
    );
  }

}
