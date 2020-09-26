import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/constants/dropdowns.dart';
import 'package:whatsapp_clone/constants/theme.dart';
import 'package:whatsapp_clone/models/chat_model.dart';
import 'package:whatsapp_clone/screens/Settings.dart';
import 'package:whatsapp_clone/tabs/CallsTab.dart';
import 'package:whatsapp_clone/tabs/CameraTab.dart';
import 'package:whatsapp_clone/tabs/ChatTab.dart';
import 'package:whatsapp_clone/tabs/StatusTab.dart';
import 'package:whatsapp_clone/widgets/Search.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  List<ChatListItem> _chatListItems;
  bool _showBar = true;
  int _initialIndex = 1;
  String _selectedTab = "chats";
  TabController _tabController;
  ScrollController _scrollViewController;

  @override
  void initState() {
    super.initState();
    _chatListItems = chatListItems;
    _scrollViewController = new ScrollController();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Widget _appBar(innerBoxIsScrolled) {
    return SliverAppBar(
      expandedHeight: 100.0,
      forceElevated: innerBoxIsScrolled,
      pinned: true,
      floating: true,
      title: Text(
        'WhatsApp',
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
      bottom: TabBar(
        controller: _tabController,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 4,
        child: NestedScrollView(
          controller: _scrollViewController,
          headerSliverBuilder: (context, bool innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                child: _appBar(innerBoxIsScrolled),
              ),
            ];
          },
          body: TabBarView(
            // controller: _tabController,
            children: <Widget>[
              SafeArea(
                top: false,
                bottom: false,
                child: Builder(
                  builder: (BuildContext context) {
                    return CustomScrollView(
                      key: PageStorageKey<String>('camera'),
                      slivers: <Widget>[
                        SliverOverlapInjector(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context),
                        ),
                        SliverToBoxAdapter(
                          child: ChatTab(),
                        )
                      ],
                    );
                  },
                ),
              ),
              Builder(
                builder: (BuildContext context) {
                  return CustomScrollView(
                    key: PageStorageKey<String>('chats'),
                    slivers: <Widget>[
                      SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                      ),
                      SliverToBoxAdapter(
                        child: ChatTab(),
                      )
                    ],
                  );
                },
              ),
              Builder(
                builder: (BuildContext context) {
                  return CustomScrollView(
                    key: PageStorageKey<String>('status'),
                    slivers: <Widget>[
                      SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                      ),
                      SliverToBoxAdapter(
                        child: StatusTab(),
                      )
                    ],
                  );
                },
              ),
              Builder(
                builder: (BuildContext context) {
                  return CustomScrollView(
                    key: PageStorageKey<String>('calls'),
                    slivers: <Widget>[
                      SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                      ),
                      SliverToBoxAdapter(
                        child: CallsTab(),
                      )
                    ],
                  );
                },
              ),
              // CameraTab(needScaffold: false),
              // ChatTab(),
              // StatusTab(),
              // CallsTab()
            ],
          ),
        ),
      ),
    );

    // return DefaultTabController(
    //   length: 4,
    //   initialIndex: _initialIndex,
    //   child: WillPopScope(
    //     onWillPop: () {
    //       print('You want to pop the screen');
    //       setState(() {
    //         _initialIndex = 1;
    //       });
    //       return new Future(() => false);
    //     },
    //     child: Scaffold(
    //       body: CustomScrollView(
    //         slivers: <Widget>[
    //           _appBar(),
    //           SliverFillRemaining(
    //             child: TabBarView(
    //               children: <Widget>[
    //                 CameraTab(needScaffold: false),
    //                 ChatTab(),
    //                 StatusTab(),
    //                 CallsTab()
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
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
