import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HolderPage extends StatelessWidget {
  const HolderPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(10, 7),
              )
            ],
            color: Colors.teal.shade100,
            borderRadius: const BorderRadius.all(
              Radius.circular(40),
            ),
            border: Border.all(
              color: Colors.teal.shade500,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'WELCOME !',
                style: GoogleFonts.anton(
                  fontSize: 70,
                  color: Colors.teal.shade700,
                ),
              ),
              Image.asset('assets/chatimage.png'),
              Text(
                '"Your words, Our Platform, endless possibilities"',
                style: GoogleFonts.ptSans(
                  fontSize: 20,
                  color: Colors.grey.shade700,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
