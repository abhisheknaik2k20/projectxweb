import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:projectxweb/WelcomeScreen/controllers/MenuController.dart'
    as WelcomeMenuController;
import 'package:projectxweb/WelcomeScreen/responsive.dart';
import 'package:projectxweb/WelcomeScreen/screens/main/components/Aboutus.dart';
import 'package:projectxweb/WelcomeScreen/screens/main/components/Services.dart';
import 'package:projectxweb/WelcomeScreen/screens/main/components/contactus.dart';

import '../../../constants.dart';
import 'socal.dart';
import 'web_menu.dart';

class Header extends StatefulWidget {
  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  final WelcomeMenuController.MenuController _controller =
      Get.put(WelcomeMenuController.MenuController());
  final _scrollController = ScrollController();

  @override
  void initState() {
    _controller.addListener(_updateSelectedIndex);
    super.initState();
  }

  void _updateSelectedIndex() {
    final childWidth = MediaQuery.of(context).size.width;
    final scrollPosition = childWidth * _controller.selectedIndex;
    _scrollController.animateTo(
      scrollPosition,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_updateSelectedIndex);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double swidth = MediaQuery.of(context).size.width;
    double sheight = MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      color: kDarkBlackColor,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: kMaxWidth),
              padding: const EdgeInsets.all(kDefaultPadding / 2),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "assets/chat3.png",
                        width: 100,
                      ),
                      SizedBox(
                        width: 100,
                      ),
                      MenuBar(),
                      Spacer(),
                      Socal(),
                    ],
                  ),
                  SizedBox(height: kDefaultPadding * 2),
                  Container(
                    height: sheight * 0.7,
                    width: swidth,
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      children: const [
                        ReturnHome(),
                        AboutUs(),
                        ContactUs(),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget MenuBar() {
    return Row(
      children: [
        Column(
          children: [
            TextButton(
              onPressed: () {
                _controller.setMenuIndex(0);
                setState(() {});
                _updateSelectedIndex();
              },
              child: Text(
                'Home',
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: _controller.selectedIndex == 0
                      ? FontWeight.bold
                      : FontWeight.normal,
                  shadows: _controller.selectedIndex == 0
                      ? [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
              ),
            ),
            _controller.selectedIndex == 0
                ? Container(
                    height: 3,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 4,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
        Column(
          children: [
            TextButton(
              onPressed: () {
                _controller.setMenuIndex(1);
                setState(() {});
                _updateSelectedIndex();
              },
              child: Text(
                'Services',
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: _controller.selectedIndex == 1
                      ? FontWeight.bold
                      : FontWeight.normal,
                  shadows: _controller.selectedIndex == 1
                      ? [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
              ),
            ),
            _controller.selectedIndex == 1
                ? Container(
                    height: 3,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 4,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
        Column(
          children: [
            TextButton(
              onPressed: () {
                _controller.setMenuIndex(2);
                setState(() {});
                _updateSelectedIndex();
              },
              child: Text(
                'About Us',
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: _controller.selectedIndex == 2
                      ? FontWeight.bold
                      : FontWeight.normal,
                  shadows: _controller.selectedIndex == 2
                      ? [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
              ),
            ),
            _controller.selectedIndex == 2
                ? Container(
                    height: 3,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 4,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
        Column(
          children: [
            TextButton(
              onPressed: () {
                _controller.setMenuIndex(3);
                setState(() {});
                _updateSelectedIndex();
              },
              child: Text(
                'Blog',
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: _controller.selectedIndex == 3
                      ? FontWeight.bold
                      : FontWeight.normal,
                  shadows: _controller.selectedIndex == 3
                      ? [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
              ),
            ),
            _controller.selectedIndex == 3
                ? Container(
                    height: 3,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 4,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
        Column(
          children: [
            TextButton(
              onPressed: () {
                _controller.setMenuIndex(4);
                setState(() {});
                _updateSelectedIndex();
              },
              child: Text(
                'Contact Us',
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: _controller.selectedIndex == 4
                      ? FontWeight.bold
                      : FontWeight.normal,
                  shadows: _controller.selectedIndex == 4
                      ? [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
              ),
            ),
            _controller.selectedIndex == 4
                ? Container(
                    height: 3,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 4,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ],
    );
  }
}

class ReturnHome extends StatefulWidget {
  const ReturnHome({Key? key}) : super(key: key);

  @override
  _ReturnHomeState createState() => _ReturnHomeState();
}

class _ReturnHomeState extends State<ReturnHome>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Transform.translate(
                      offset: Offset(0.0, 50 * (1 - _animation.value)),
                      child: Text(
                        'Messaging App',
                        style: GoogleFonts.anton(
                          fontSize: 100,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Transform.scale(
                      scale: _animation.value,
                      child: Text(
                        "Welcome to Our Blog",
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Transform.scale(
                      scale: _animation.value,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          "Stay updated with the newest design and development stories, case studies, \nand insights shared by our Team.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Raleway',
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(0.0, 50 * (1 - _animation.value)),
                      child: FittedBox(
                        child: TextButton(
                          onPressed: () {},
                          child: Row(
                            children: [
                              Text(
                                "Learn More",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
                SizedBox(width: 20),
                Transform.scale(
                  scale: _animation.value,
                  child: Lottie.asset('assets/welcome.json'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
