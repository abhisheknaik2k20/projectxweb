import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:projectxweb/QRGenerator/TempLogin.dart';

class LoggedOutPage extends StatefulWidget {
  const LoggedOutPage({super.key});

  @override
  State<LoggedOutPage> createState() => _LoggedOutPageState();
}

class _LoggedOutPageState extends State<LoggedOutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Colors.teal,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/error2.json',
              ),
              Text(
                "Oops! It seems you've been logged out.",
                softWrap: true,
                style: GoogleFonts.ptSansCaption(
                  fontSize: 20,
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith(
                    (states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.grey.shade900;
                      }
                      if (states.contains(MaterialState.hovered)) {
                        return Colors.grey.shade600;
                      }
                      return Colors.grey.shade300;
                    },
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const TempAccountCreate(),
                    ),
                    (route) => false,
                  );
                },
                child: Text(
                  'Login',
                  style: GoogleFonts.anton(
                    fontSize: 30,
                    color: Colors.teal.shade400,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
