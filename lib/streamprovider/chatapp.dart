import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseOptions = FirebaseOptions(
  apiKey: "AIzaSyAK82et16mHOVl_UamCJDsGvmci9lwoQlI",
  authDomain: "chat-c2c47.firebaseapp.com",
  projectId: "chat-c2c47",
  storageBucket: "chat-c2c47.appspot.com",
  messagingSenderId: "853285394238",
  appId: "1:853285394238:web:a2a62daa56741fc7b27e6f",
  measurementId: "G-6XLG1V79W8",
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: firebaseOptions,
  ); // Initializing Firebase
  runApp(ProviderScope(child: ChatScreen()));
}

class ChatScreen extends ConsumerWidget {
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("Live Chat")),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('messages') // Firestore collection
                        .orderBy('timestamp') // Order messages by timestamp
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No messages yet."));
                  }

                  var messages = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      var message = messages[index];
                      return ListTile(
                        title: Text(message['text']),
                        subtitle: Text(message['user']),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(hintText: "Enter a message"),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      String message = messageController.text.trim();
                      if (message.isNotEmpty) {
                        // Add the message to Firestore
                        FirebaseFirestore.instance.collection('messages').add({
                          'text': message,
                          'user': 'User1', // Hardcoded user for simplicity
                          'timestamp': FieldValue.serverTimestamp(),
                        });
                        messageController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
