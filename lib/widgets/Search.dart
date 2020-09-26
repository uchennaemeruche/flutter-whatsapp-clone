import 'package:flutter/material.dart';
import 'package:whatsapp_clone/models/chat_model.dart';
import 'package:whatsapp_clone/widgets/ListItems.dart';

class DataSearch extends SearchDelegate<String>{

  final List<ChatListItem> activeChartListItems;
  final String selectedTab;

  DataSearch({this.activeChartListItems, this.selectedTab});

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions -- Actions for search bar
    return [
      query.isEmpty 
        ? SizedBox.shrink() 
        : IconButton(
          icon: Icon(Icons.clear), 
          onPressed: (){
            query = "";
          },
        )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading -- Leading Icon on the left of app bar

    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults -- Show results based on an item that is selected
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions -- What will be displayed when someone searches for something
    final suggestionList = query.isEmpty 
      ? activeChartListItems 
      : activeChartListItems.where((p) => p.personName.toLowerCase().contains(query)).toList() ;
    return ListView.separated(
      itemCount: suggestionList.length,
      itemBuilder: (BuildContext context, int index) => ListItem(tab: selectedTab, chat: suggestionList[index], index: index,),
      separatorBuilder: (BuildContext context, int index){
          return Divider();
      }, 
    );
  }

}
