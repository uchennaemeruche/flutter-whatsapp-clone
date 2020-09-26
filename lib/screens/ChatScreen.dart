import 'package:flutter/material.dart';
import 'package:whatsapp_clone/constants/colors.dart';
import 'package:whatsapp_clone/models/chat_message_model.dart';
import 'package:whatsapp_clone/models/chat_model.dart';
import 'package:whatsapp_clone/widgets/clipRect.dart';

class ChatScreen extends StatelessWidget {
  final ChatListItem person;

  ChatScreen({this.person});

  // Widget renderChatMessage(ChatMessage message, int currentIndex, r){
  //   return Column(
  //     children: <Widget>[
  //       SizedBox(height: 8.0,),
  //       Align(
  //         alignment: message.isSentByMe ? Alignment.topRight : Alignment.topLeft,
  //         child: Container(
  //           margin: EdgeInsets.symmetric(
  //             horizontal:20.0, 
  //             vertical: 0.0
  //           ),
  //           child: ClipPath(
  //             clipper: ClipRThread(r),
  //             child: ClipRRect(
  //               borderRadius: BorderRadius.all(Radius.circular(r)),
  //                 child: Container(
  //                   padding: EdgeInsets.fromLTRB(8.0 + 2 * r, 8.0 , 8.0, 8.0),
  //                   decoration: BoxDecoration(
  //                     color: message.isSentByMe ? lightGreenColor : Colors.white,
  //                     boxShadow: [
  //                       BoxShadow(
  //                         blurRadius: 2,
  //                         color: Color(0x22000000),
  //                         offset: Offset(1,2)
  //                       )
  //                     ],
  //                   ),

  //                   child: Text(
  //                     message.message,
  //                     style: TextStyle(fontSize: 16.0),
  //                   ),
  //                 )
  //             ),
  //           ),
  //         ),
  //       )
  //     ],
  //   );
  // }

    Widget renderChatMessage(ChatMessage message, int currentIndex, r, context){
    return Column(
      children: <Widget>[
        SizedBox(height: 8.0,),
        Align(
          alignment: message.isSentByMe ? Alignment.topRight : Alignment.topLeft,
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal:20.0, 
              vertical: 0.0
            ),
            child: Stack(
              overflow: Overflow.visible,
               children: <Widget>[
                  ClipPath(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(r)),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(8.0 + 2 * r, 8.0 , 8.0, 8.0),
                          decoration: BoxDecoration(
                            color: message.isSentByMe ? Theme.of(context).backgroundColor : Theme.of(context).secondaryHeaderColor,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 2,
                                color: Color(0x22000000),
                                offset: Offset(1,2)
                              )
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(5.0))
                          ),

                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Flexible(
                               child: Text(
                                  message.message,
                                  style: TextStyle(fontSize: 16.0),
                                  softWrap: true,
                                ),
                              ),
                              SizedBox(width: 7.0,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    message.date,
                                    style: TextStyle(
                                      fontSize: 10.0, 
                                      
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                    ),
                  ),
                  message.isSentByMe 
                    ? Positioned(
                        right: -10,
                        top: 0,
                        child: ClipPath(
                          clipper: TriangleClipper(),
                          child: Container(
                            height: 10.0,
                            width: 30.0,
                            color: Theme.of(context).backgroundColor,
                          ),
                        ),
                      )
                    : Positioned(
                        left: -10,
                        top: 0,
                        child: ClipPath(
                          clipper: TriangleClipper(),
                          child: Container(
                            height: 10.0,
                            width: 30.0,
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                        ),
                      )

               ],           
            ),
          ),
        )
      ],
    );
  }

  // Widget renderTextBox(){
  //   return Container(
  //     margin: EdgeInsets.only(bottom:20.0, left:10.0, right:10.0),
  //     child: Row(
  //       children: <Widget>[
  //         Flexible(
  //           child: TextField(
  //             decoration: InputDecoration.collapsed(hintText: "Your Message Here"),
  //           ),
  //         ),
  //         IconButton(
  //           icon: Icon(Icons.attach_file),
  //           onPressed: () =>{},
  //         )
  //       ],
  //     ),
  //   );
  // }
  final roundedContainer = () => ClipRRect(
    borderRadius: BorderRadius.circular(20.0),
    child: Container(
      color: Colors.white,
      child: Row(
        children: <Widget>[
          SizedBox(width:8.0),
          Icon(Icons.insert_emoticon, size: 30.0, color: Colors.grey),
          SizedBox(width: 8.0,),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText:  "Type a message",
                border: InputBorder.none
              ),
            ),
          ),
          Icon(Icons.attach_file,
          size: 30.0, color: Colors.grey,),
          SizedBox(width: 8.0,),
          Icon(Icons.camera_alt, size: 30.0, color: Colors.grey,),
          SizedBox(width: 8.0,)
        ],
      ),
    ),
  );
  Widget renderTextBox(context){
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: roundedContainer(),
          ),
          SizedBox(width: 5.0,),
          GestureDetector(
            onTap: (){},
            child: CircleAvatar(
              child: Icon(Icons.mic),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFECE5DD),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        titleSpacing: -28.0,
        leading: Transform.translate(
          offset: Offset(-15, 0),
          child: IconButton(
            icon:Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Container(
          width: 400,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 18.0,
                backgroundColor: Colors.grey,
                backgroundImage: AssetImage(person.profileUrl),
              ),
              SizedBox(width: 5.0,),
              Expanded(child: Text(person.personName))
            ],
          ),
        ),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () =>{},
            color: Colors.white,
          ),
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () =>{},
            color: Colors.white,
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () =>{},
            color: Colors.white,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index){
                ChatMessage message = messages[index];
                final r = 2.5;
                
                return renderChatMessage(message, index, r, context);
              }
            ),
          ),
          Divider(),
          Container(
            child: renderTextBox(context),
          )
        ],
      ),
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}