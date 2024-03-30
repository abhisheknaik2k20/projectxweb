import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return ListView(
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 1, 112, 101),
                  ),
                  curve: Curves.easeInOut,
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['username'],
                          style: GoogleFonts.ptSans(
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          data['email'],
                          style: GoogleFonts.ptSans(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('option1'),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text('option1'),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text('option1'),
                  onTap: () {},
                )
              ],
            );
          } else {
            return ListView(
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/bgi.jpg'),
                    ),
                  ),
                  curve: Curves.easeInOut,
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'USERNAME',
                          style: GoogleFonts.ptSans(
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'example@gmail.com',
                          style: GoogleFonts.ptSans(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('option1'),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text('option1'),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text('option1'),
                  onTap: () {},
                )
              ],
            );
          }
        },
      ),
    );
  }
}
