import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();
  var _message = '';

  void _onChanged(String newValue) {
    setState(() {
      _message = newValue.trim();
    });
  }

  void _onPressSend() async {
    FocusScope.of(context).unfocus();

    final user = await FirebaseAuth.instance.currentUser();
    final userData =
        await Firestore.instance.collection("users").document(user.uid).get();

    print(user.uid);

    Firestore.instance.collection("chat").add({
      "text": _message,
      "createdAt": Timestamp.now(),
      "userId": user.uid,
      "username": userData["username"],
      "userImage": userData["image_url"],
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            decoration: InputDecoration(labelText: "Send a message"),
            onChanged: _onChanged,
            autocorrect: true,
            enableSuggestions: true,
          ),
        ),
        IconButton(
          color: theme.primaryColor,
          icon: Icon(Icons.send),
          onPressed: _message.isNotEmpty ? _onPressSend : null,
        )
      ]),
    );
  }
}
