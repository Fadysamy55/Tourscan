import 'package:flutter/material.dart';
import 'package:test_ali/Screens/ChatScreen.dart';
import 'ChatBotScreen.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final List<Map<String, String>> chats = [
    {"name": "Alice", "lastMessage": "Hey! How are you?"},
    {"name": "Bob", "lastMessage": "Let's meet tomorrow."},
    {"name": "Charlie", "lastMessage": "Did you finish the project?"},
    {"name": "David", "lastMessage": "Happy Birthday!"},
    {"name": "Foda", "lastMessage": "Let's meet tomorrow."},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          'Chats',
          style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(chats[index]["name"]!, style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(
              chats[index]["lastMessage"]!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.brown[300],
              child: Text(
                chats[index]["name"]![0].toUpperCase(),
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(currentUser: 'alic', chatPartner: 'Bebo')), // تمرير اسم المستخدم
                );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatBotScreen()));
        },
        backgroundColor: Colors.brown,
        child: Icon(Icons.chat, color: Colors.white),
      ),
    );
  }
}
