import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'sidebar_container.dart';

class RecentPosts extends StatelessWidget {
  const RecentPosts({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SidebarContainer(
      title: "Recent Post",
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.teal[500],
            ),
            child: const Row(
              children: [
                Text(
                  'References Used',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          RecentPostCard(
            image: "assets/avatars/0.jpg",
            title: "Our “Secret” Formula to Online Workshops",
            press: () {},
          ),
          const SizedBox(height: kDefaultPadding),
          RecentPostCard(
            image: "assets/avatars/1.jpg",
            title: "Digital Product Innovations from Warsaw with Love",
            press: () {},
          ),
        ],
      ),
    );
  }
}

class RecentPostCard extends StatelessWidget {
  final String image, title;
  final VoidCallback press;

  const RecentPostCard({
    Key? key,
    required this.image,
    required this.title,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: press,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Image.asset(image),
            ),
            SizedBox(width: kDefaultPadding),
            Expanded(
              flex: 5,
              child: Text(
                title,
                maxLines: 2,
                style: TextStyle(
                  fontFamily: "Raleway",
                  color: kDarkBlackColor,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
