import 'package:flutter/material.dart';
import 'package:whatsapp_clone/constants/settings.dart';
import 'package:whatsapp_clone/constants/theme.dart';


class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();

  final ThemeChanger _themeChanger;

  Settings(this._themeChanger);
}

class _SettingsState extends State<Settings> {

  int _selectedMode = 1;

  _appylySelectedTheme(){
    if(_selectedMode == 10){
      widget._themeChanger.setTheme(ThemeData.dark().copyWith(
        accentColor: Color(0XFF075E54),
        bottomAppBarColor: Color(0XFF075E54),
        backgroundColor: Colors.green[500],
        secondaryHeaderColor: Colors.grey[600],
        primaryColor: Color(0XFF34495E)
      ));
      Navigator.pop(context);
    }else if(_selectedMode == 20){
      widget._themeChanger.setTheme(ThemeData.light().copyWith(
        primaryColor: Color(0XFF075E54),
        accentColor: Color(0xFF25D366),
        bottomAppBarColor: Colors.white,
        backgroundColor: Color(0xFFDCF8C6),
        secondaryHeaderColor: Colors.white,
      ));
      Navigator.pop(context);
    }
  }

  Widget themeModeBuilder(index){
    return RadioListTile(
      value: modes[index].id,
      groupValue: _selectedMode,
      title: Text(modes[index].text),
      activeColor: Colors.green,
      selected: true,
      onChanged: (currentMode){
        print("Current Mode: $currentMode ");
        setState(() {
          _selectedMode = currentMode;
          
        });
      },


    );
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Settings'),
      ),
            
      body: ListView.separated(
        itemBuilder: (BuildContext context, int index){
          AccountSetting setting = accountSettings[index];
          return GestureDetector(
            onTap: (){
              if(index == 2){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context){
                      return Scaffold(
                        appBar: AppBar(
                          title: Text('Chats'),
                        ),
                        body: Container(
                          padding: EdgeInsets.symmetric(horizontal:15.0, vertical:10.0),
                          margin: EdgeInsets.symmetric(horizontal:8.0, vertical:5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Display'),
                              SizedBox(height: 10.0,),
                              GestureDetector(
                                onTap: (){
                                  print("Color Change Button Tapped");
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context){
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(2.0),
                                        ),
                                        child: Container(
                                          height: 220,
                                          child: Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text('Choose theme'),
                                                SizedBox(height: 10.0,),
                                                Flexible(
                                                  child: ListView.separated(
                                                    itemBuilder: (BuildContext context, int index){
                                                      return themeModeBuilder(index);
                                                    }, 
                                                    separatorBuilder: (BuildContext context, int index){
                                                      return Divider();
                                                    }, 
                                                    itemCount: modes.length
                                                  ),
                                                ),
                                                
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: <Widget>[
                                                    FlatButton(                                                         
                                                      child: Text('CANCEL', style: TextStyle(color: Theme.of(context).accentColor),),
                                                      onPressed: (){
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    FlatButton(
                                                      child: Text('OK', style: TextStyle(color: Theme.of(context).accentColor),),
                                                      onPressed: (){
                                                        _appylySelectedTheme();
                                                      },
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),

                                          ),
                                        ),
                                      );
                                    }
                                  );
                                  

                                },
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.brightness_6),
                                    SizedBox(width: 10.0,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('Theme'),
                                        Text('Dark', style: TextStyle(fontWeight: FontWeight.w500),)
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      );
                    }
                  )
                
                );
              }
            },
            child: ListTile(
              title: Text(
                setting.title
              ),
              subtitle: Text(
                setting.subtitle
              ),
              leading: setting.icon,
            ),
          );
    
        }, 
        separatorBuilder: (BuildContext context, int index){
          return Divider();
        }, 
        itemCount: accountSettings.length
      ),
    );
  }
}

