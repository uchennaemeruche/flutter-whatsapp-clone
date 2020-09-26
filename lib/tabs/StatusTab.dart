import 'package:flutter/material.dart';
import 'package:whatsapp_clone/constants/colors.dart';
import 'package:whatsapp_clone/models/chat_model.dart';
import 'package:whatsapp_clone/screens/StoryViewScreen.dart';
import 'package:whatsapp_clone/widgets/ListItems.dart';

class StatusTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            child: ListTile(
              title: Text(
                'My Status',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text('Yesterday, 3:08 pm'),
              trailing: IconButton(
                icon: Icon(Icons.more_horiz),
                onPressed: () => {},
                color: primaryColor,
              ),
              leading: CircleAvatar(
                radius: 30.0,
                backgroundColor: Colors.grey,
                backgroundImage: AssetImage('assets/uche.jpg'),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => StoryViewScreen()));
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 10.0, left: 10.0),
            child: Divider(
              color: Colors.red,
              height: 2.0,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  ChatListItem chat = chatListItems[index];
                  return ListItem(
                    tab: 'status',
                    chat: chat,
                    index: index,
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
                itemCount: chatListItems.length),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        tooltip: 'Increment',
        child: Icon(Icons.camera_alt),
        backgroundColor: secondaryColor,
      ),
    );
  }
}
