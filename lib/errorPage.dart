import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade400,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 70,
              ),
              Container(
                alignment: Alignment.center,
                width: 300,
                child: Lottie.asset('assets/error2.json'),
              ),
              Text(
                "This app isn't optimized for this orientation",
                softWrap: true,
                style: GoogleFonts.ptSans(
                  fontSize: 25,
                  color: Colors.grey.shade900,
                ),
              ),
              Text(
                'Please adjust the window scale or switch to Android app',
                style: GoogleFonts.ptSans(
                  fontSize: 15,
                  color: Colors.grey.shade900,
                ),
              ),
              const SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
    );
  }
}
