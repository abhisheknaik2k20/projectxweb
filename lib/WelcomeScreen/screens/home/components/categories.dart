import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sidebar_container.dart';

class Categories extends StatelessWidget {
  const Categories({
    Key? key,
  }) : super(key: key);

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
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Category(
                        title: faker.person.firstName(),
                        numOfItems: index,
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
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Tap Here',
                    style: GoogleFonts.roboto(
                      color: Color.fromARGB(255, 88, 101, 242),
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
  final Future<String>? imageUrl;
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
        ],
      ),
    );
  }
}
