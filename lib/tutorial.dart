import 'package:flutter/material.dart';
import 'package:scrolling_page_indicator/scrolling_page_indicator.dart';

class Tutorial extends StatefulWidget {
  //const Tutorial({Key key}) : super(key: key);

  @override
  _TutorialState createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {

  List<String> images = [
    "images/1.jpg", 
    "images/2.jpg",
    "images/3.jpg", 
    "images/4.jpg"
  ];

  late int selectedPage;
  late final PageController _pageController;

  @override
  void initState() {
    selectedPage = 0;
    _pageController = PageController(initialPage: selectedPage);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff004AAD),
        title: Text("Tutorial"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height*0.75,
              child: PageView.builder(
                controller: _pageController,
                      itemBuilder: (context, position){
                        return Container(
                          child: Image.asset("${images[position]}"),
                        );
                      },
                      itemCount: images.length,
                      ),
            ),
            ScrollingPageIndicator(
                dotColor: const Color(0xff1F1F1F),
                dotSelectedColor: Color(0xff004AAD),
                dotSize: 7,
                dotSelectedSize: 8,
                dotSpacing: 12,
                controller: _pageController,
                itemCount: images.length,
                orientation: Axis.horizontal
            )
          ],
        ),
      ),
    );
  }
}