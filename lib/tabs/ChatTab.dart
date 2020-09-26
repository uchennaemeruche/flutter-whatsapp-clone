import 'package:flutter/material.dart';
import 'package:whatsapp_clone/models/chat_model.dart';
import 'package:whatsapp_clone/screens/SelectContacts.dart';
import 'package:whatsapp_clone/widgets/ListItems.dart';

class ChatTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            ChatListItem chat = chatListItems[index];
            return ListItem(
              tab: 'chats',
              chat: chat,
              index: index,
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider();
          },
          itemCount: chatListItems.length),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return SelectContact();
        })),
        tooltip: 'Increment',
        child: Icon(
          Icons.chat,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).accentColor,
      ),
    );
  }
}
