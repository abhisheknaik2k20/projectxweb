import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:html' as html;
import 'package:projectxweb/ChatInterface/chatPage_Content.dart';

class ChatScreen extends StatelessWidget with WidgetsBindingObserver {
  final Map<String, dynamic>? data;
  const ChatScreen({
    this.data = null,
    Key? key,
  }) : super(key: key);

  void _onFocus(html.Event event) {
    setStatus('Online');
  }

  void _onBlur(html.Event event) {
    DateTime now = DateTime.now();
    setStatus('Last seen ${DateFormat('yyyy-MM-dd hh:mm a').format(now)}');
  }

  void setStatus(String status) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'status': status});
  }

  @override
  Widget build(BuildContext context) {
    html.window.addEventListener('focus', _onFocus);
    html.window.addEventListener('blur', _onBlur);
    if (data != null) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(40),
              ),
              border: Border.all(
                color: Colors.teal.shade400,
                width: 5,
              ),
            ),
            child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(data!['uid'])
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return Column(
                      children: [
                        Container(
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.teal.shade400,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(35),
                              topRight: Radius.circular(35),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 20.0,
                                  top: 5,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['name'],
                                      style: GoogleFonts.ptSans(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                    data['status'] == 'Online'
                                        ? Text(
                                            'Online',
                                            style: GoogleFonts.ptSans(
                                                fontSize: 15,
                                                color: Colors.blue.shade200),
                                          )
                                        : Text(
                                            data['status'],
                                            style: GoogleFonts.ptSans(
                                              fontSize: 15,
                                              color: Colors.white,
                                            ),
                                          )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.info,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: ChatPageContent(
                            context: context,
                            receiverName: data['name'],
                            receiverEmail: data['email'],
                            receiverUid: data['uid'],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        Container(
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.teal.shade400,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(35),
                              topRight: Radius.circular(35),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      data!['name'],
                                      style: GoogleFonts.ptSans(
                                        fontSize: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.info,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: ChatPageContent(
                            context: context,
                            receiverName: data!['name'],
                            receiverEmail: data!['email'],
                            receiverUid: data!['uid'],
                          ),
                        ),
                      ],
                    );
                  }
                }),
          ),
        ),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
