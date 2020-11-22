import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String username;
  final bool isMe;
  final String userImage;

  const MessageBubble({
    Key key,
    this.message,
    this.username,
    this.isMe,
    this.userImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Stack(
          overflow: Overflow.visible,
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 200),
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 8,
              ),
              decoration: BoxDecoration(
                color: isMe ? Colors.grey[300] : theme.accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: !isMe ? Radius.zero : const Radius.circular(12),
                  bottomRight: isMe ? Radius.zero : const Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isMe
                          ? Colors.black
                          : theme.accentTextTheme.title.color,
                    ),
                  ),
                  Text(
                    message,
                    textAlign: isMe ? TextAlign.right : TextAlign.left,
                    style: TextStyle(
                      color: isMe
                          ? Colors.black
                          : theme.accentTextTheme.title.color,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: !isMe ? -15 : null,
              left: isMe ? -15 : null,
              top: -5,
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(userImage),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
