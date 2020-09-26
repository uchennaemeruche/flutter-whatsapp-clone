import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_clone/constants/colors.dart';
import 'package:whatsapp_clone/constants/dropdowns.dart';
import 'package:whatsapp_clone/models/chat_model.dart';
import 'package:whatsapp_clone/screens/AddContacts.dart';
import 'package:whatsapp_clone/widgets/Search.dart';

class SelectContact extends StatefulWidget {
  @override
  _SelectContactState createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {
  List<ChatListItem> _chatListItems;
  String _selectedItem = "contacts";
  List<Contact> _contacts;

  @override
  void initState() {
    _chatListItems = chatListItems;
    refreshContacts();
  }

  refreshContacts() async{
    PermissionStatus permissionStatus = await _getContactPermission();
    if(permissionStatus == PermissionStatus.granted){
      // Load without thumbnails initially
      var contacts = (await ContactsService.getContacts(withThumbnails:false)).toList();
      // var contacts = (await ContactsService.getContactsForPhone("08031194042")).toList();
      setState(() {
        _contacts = contacts;
      });

      // Lazy loading for thumbnails after rendering initial contactc;
      for(final contact in contacts){
        ContactsService.getAvatar(contact).then((avatar){
          if(avatar == null) return; // Don't redraw if no change
          setState(() {
            contact.avatar = avatar;
          });
        });

      }
    }else{
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<PermissionStatus> _getContactPermission() async{
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.contacts);
    if(permission != PermissionStatus.granted && permission != PermissionStatus.neverAskAgain){
      Map<PermissionGroup, PermissionStatus> permissionStatus = await PermissionHandler().requestPermissions([PermissionGroup.contacts]);
      return permissionStatus[PermissionGroup.contacts] ?? PermissionStatus.unknown;
    }else{
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus){
    if(permissionStatus == PermissionStatus.denied){
      throw new PlatformException(
        code: 'PERMISSION_DENIED',
        message: 'Access to location data denied',
        details:null
      );
    }else if(permissionStatus == PermissionStatus.neverAskAgain){
      throw new PlatformException(
        code: 'PERMISSION_DISABLED',
        message: 'Location data is not available on device',
        details: null
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Select contact'),
            SizedBox(height: 2.0,),
            Text(
              '12 contacts', 
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12
              ),
            )
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () =>showSearch(context: context, delegate: DataSearch(activeChartListItems: _chatListItems, selectedTab: _selectedItem)),
          ),
            
          PopupMenuButton(
            onSelected: (option) => selectedOption(option),
            itemBuilder: (BuildContext context){
              return Dropdowns.contactOptions.map((String option){
                return PopupMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(
            builder: (BuildContext context){
              return AddContact();
            }
          )).then((_){
            refreshContacts();
          });
        },
      ),
      body: SafeArea(
        child: _contacts != null
        ? ListView.builder(
          itemCount: _contacts?.length ?? 0,
          itemBuilder: (BuildContext context, int index){
            Contact contact = _contacts?.elementAt(index);
            return ListTile(
              onTap: (){
                print(contact.displayName);
              },
              leading: (contact.avatar != null && contact.avatar.length > 0)
              ? CircleAvatar(
                backgroundImage: MemoryImage(contact.avatar),)
              : CircleAvatar(child: Text(contact.initials()),),
              title: Text(contact.displayName ?? ""),
            );
          },
        )
        : Center(child: CircularProgressIndicator(),),
      ),
    );
  }

  void selectedOption(String option){
    if(option == Dropdowns.new_group) print('New Group');
    else if(option == Dropdowns.new_brodadcast) print('New Broadcast');
    else if(option == Dropdowns.whatsapp_web) print('Whatsapp Web');
    else if(option == Dropdowns.starred_messages) print("Starred Messages");
    else print("Settings");
  }
}