import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/auth/Authentication.dart';
import 'dart:async';
import 'package:whatsapp_clone/constants/dropdowns.dart';
import 'package:whatsapp_clone/models/chat_model.dart';
import 'package:whatsapp_clone/screens/Home.dart';
import 'package:whatsapp_clone/screens/Settings.dart';
import 'package:whatsapp_clone/tabs/CallsTab.dart';
import 'package:whatsapp_clone/tabs/CameraTab.dart';
import 'package:whatsapp_clone/tabs/ChatTab.dart';
import 'package:whatsapp_clone/tabs/StatusTab.dart';
import 'package:whatsapp_clone/widgets/Search.dart';

import 'constants/theme.dart';

List<CameraDescription> cameras;
void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }
  runApp(MyApp());
}

// void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeChanger>(
      create: (_) => ThemeChanger(ThemeData.dark()),
      child: MaterialAppWithTheme(),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: Home(),
        theme: theme.getTheme());
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ChatListItem> _chatListItems;
  bool _showBar = true;
  int _initialIndex = 1;
  String _selectedTab = "chats";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _chatListItems = chatListItems;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: _initialIndex,
      child: WillPopScope(
        onWillPop: () {
          print('You want to pop the screen');
          setState(() {
            _initialIndex = 1;
          });
          return new Future(() => false);
        },
        child: Scaffold(
          appBar: _showBar
              ? AppBar(
                  title: Text(
                    'Whatsapp',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () => showSearch(
                          context: context,
                          delegate: DataSearch(
                              activeChartListItems: _chatListItems,
                              selectedTab: _selectedTab)),
                    ),
                    PopupMenuButton(
                      onSelected: choiceAction,
                      itemBuilder: (BuildContext context) {
                        return Dropdowns.options.map((String option) {
                          return PopupMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }).toList();
                      },
                    ),
                  ],
                  centerTitle: false,
                  backgroundColor: Theme.of(context).primaryColor,
                  bottom: TabBar(
                    indicatorColor: Theme.of(context).bottomAppBarColor,
                    onTap: (selectedTab) {
                      print(selectedTab);
                      if (selectedTab == 1) {
                        setState(() {
                          _chatListItems = chatListItems;
                          _selectedTab = "chats";
                        });
                      } else if (selectedTab == 2) {
                        setState(() {
                          _selectedTab = "status";
                        });
                      } else if (selectedTab == 3) {
                        setState(() {
                          _selectedTab = "calls";
                        });
                      }
                      if (selectedTab == 0) {
                        setState(() {
                          _showBar = !_showBar;
                        });
                      }
                    },
                    tabs: <Widget>[
                      Tab(
                        icon: Icon(Icons.camera_alt),
                      ),
                      Tab(
                        child: Text('Chats'),
                      ),
                      Tab(
                        child: Text('Status'),
                      ),
                      Tab(
                        child: Text('Calls'),
                      ),
                    ],
                  ),
                  elevation: 0.0,
                )
              : null,
          body: TabBarView(
            children: <Widget>[
              CameraTab(needScaffold: false),
              ChatTab(),
              StatusTab(),
              CallsTab()
            ],
          ),
        ),
      ),
    );
  }

  void choiceAction(String choice) {
    ThemeChanger _themeChanger =
        Provider.of<ThemeChanger>(context, listen: false);

    if (choice == Dropdowns.new_group)
      print('New Group');
    else if (choice == Dropdowns.new_brodadcast)
      print('New Broadcast');
    else if (choice == Dropdowns.whatsapp_web)
      print('Whatsapp Web');
    else if (choice == Dropdowns.starred_messages)
      print("Starred Messages");
    else
      Navigator.push(
          context,
          MaterialPageRoute(
              fullscreenDialog: true,
              builder: (BuildContext context) {
                return Settings(_themeChanger);
              }));
  }
}
