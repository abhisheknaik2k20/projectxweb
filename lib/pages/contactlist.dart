import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectxweb/ChatInterface/chatPage.dart';

class ListContacts extends StatefulWidget {
  const ListContacts({
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ListContactsState createState() => _ListContactsState();
}

class _ListContactsState extends State<ListContacts> {
  late List<MessageData> fakeMessageDataList;
  @override
  void initState() {
    super.initState();
    fakeMessageDataList = List.generate(
      25,
      (index) => MessageData(
        sendname: Faker().person.name(),
        sendmessage: Faker().lorem.sentence(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 20,
          bottom: 20,
        ),
        child: Container(
          padding: const EdgeInsets.all(
            20,
          ),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 5,
                offset: const Offset(15, 7),
              )
            ],
            color: Colors.white,
            border: Border.all(
              color: Colors.teal.shade400,
              width: 5,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(35),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent.withOpacity(0.15),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      cursorColor: Colors.teal.shade400,
                      decoration: const InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: Icon(
                          Icons.search,
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.teal,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.teal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  top: 5,
                ),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Verified Users',
                    style: GoogleFonts.ptSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.teal,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(
                  10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(40),
                  ),
                ),
                child: _buildUsersList(),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 10,
                  top: 5,
                ),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Friends List',
                    style: GoogleFonts.ptSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.teal,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_delegate),
                        childCount: fakeMessageDataList.length,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _delegate(BuildContext context, int index) {
    return MessageTileTwo(
      messageData: fakeMessageDataList[index],
    );
  }

  Widget _buildUsersList() {
    return SizedBox(
      height: 120,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            scrollDirection: Axis.horizontal,
            children: snapshot.data!.docs
                .map((doc) => _buildUsersListItem(doc, context))
                .toList(),
          );
        },
      ),
    );
  }

  Widget _buildUsersListItem(DocumentSnapshot document, BuildContext context) {
    final auth = FirebaseAuth.instance;
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    if (auth.currentUser!.uid != data['uid']) {
      return InkWell(
        child: MessageTile(
          messageData: MessageData(
            sendname: data['username'],
            sendmessage: '',
          ),
          document: document,
        ),
      );
    } else {
      return Container();
    }
  }
}

class MessageTileTwo extends StatelessWidget {
  const MessageTileTwo({required this.messageData, this.onTap});
  final MessageData messageData;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('Tapped2');
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(
              20,
            ),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: CircleAvatar(
                backgroundColor: Colors.teal.shade400,
                child: const Icon(Icons.account_circle, size: 40),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    messageData.sendname,
                    style: GoogleFonts.ptSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    messageData.sendmessage,
                    style: GoogleFonts.ptSans(fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageData {
  final String sendname;
  final String sendmessage;
  MessageData({required this.sendname, required this.sendmessage});
}

class MessageTile extends StatelessWidget {
  const MessageTile({
    required this.messageData,
    required this.document,
  });
  final MessageData messageData;
  final DocumentSnapshot document;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => ChatPage(
              document: document,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              const Expanded(
                child: Icon(Icons.account_circle,
                    size: 80, color: Color.fromARGB(255, 13, 2, 77)),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  messageData.sendname,
                  style: GoogleFonts.ptSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
