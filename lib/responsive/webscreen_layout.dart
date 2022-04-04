import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_flutter/responsive/global_variables.dart';

import '../utils/colors.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void navigationTap(int page) {
    pageController.jumpToPage(page);
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/ic_instagram.svg',
          color: primaryColor,
          height: 32,
        ),
        centerTitle: false,
        backgroundColor: mobileBackgroundColor,

        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              navigationTap(0);
            },
            color: _page == 0 ? primaryColor : Colors.grey,
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              navigationTap(1);
            },
            color: _page == 1 ? primaryColor : Colors.grey,
          ),
          IconButton(
            icon: Icon(Icons.add_box),
            onPressed: () {
              navigationTap(2);
            },
            color: _page == 2 ? primaryColor : Colors.grey,
          ),
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () {
              navigationTap(3);
            },
            color: _page == 3 ? primaryColor : Colors.grey,
          ),
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              navigationTap(4);
            },
          ),
          Transform.rotate(
            angle: (360 - 35) * 3.14 / 180,
            child: IconButton(
              icon: Icon(Icons.send_rounded),
              onPressed: () {},
            ),
          ),
        ],
        
      ),
      body: PageView(
        children: homeScreenItems, //Global Variable
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),

        onPageChanged: (page) {
          setState(() {
            _page = page;
          });
        },
      ),
    );
  }
}
