import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:projectxweb/ChatInterface/chat_Service.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPage();
}

class _NotificationPage extends State<NotificationPage> {
  final _auth = FirebaseAuth.instance;
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.teal.shade400,
              width: 2,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(40),
            ),
          ),
          child: _buildMessageList(context),
        ),
      ),
    );
  }

  Widget _buildMessageList(BuildContext context) {
    ChatService chatService = ChatService();
    return StreamBuilder(
      stream: chatService.getNotifications(_auth.currentUser!.uid),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          return Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Opacity(
                  opacity: 1.0,
                  child: ListView(
                    controller: _scrollController,
                    children: snapshot.data!.docs
                        .map((document) => _buildNotificationItem(document))
                        .toList(),
                  ),
                ),
              )
            ],
          );
        }
        return Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Lottie.asset(
                      'assets/noti.json',
                      width: 300,
                    ),
                    Text(
                      "Stay on Top of Your Incoming Notifications",
                      style: GoogleFonts.anton(
                        fontSize: 30,
                        color: Colors.teal.shade800,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 80,
      decoration: BoxDecoration(
        color: Colors.teal.shade400,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Notifications',
            style: GoogleFonts.anton(
              fontSize: 35,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return Padding(
      padding: const EdgeInsets.only(
        top: 5,
        left: 2,
        right: 2,
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade500,
            ),
          ),
        ),
        child: Row(
          children: [
            _buildNotificationIcon(data['type']),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _buildNotificationTitle(data),
                    style: const TextStyle(fontSize: 20),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    data['message'],
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat('MMM dd, yyyy hh:mm a').format(
                          data['timestamp'].toDate(),
                        ),
                        style: TextStyle(
                          fontSize: 15,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(String type) {
    String iconpath;
    switch (type) {
      case 'Image':
        iconpath = 'assets/imageup.png';
        break;
      case 'Video':
        iconpath = 'assets/videoup.png';
        break;
      case 'Audio':
        iconpath = 'assets/audioup.png';
        break;
      default:
        iconpath = 'assets/docup.png';
    }
    return Image.asset(
      iconpath,
      width: 100,
    );
  }

  String _buildNotificationTitle(Map<String, dynamic> data) {
    switch (data['type']) {
      case 'Image':
        return 'Image from ${data['senderName']}';
      case 'Video':
        return 'Video from ${data['senderName']}';
      default:
        return 'Message from ${data['senderName']}';
    }
  }
}
