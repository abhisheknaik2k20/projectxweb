import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  late PageController _pageController;

  List names1 = [
    'Ritojnan Mukherjee',
    'Roma Motwani',
    'Abhishek Naik',
    'Pranav Patil',
  ];
  List Linked = [
    'https://www.linkedin.com/in/ritojnanmukherjee',
    'http://linkedin.com/in/romamotwani',
    'https://linkedin.com/in/abhishek-naik-6853382ba/',
    'https://www.linkedin.com/in/pranav-patil-b92868249/',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 1.0,
    );

    _startAutoScroll();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 5), () {
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          (_pageController.page!.toInt() + 1) % 4,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _startAutoScroll();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.25,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Our Team',
                  style: GoogleFonts.anton(
                    fontSize: 75,
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
                const SizedBox(height: 10),
                Text(
                  'Welcome to the Messaging App team – a group of passionate individuals dedicated to revolutionizing the way we communicate in the digital age. Get to know the faces and minds behind the development of our innovative messaging app.',
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Learn More ->',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: 30,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 5, 1, 47),
                borderRadius: BorderRadius.all(
                  Radius.circular(40),
                ),
                border: Border.all(
                  width: 5,
                  color: Colors.amber.shade600,
                ),
              ),
              child: PageView.builder(
                controller: _pageController,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return _buildPage(index);
                },
              ),
            ),
          ),
          Container(
            width: 40,
          )
        ],
      ),
    );
  }

  Widget _buildPage(int index) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Stack(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Lottie.asset(
                'assets/design.json',
              ),
              const Icon(
                Icons.circle,
                size: 250,
                color: Colors.amber,
              ),
              CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage('assets/DEVS/$index.jpg'),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 350,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedTextKit(
                    isRepeatingAnimation: false,
                    animatedTexts: [
                      TyperAnimatedText(
                        names1[index],
                        speed: Duration(milliseconds: 150),
                        textStyle: TextStyle(
                          fontSize: 33,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber.shade300,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  AnimatedTextKit(
                    isRepeatingAnimation: false,
                    animatedTexts: [
                      TyperAnimatedText(
                        speed: Duration(milliseconds: 100),
                        'WEB DEV',
                        textStyle: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade200,
                        ),
                      ),
                      TyperAnimatedText(
                        speed: Duration(milliseconds: 100),
                        'APP DEV',
                        textStyle: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade200,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          final Uri url = Uri.parse(Linked[index]);
                          await launchUrl(url);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              border: Border.all(color: Colors.white, width: 2),
                              color: const Color.fromARGB(255, 7, 33, 128)),
                          child: const Icon(
                            FontAwesomeIcons.linkedin,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          final Uri url = Uri.parse('https://flutter.dev');
                          await launchUrl(url);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              border: Border.all(color: Colors.white, width: 2),
                              color: Color.fromARGB(255, 1, 7, 27)),
                          child: const Icon(
                            FontAwesomeIcons.github,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
