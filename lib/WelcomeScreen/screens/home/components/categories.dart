import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sidebar_container.dart';

class Categories extends StatefulWidget {
  const Categories({
    Key? key,
  }) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  ScrollController scrollController = ScrollController();
  double counter = 0.0;
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  final List<String> randomNames =
      List.generate(25, (index) => faker.internet.userName());
  final List<String> randommessages =
      List.generate(25, (index) => faker.lorem.sentence());

  void _startTimer() {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        counter = (counter + 70) % 1000;
        scrollController.animateTo(counter,
            duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SidebarContainer(
      title: "Categories",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 75,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 88, 101, 242),
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/discord.png',
                  color: const Color.fromARGB(255, 255, 255, 255),
                  width: 200,
                ),
                Text(
                  '25 Members Online',
                  style: GoogleFonts.roboto(color: Colors.white),
                )
              ],
            ),
          ),
          Container(
            height: 300,
            padding: EdgeInsets.only(
              left: 20,
            ),
            color: Colors.white,
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Category(
                        title: randomNames[index],
                        numOfItems: index,
                        imageUrl: randommessages[index],
                        press: () {},
                      );
                    },
                    childCount: 25,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20, top: 10),
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade500),
            ),
            child: Row(
              children: [
                Text(
                  'Want to join our Community?',
                  style: GoogleFonts.roboto(
                    color: Color.fromARGB(255, 88, 101, 242),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Color.fromARGB(255, 88, 101, 242),
                    ),
                  ),
                  child: Text(
                    'Join Server',
                    style: GoogleFonts.roboto(
                      color: Color.fromARGB(255, 245, 245, 247),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Category extends StatelessWidget {
  final String title;
  final int numOfItems;
  final VoidCallback press;
  final String? imageUrl;
  const Category({
    Key? key,
    required this.title,
    required this.numOfItems,
    required this.press,
    this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(
                  'assets/avatars/' + ((numOfItems) % 15).toString() + '.jpg',
                ), // Replace 'assets/image.jpg' with your image asset path
                radius: 20, // Adjust the radius as needed
              ),
              numOfItems % 10 == 0
                  ? Icon(
                      Icons.circle,
                      color: Colors.red,
                      size: 15,
                    )
                  : Icon(
                      Icons.circle,
                      color: Color.fromARGB(255, 19, 233, 26),
                      size: 15,
                    ),
            ],
          ),
          SizedBox(
            width: 10,
          ),
          Text.rich(
            TextSpan(
              text: title,
              style: TextStyle(
                color: Color.fromARGB(255, 88, 101, 242),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Flexible(
            child: Text(
              numOfItems % 8 == 0 ? "($imageUrl!)" : '',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
