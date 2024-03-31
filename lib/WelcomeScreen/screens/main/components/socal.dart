import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectxweb/QRGenerator/TempLogin.dart';

import '../../../constants.dart';
import '../../../responsive.dart';

class Socal extends StatefulWidget {
  const Socal({
    Key? key,
  }) : super(key: key);

  @override
  State<Socal> createState() => _SocalState();
}

class _SocalState extends State<Socal> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isHovertwitch = false;
  bool _isHoverLinkd = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
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
    return Row(
      children: [
        if (!Responsive.isMobile(context))
          MouseRegion(
            onEnter: (_) {
              setState(() {
                _isHovered = true;
              });
            },
            onExit: (_) {
              setState(() {
                _isHovered = false;
              });
            },
            child: Transform.scale(
              scale: _isHovered ? 1.5 : 1,
              child: Container(
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
            ),
          ),
        if (!Responsive.isMobile(context))
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: MouseRegion(
              onEnter: (_) {
                setState(() {
                  _isHovertwitch = true;
                });
              },
              onExit: (_) {
                setState(() {
                  _isHovertwitch = false;
                });
              },
              child: Transform.scale(
                scale: _isHovertwitch ? 1.5 : 1,
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: Color.fromARGB(255, 75, 5, 150)),
                  child: Icon(
                    FontAwesomeIcons.twitch,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        if (!Responsive.isMobile(context))
          MouseRegion(
            onEnter: (_) {
              setState(() {
                _isHoverLinkd = true;
              });
            },
            onExit: (_) {
              setState(() {
                _isHoverLinkd = false;
              });
            },
            child: Transform.scale(
              scale: _isHoverLinkd ? 1.5 : 1,
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: Color.fromARGB(255, 7, 33, 128)),
                child: Icon(
                  FontAwesomeIcons.linkedin,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        SizedBox(width: kDefaultPadding * 2.5),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => const TempAccountCreate()),
                (route) => false);
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white)),
          child: Text(
            "Let's Get Started",
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              color: Colors.teal.shade400,
            ),
          ),
        ),
      ],
    );
  }
}
