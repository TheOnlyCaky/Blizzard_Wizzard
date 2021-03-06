import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/views/screens/creator_screen.dart'; 
import 'package:blizzard_wizzard/views/screens/editor_screen.dart'; 
import 'package:blizzard_wizzard/views/screens/manager_screen.dart';
import 'package:blizzard_wizzard/views/screens/player_screen.dart'; 


class BlizzardScreen extends StatefulWidget {
  @override
  createState() => BlizzardScreenState();
}

class BlizzardScreenState extends State<BlizzardScreen> {
  int pageState;

  @override
  void initState() {
    super.initState();
    pageState = PageState.creator;
  }

  @override
  Widget build(BuildContext context) {
    Widget screen;

    switch(pageState){
      case PageState.manager:
        screen = ManagerScreen();
        break;
      case PageState.creator:
        screen = CreatorScreen();
        break;
      case PageState.editor:
        screen = EditorScreen();
        break;
      case PageState.player:
        screen = PlayerScreen();
        break;
      case PageState.helper:
        screen = Text("Whether you think you can or you think you can’t, you’re right. -Henry Ford");
        break;
      default:
        screen = Text("Oh golly gosh - this isn't suppost to happen!");
        break;
    }

    return Scaffold (
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: new Text('Blizzard Pro'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.lightbulb_outline),
            color: (pageState == PageState.manager) ?
              Theme.of(context).primaryColorDark : Colors.white,
            tooltip: 'Connected Devices',
            onPressed: (){
              if(pageState != PageState.manager){
                setState(() {
                  pageState = PageState.manager;                
                });
              }
            },
          ),
          new IconButton(
            icon: new Icon(Icons.add),
            color: (pageState == PageState.creator) ?
              Theme.of(context).primaryColorDark : Colors.white,
            tooltip: 'Scene Maker',
            onPressed: (){
              if(pageState != PageState.creator){
                setState(() {
                  pageState = PageState.creator;                
                });
              }
            },
          ),
          new IconButton(
            icon: new Icon(Icons.edit),
            color: (pageState == PageState.editor) ?
              Theme.of(context).primaryColorDark : Colors.white,
            tooltip: 'Scene Editor',
            onPressed: (){
              if(pageState != PageState.editor){
                setState(() {
                  pageState = PageState.editor;                
                });
              }
            },
          ),
          new IconButton(
            icon: new Icon(Icons.play_circle_outline),
            color: (pageState == PageState.player) ?
              Theme.of(context).primaryColorDark : Colors.white,
            tooltip: 'Player',
            onPressed: (){
              if(pageState != PageState.player){
                setState(() {
                  pageState = PageState.player;                
                });
              }
            },
          ),
          new IconButton(
            color: (pageState == PageState.helper) ?
              Theme.of(context).primaryColorDark : Colors.white,
            icon: new Icon(Icons.help_outline),
            tooltip: 'Help',
            onPressed: (){
              if(pageState != PageState.helper){
                setState(() {
                  pageState = PageState.helper;                
                });
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: screen,
      ),
    );
  }
}
