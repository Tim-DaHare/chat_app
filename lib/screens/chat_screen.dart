import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../widgets/chat/messages.dart';
import '../widgets/chat/new_message.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void _onPressDropDownItem(String itemId) {
    if (itemId == "Logout") FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    super.initState();

    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(
      onMessage: (message) {
        print(message);
        return;
      },
      onLaunch: (message) {
        print(message);
        return;
      },
      onResume: (message) {
        print(message);
        return;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Chat"),
        actions: [
          DropdownButton(
              underline: Container(),
              icon: Icon(
                Icons.more_vert,
                color: theme.primaryIconTheme.color,
              ),
              onChanged: _onPressDropDownItem,
              items: [
                DropdownMenuItem(
                  value: "Logout",
                  child: Container(
                    child: Row(children: [
                      Icon(Icons.exit_to_app),
                      SizedBox(width: 8),
                      Text("Logout"),
                    ]),
                  ),
                )
              ])
        ],
      ),
      body: Container(
        child: Column(children: [
          Expanded(child: Messages()),
          NewMessage(),
        ]),
      ),
    );
  }
}
