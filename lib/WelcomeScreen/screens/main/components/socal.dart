import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectxweb/QRGenerator/TempLogin.dart';

import '../../../constants.dart';
import '../../../responsive.dart';

class Socal extends StatelessWidget {
  const Socal({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isMobile(context))
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
        if (!Responsive.isMobile(context))
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
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
        if (!Responsive.isMobile(context))
          Container(
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
