import 'package:fancy_bar/fancy_bar.dart';
import 'package:flashy_tab_bar/flashy_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trashgram/screens/createPost.dart';
import 'package:trashgram/screens/feed.dart';
import 'package:trashgram/screens/leaderboard.dart';
import 'package:trashgram/screens/map.dart';
import 'package:trashgram/screens/profile.dart';

class AppBottomBar extends StatefulWidget {
  @override
  _AppBottomBarState createState() => _AppBottomBarState();
}

class _AppBottomBarState extends State<AppBottomBar> {
  int _currIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> _children = [
      Feed(),
      Leaderboard(),
      // CreatePost(),
      MapSample(),
      Profile()
    ];
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          centerTitle: true,
          title: Text(
            'Trashgram',
            style: TextStyle(
                color: Colors.white, fontSize: 42, fontFamily: "Billabong"),
          ),
          backgroundColor: Color(0xFFF191720),
        ),
        body: _children.elementAt(_currIndex),
        bottomNavigationBar: FlashyTabBar(
          backgroundColor: Color(0xFFF191720),
          showElevation: true,
          selectedIndex: _currIndex,
          items: [
            FlashyTabBarItem(
                icon: Icon(Icons.home_outlined, color: Colors.white),
                title: Text('Feed', style: TextStyle(color: Colors.white))),
            FlashyTabBarItem(
                icon: Icon(Icons.leaderboard_outlined, color: Colors.white),
                title:
                    Text('Leaderboard', style: TextStyle(color: Colors.white))),
            // FlashyTabBarItem(icon: Icon(Icons.add_outlined,color:Colors.white), title: Text('New Post',style:TextStyle(color:Colors.white))),
            FlashyTabBarItem(
                icon: Icon(Icons.map_outlined, color: Colors.white),
                title: Text('Map', style: TextStyle(color: Colors.white))),
            FlashyTabBarItem(
                icon: Icon(Icons.person_outline, color: Colors.white),
                title: Text('Profile', style: TextStyle(color: Colors.white)))
          ],
          onItemSelected: (index) {
            print(index);
            setState(() {
              _currIndex = index;
            });
          },
        ));
  }
}
