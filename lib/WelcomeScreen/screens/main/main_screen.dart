import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectxweb/WelcomeScreen/screens/home/home_screen.dart';
import '../../constants.dart';
import 'components/header.dart';
import 'components/side_menu.dart';
import 'package:projectxweb/WelcomeScreen/controllers/MenuController.dart'
    as WelcomeMenuController;

class MainScreen extends StatelessWidget {
  final WelcomeMenuController.MenuController _controller =
      Get.put(WelcomeMenuController.MenuController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _controller.scaffoldkey,
      drawer: SideMenu(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(),
            Container(
              padding: EdgeInsets.all(10),
              constraints: BoxConstraints(maxWidth: kMaxWidth),
              child: SafeArea(child: HomeScreen()),
            ),
            Fotter()
          ],
        ),
      ),
    );
  }
}

class Fotter extends StatelessWidget {
  const Fotter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 50,
        right: 50,
      ),
      decoration: BoxDecoration(
        color: Colors.teal.shade500,
      ),
      child: Row(
        children: [
          Column(
            children: [
              Image.asset(
                'assets/chat3.png',
                width: 300,
              ),
              Text(
                'Follow us on',
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        color: Colors.pink),
                    child: Icon(
                      FontAwesomeIcons.instagram,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        color: const Color.fromARGB(255, 9, 105, 184)),
                    child: Icon(
                      FontAwesomeIcons.facebookF,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        color: const Color.fromARGB(255, 128, 28, 146)),
                    child: Icon(
                      FontAwesomeIcons.twitch,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        color: const Color.fromARGB(255, 9, 105, 184)),
                    child: Icon(
                      FontAwesomeIcons.discord,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        color: Color.fromARGB(255, 11, 14, 208)),
                    child: Icon(
                      FontAwesomeIcons.linkedin,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
          SizedBox(
            width: 50,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Overview',
                style: GoogleFonts.roboto(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade400,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'About',
                style: GoogleFonts.roboto(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Contact',
                style: GoogleFonts.roboto(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Terms of Use',
                style: GoogleFonts.roboto(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Privacy Policy',
                style: GoogleFonts.roboto(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 100,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Download the App',
                style: GoogleFonts.roboto(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade400,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                child: const Icon(
                  FontAwesomeIcons.appStore,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                child: const Icon(
                  FontAwesomeIcons.googlePlay,
                  color: Colors.white,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
