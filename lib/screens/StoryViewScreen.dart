import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

class StoryViewScreen extends StatelessWidget {
  final controller = StoryController();
  @override
  Widget build(BuildContext context) {
    List<StoryItem> stories = [
      StoryItem.text(
        "Hello there!!, this is gonna be awesome",
        Colors.black
      ),
      StoryItem.pageImage(
        AssetImage('assets/uche.jpg')
      ),
      StoryItem.pageImage(
        AssetImage('assets/goody.jpg')
      ),
    ];
    return Material(
      child: StoryView(
        stories,
        controller: controller,
        onComplete: (){
          Navigator.pop(context);
        },
      ),
    );
  }
}