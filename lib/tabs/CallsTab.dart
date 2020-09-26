import 'package:flutter/material.dart';
import 'package:whatsapp_clone/constants/colors.dart';
import 'package:whatsapp_clone/models/chat_model.dart';
import 'package:whatsapp_clone/widgets/ListItems.dart';

class CallsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            ChatListItem chat = chatListItems[index];
            return ListItem(
              tab: 'calls',
              chat: chat,
              index: index,
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider();
          },
          itemCount: chatListItems.length),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        tooltip: 'Increment',
        child: Icon(Icons.add_call),
        backgroundColor: secondaryColor,
      ),
    );
  }
}
