// Packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';

// Model
import 'package:hackatron_2/chat/model/message.dart';

// Clipper
// import 'package:hackatron_2/chat/presentation/draw_triangle.dart';

class ChatBubblePlus extends StatelessWidget {
  final Message message;

  const ChatBubblePlus({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: BubbleSpecialOne(
        text: message.content,
        color: message.isUser ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
        tail: true,
        isSender: message.isUser,
        textStyle: TextStyle(
          color: message.isUser ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSecondary,
          fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
        ),
      ),
    );
  }

  Future<bool> copyToClipboard(String content, BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: content));
    return true;
  }
}

class ChatBubble extends StatelessWidget {
  final Message message;

  const ChatBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: message.isUser ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
          // boxShadow: [BoxShadow(
          //   color: message.isUser ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
          //   offset: Offset(message.isUser ? 5 : -5, 0),
          // )]
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            color: message.isUser ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSecondary,
          ),
          child: message.isUser
          ? SelectableText(
            message.content,
            cursorColor: Theme.of(context).colorScheme.onPrimary,
          )
          : AnimatedTextKit(
            isRepeatingAnimation: false,
            repeatForever: false,
            displayFullTextOnTap: true,
            totalRepeatCount: 1,
            onTap: () { copyToClipboard(message.content, context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Message copied to clipboard")));
            },
            animatedTexts: [
              TyperAnimatedText(message.content.trim()),
            ]
          )
        ),
      ),
    );
  }

  Future<bool> copyToClipboard(String content, BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: content));
    return true;
  }
}

//* Triangle
// Positioned(
//   bottom: 0,
//   right: message.isUser ? 0 : null,
//   left: message.isUser ? null : 0,
  
//   child: ClipPath(
//     clipper: TriangleClipper(),
//     child: Container(
//       // color: message.isUser ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
//       color: Colors.red,
//       width: 20,
//       height: 20,
//     ),
//   ),
// ),
