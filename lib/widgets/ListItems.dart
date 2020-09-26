import 'package:flutter/material.dart';
import 'package:whatsapp_clone/models/chat_model.dart';
import 'package:whatsapp_clone/screens/ChatScreen.dart';
import 'package:whatsapp_clone/screens/StoryViewScreen.dart';

class ListItem extends StatefulWidget {

  final String tab;
  final ChatListItem chat;
  final int index;
  ListItem({this.tab, this.chat, this.index});

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {

  _buildListTile(){
    if(this.widget.tab == 'chats'){
      return ListTile(
        title: Text(
          widget.chat.personName,
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
          ),
        subtitle: Text(widget.chat.lastMessage),
        trailing: Text(
          widget.chat.date,
          style: TextStyle(
            
          ),
        ),
        leading: CircleAvatar(
          radius: 30.0,
          backgroundColor: Colors.grey,
          backgroundImage: AssetImage(widget.chat.profileUrl),
        ),
        onTap: () {
          Navigator.push(context, 
          MaterialPageRoute(
            builder: (BuildContext context) => ChatScreen(person: widget.chat,)
          ));
        },
      );
    }else if(widget.tab == 'status'){
      return ListTile(
        title: Text(
          widget.chat.personName,
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
          ),
        subtitle: Text(widget.chat.date),
        leading: CircleAvatar(
          radius: 30.0,
          backgroundColor: Colors.grey,
          backgroundImage: AssetImage(widget.chat.profileUrl),
        ),
        onTap: () {
          Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (BuildContext context) => StoryViewScreen()
          )
        );
        },
      );
    }else if(widget.tab == 'calls'){
      return ListTile(
        title: Text(
          widget.chat.personName,
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
          ),
        subtitle: Text(widget.chat.date),
        trailing: IconButton(
          icon: Icon(
            widget.index%3 == 0 ? Icons.call : Icons.videocam
          ),
          onPressed: () =>{},
          color: Theme.of(context).primaryColor,
        ),
        leading: CircleAvatar(
          radius: 30.0,
          backgroundColor: Colors.grey,
          backgroundImage: AssetImage(widget.chat.profileUrl),
        ),
        onTap: () => {},
      );
    }else if(widget.tab == 'contacts'){
      return ListTile(
        title: Text(
          widget.chat.personName,
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
          ),
        subtitle: Text(widget.chat.about),
        
        leading: CircleAvatar(
          radius: 30.0,
          backgroundColor: Colors.grey,
          backgroundImage: AssetImage(widget.chat.profileUrl),
        ),
        onTap: () {
          Navigator.push(context, 
          MaterialPageRoute(
            builder: (BuildContext context) => ChatScreen(person: widget.chat,)
          ));
        }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildListTile();
  }
}