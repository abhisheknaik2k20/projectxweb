import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:projectxweb/ChatInterface/chatPage.dart';
import 'package:projectxweb/ChatInterface/chatScreen.dart';
import 'package:projectxweb/HolderPage.dart';
import 'package:projectxweb/LoggedOutPage.dart';
import 'package:projectxweb/pages/account.dart';
import 'package:projectxweb/pages/contactlist.dart';
import 'package:projectxweb/errorPage.dart';
import 'package:projectxweb/pages/groups.dart';
import 'package:projectxweb/pages/notifications.dart';
import 'package:projectxweb/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatefulWidget {
  final DocumentSnapshot document;
  const ChatPage({required this.document, super.key});
  @override
  State<ChatPage> createState() => _ChatPage();
}

class _ChatPage extends State<ChatPage> {
  bool isVisible = false;
  final faker = Faker();
  var selectedIndex = 0;
  bool passPage = false;
  List pages = [
    ListContacts(),
    Groups(),
    NotificationPage(),
    AccountPage(
      UserUID: FirebaseAuth.instance.currentUser!.uid,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    FirebaseAuth _auth = FirebaseAuth.instance;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxHeight < 475.00) {
          return ErrorPage();
        } else {
          return OrientationBuilder(
            builder: (context, orientation) {
              if (orientation == Orientation.portrait) {
                return ErrorPage();
              } else {
                Map<String, dynamic> data =
                    widget.document.data()! as Map<String, dynamic>;
                return StreamBuilder(
                    stream: db
                        .collection('users')
                        .doc(_auth.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data?.data()?['WEB'] != null) {
                          return Scaffold(
                            appBar: AppBar(
                              iconTheme: const IconThemeData(
                                color: Colors.white,
                              ),
                              centerTitle: true,
                              backgroundColor: Colors.teal.shade400,
                              title: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  'Messaging App',
                                  style: GoogleFonts.anton(
                                      fontSize: 40,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        )
                                      ]),
                                ),
                              ),
                              actions: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.account_circle_outlined,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(
                                      () {
                                        isVisible = !isVisible;
                                      },
                                    );
                                  },
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                              ],
                            ),
                            backgroundColor: Colors.grey.shade200,
                            body: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 15,
                                    bottom: 15,
                                  ),
                                  child: Container(
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade800,
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(60),
                                        bottomRight: Radius.circular(60),
                                      ),
                                    ),
                                    child: NavigationBar(context),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                pages[selectedIndex],
                                const SizedBox(
                                  width: 20,
                                ),
                                ChatScreen(data: data),
                              ],
                            ),
                          );
                        } else {
                          return const LoggedOutPage();
                        }
                      } else {
                        return Scaffold(
                            body: Container(
                          color: Colors.grey.shade400,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.teal.shade400,
                            ),
                          ),
                        ));
                      }
                    });
              }
            },
          );
        }
      },
    );
  }

  Widget NavigationBar(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              if (selectedIndex != 0) {
                setState(() {
                  selectedIndex = 0;
                });
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: selectedIndex == 0
                  ? Colors.grey.shade700
                  : Colors.transparent,
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                selectedIndex == 0
                    ? const Icon(
                        Icons.message_outlined,
                        size: 50,
                        color: Colors.teal,
                      )
                    : const Icon(
                        Icons.message_outlined,
                        size: 50,
                        color: Colors.white,
                      ),
                Text(
                  'Messages',
                  style: GoogleFonts.ptSans(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              if (selectedIndex != 1) {
                setState(() {
                  selectedIndex = 1;
                });
              }
            });
          },
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: selectedIndex == 1
                  ? Colors.grey.shade700
                  : Colors.transparent,
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                selectedIndex == 1
                    ? Icon(
                        Icons.group,
                        size: 50,
                        color: Colors.teal,
                      )
                    : Icon(
                        Icons.group,
                        size: 50,
                        color: Colors.white,
                      ),
                Text(
                  'Groups',
                  style: GoogleFonts.ptSans(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              if (selectedIndex != 2) {
                setState(() {
                  selectedIndex = 2;
                });
              }
            });
          },
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: selectedIndex == 2
                  ? Colors.grey.shade700
                  : Colors.transparent,
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                selectedIndex == 2
                    ? Icon(
                        Icons.notifications,
                        size: 50,
                        color: Colors.teal,
                      )
                    : Icon(
                        Icons.notifications,
                        size: 50,
                        color: Colors.white,
                      ),
                Text(
                  'Notifications',
                  style: GoogleFonts.ptSans(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              if (selectedIndex != 3) {
                setState(() {
                  selectedIndex = 3;
                });
              }
            });
          },
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: selectedIndex == 3
                  ? Colors.grey.shade700
                  : Colors.transparent,
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                selectedIndex == 3
                    ? Icon(
                        Icons.account_circle_outlined,
                        size: 50,
                        color: Colors.teal,
                      )
                    : Icon(
                        Icons.account_circle_outlined,
                        size: 50,
                        color: Colors.white,
                      ),
                Text(
                  'Account',
                  style: GoogleFonts.ptSans(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
