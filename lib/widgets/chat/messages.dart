import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, userSs) {
        if (userSs.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return StreamBuilder(
          stream: Firestore.instance
              .collection("chat")
              .orderBy("createdAt")
              .snapshots(),
          builder: (ctx, chatSs) {
            if (chatSs.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            final chatDocs = chatSs.data.documents;
            return ListView.builder(
              // reverse: true,
              itemCount: chatDocs.length,
              itemBuilder: (ctx, i) => MessageBubble(
                key: ValueKey(chatDocs[i].documentID),
                message: chatDocs[i]["text"],
                isMe: chatDocs[i]["userId"] == userSs.data.uid,
                username: chatDocs[i]["username"],
                userImage: chatDocs[i]["userImage"],
              ),
            );
          },
        );
      },
    );
  }
}
