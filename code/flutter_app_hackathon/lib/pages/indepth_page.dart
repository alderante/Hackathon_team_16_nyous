// Packages
// import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:redacted/redacted.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Widgets
import 'package:hackatron_2/chat/presentation/chat_bubble.dart';
import 'package:hackatron_2/chat/presentation/chat_provider.dart';

// Models
import 'package:hackatron_2/chat/model/message.dart';
import 'package:hackatron_2/database/model/database.dart';
import 'package:hackatron_2/trivia/model/trivia.dart';

/*
    Display a page where can be done questions about an argument
*/

class InDepthPage extends StatefulWidget {
  const InDepthPage({
    super.key,
  });

  @override
  State<InDepthPage> createState() => _InDepthPageState();
}

class _InDepthPageState extends State<InDepthPage> {
  late ChatProvider chatProvider;

  //* Remove all the messages and close the window
  void goBack() {
    chatProvider.clearMessages();
    Trivia.stop = false;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    chatProvider = context.watch<ChatProvider>();
    // //* Get the newsId by route argument
    // final String newsId = ModalRoute.of(context)!.settings.arguments as String;

    // log(newsId);
    //* User press/swipe BACK
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) async {
        if (!didPop) goBack(); // Action to perform on back pressed
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: SafeArea(
          child: Column(
            children: [
              //* TOP SECTION: Logo
              Image(image: AssetImage('assets/logo_transparent.png'), height: MediaQuery.of(context).size.height * 0.08),

              //* MIDDLE SECTION: Chat Panel
              Expanded(child: CardPanel()),

              //* USER INPUT BOX
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 20,
                  children: [
                    //* Back button
                    CircleAvatar(
                      radius: 28, // Adjust size
                      backgroundColor: Theme.of(context).colorScheme.onPrimary,
                      child: IconButton(
                        color: Theme.of(context).colorScheme.primary,
                        iconSize: 36,
                        onPressed: () async { goBack(); },
                        icon: Icon(Icons.video_collection_outlined),
                      ),
                    ),
                    //* Input box
                    !chatProvider.isLoading
                      ? ChatInputBox()
                      : SizedBox(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: Center(
                          //* Loading Indicator
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* Chat Input box for send messages */
class ChatInputBox extends StatelessWidget {
  ChatInputBox({super.key});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.65,
      child: TextFormField(
        controller: _controller,
        autofocus: false,
        obscureText: false,
        cursorColor: Theme.of(context).colorScheme.onPrimary,

        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        decoration: InputDecoration(
          suffixIconColor: Theme.of(context).colorScheme.onPrimary,
          prefixIconColor: Theme.of(context).colorScheme.onPrimary,
          hintText: 'Chiedimi qualcosa...',
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          
          // Border when focused
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(42.0),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 2.0,
            ),
          ),
          
          // Border when not focused
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(42.0),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 2.0,
            ),
          ),
          
          //* RIGHT -> Send button
          suffixIcon: IconButton(
            style: OutlinedButton.styleFrom(
              fixedSize: Size(56, 56),
              // side: BorderSide(
              //   width: 2.0,
              //   color: Theme.of(context).colorScheme.onPrimary
              // ),
            ),
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                final chatProvider = context.read<ChatProvider>();

                //* Add the body as first AI message
                if (Database.body != null && chatProvider.messages.isEmpty) {
                  chatProvider.addMessage(Database.body!);
                }

                //* Add user message and get a response from AI
                chatProvider.sendMessage(_controller.text, requestMessage: Database.body);

                //* Clear the TextField
                _controller.clear();
              }
            },
            icon: Icon(Icons.send),
          ),
        ),
      ),
    );
  }
}

/* Styled Chat using ChatMessagesPanel */
class CardPanel extends StatelessWidget {
  const CardPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),           // 42
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        height: 500,
        width: MediaQuery.of(context).size.width * 1.0,                         // 0.85
        padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 12.0),         // h:24 | v:12
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(42),
          color: Colors.transparent,
          // border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
        ),
        child: QuestionsPanel(),
      ),
    );
  }
}

class QuestionsPanel extends StatelessWidget {
  const QuestionsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    //* Get the newsId by route argument
    final String newsId = Database.newsId!;

    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        // Empty
        if (chatProvider.messages.isEmpty) {
          return Column(
            children: [
              //* News description
              Expanded(
                child: FutureBuilder<String>(
                  //* Get the news body from DB
                  future: Database.getBodyById(newsId: newsId),
                  builder: (BuildContext context, snapshot) {
                    //* Error/Data not loaded Management
                    if (!snapshot.hasData
                      || snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    }

                    //* News body
                    return ChatBubblePlus(message: Message(
                      content: snapshot.data ?? '',
                      isUser: false,
                      timestamp: DateTime.now(),
                    ));

                    // Old News body
                    // return Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    //   child: SelectableText(
                    //     snapshot.data ?? '',
                    //     style: TextStyle(fontSize: 20),
                    //   ),
                    // );
                  }
                ),
              ),

              // Questions
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                  .collection('hack_indepth')
                  .where('hack_news_id', isEqualTo: newsId).snapshots(),

                builder: (context, snapshot) {
                  // Error management
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      //* Loading Indicator
                      child: SizedBox(
                        height: 120,
                        width: 120,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    );
                  }

                  List<String> questions = List<String>.from(snapshot.data!.docs.first['questions'] ?? []);

                  return Column(
                    spacing: 6,
                    children: [
                      questions.isNotEmpty ? QuestionButton(question: questions[0]) : Container(),
                      questions.length > 1 ? QuestionButton(question: questions[1]) : Container(),
                      questions.length > 2 ? QuestionButton(question: questions[2]) : Container(),
                      questions.length > 3 ? QuestionButton(question: questions[3]) : Container(),
                    ],
                  );

                }
              ),

              // Testing for adapt the number of questions
              // return ListView.builder(
              //   prototypeItem: QuestionButton(question: ''),
              //   itemCount: questions.length,
              //   itemBuilder: (context, index) {
              //     return QuestionButton(question: questions[index]);
              //   }
              // );
            ],
          );
        }

        // Chat messages
        return ListView.builder(
          // controller: _listScrollController,
          itemCount: chatProvider.messages.length,
          itemBuilder: (context, index) {
            // Get each message
            final message = chatProvider.messages[index];
                  
            // Return message
            return ChatBubblePlus(message: message);

            // Old (Created)
            // return ChatBubble(message: message);
          },
        );
      },
    );
  }
}

class QuestionButton extends StatelessWidget {
  const QuestionButton({
    super.key,
    required this.question,
  });

  final String question;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.0),
          boxShadow: [BoxShadow(offset: Offset(3, 3), color: Theme.of(context).shadowColor)],
        ),
        child: TextButton(
          style: Theme.of(context).textButtonTheme.style!.copyWith(
            minimumSize: WidgetStatePropertyAll(Size(double.infinity, 52)),
            fixedSize: WidgetStatePropertyAll(Size(double.infinity, 52)),
          ),
          onPressed: () async {
            final ChatProvider chatProvider = context.read<ChatProvider>();

            //* Add the body as first AI message
            if (Database.body != null && chatProvider.messages.isEmpty) {
              chatProvider.addMessage(Database.body!);
            }

            //* Add question to messages and get a response from AI
            chatProvider.sendMessage(question, requestMessage: Database.body);
          },
          child: Text(question,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14)
          ),
        ),
      ),
    );
  }
}

/* Chat Messages styled with ChatBubble */
// class ChatMessagesPanel extends StatelessWidget {
//   ChatMessagesPanel({
//     super.key,
//   });

//   final ScrollController _listScrollController = ScrollController();

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ChatProvider>(
//       builder: (context, chatProvider, child) {
//         // Empty
//         if (chatProvider.messages.isEmpty) {
//           return const Center(
//             child: Text('Start a convo...'),
//           );
//         }
                  
//         // Chat messages
//         return ListView.builder(
//           controller: _listScrollController,
//           itemCount: chatProvider.messages.length,
//           itemBuilder: (context, index) {
//             // Get each message
//             final message = chatProvider.messages[index];
                  
//             // Return message
//             return ChatBubble(message: message);
//           },
//         );
//       },
//     );
//   }
// }
