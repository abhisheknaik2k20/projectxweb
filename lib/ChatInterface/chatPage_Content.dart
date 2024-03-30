import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:projectxweb/ChatInterface/chat_Bubble.dart';
import 'package:projectxweb/ChatInterface/chat_Service.dart';
import 'package:projectxweb/MediaHandle/ImagePage.dart';
import 'package:projectxweb/MediaHandle/VideoHandle.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class ChatPageContent extends StatefulWidget {
  final String receiverUid;
  final String receiverName;
  final String receiverEmail;
  final BuildContext context;

  ChatPageContent({
    Key? key,
    required this.receiverUid,
    required this.receiverEmail,
    required this.receiverName,
    required this.context,
  }) : super(key: key);

  @override
  State<ChatPageContent> createState() => _ChatPageContentState();
}

class _ChatPageContentState extends State<ChatPageContent> {
  final TextEditingController _messageController = TextEditingController();

  final ChatService _chatService = ChatService();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final ScrollController _scrollController = ScrollController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  File? imageFile;

  Uint8List? imageBytes;

  File? videoFile;

  String? ChatroomID;

  @override
  void initState() {
    List<String> ids = [_auth.currentUser!.uid, widget.receiverUid];
    ids.sort();
    ChatroomID = ids.join("_");
    super.initState();
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.SendMessage(
        widget.receiverUid,
        _messageController.text,
      );
      _messageController.clear();
    }
  }

  Future<void> getImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'png',
      ],
    );

    if (result != null) {
      try {
        String? extension = result.files.single.extension?.toLowerCase();
        List<int> bytes = result.files.single.bytes!;
        imageBytes = Uint8List.fromList(bytes);
        uploadImage();
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['gif', 'mp4', 'mov', 'avi'],
    );

    if (result != null) {
      try {
        String? extension = result.files.single.extension?.toLowerCase();

        List<int> bytes = result.files.single.bytes!;
        imageBytes = Uint8List.fromList(bytes);
        uploadVideo(extension);
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getDoc() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      try {
        String? extension = result.files.single.extension?.toLowerCase();

        List<int> bytes = result.files.single.bytes!;
        imageBytes = Uint8List.fromList(bytes);
        uploadDoc(extension);
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'aac'],
    );

    if (result != null) {
      try {
        String? extension = result.files.single.extension?.toLowerCase();

        List<int> bytes = result.files.single.bytes!;
        imageBytes = Uint8List.fromList(bytes);
        uploadAudio(extension);
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> uploadVideo(String? extension) async {
    String filename = const Uuid().v1();
    int status = 1;

    await _firestore
        .collection('chat_Rooms')
        .doc(ChatroomID)
        .collection('messages')
        .doc(filename)
        .set({
      'senderName': _auth.currentUser!.displayName,
      'senderId': _auth.currentUser!.uid,
      'senderEmail': _auth.currentUser!.email,
      'reciverId': widget.receiverEmail,
      'message': '',
      'timestamp': Timestamp.now(),
      'type': 'Video',
      'filename': filename,
    });
    var ref = FirebaseStorage.instance
        .ref()
        .child('videos')
        .child("$filename.${extension!}");
    var uploadTask = await ref.putData(imageBytes!).catchError((error) async {
      await _firestore
          .collection('chat_Rooms')
          .doc(ChatroomID)
          .collection('messages')
          .doc(filename)
          .delete();
      status = 0;
    });
    if (status == 1) {
      String imageUrl = await ref.getDownloadURL();
      await _firestore
          .collection('chat_Rooms')
          .doc(ChatroomID)
          .collection('messages')
          .doc(filename)
          .update({'message': imageUrl});
      print(imageUrl);
      try {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.receiverUid)
            .get();
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        print('fcmToken :' + data!['fcmToken']);
        var object = {
          'to': data['fcmToken'],
          'priority': 'high',
          'notification': {
            'title': _auth.currentUser!.displayName,
            'body': 'Video'
          }
        };

        var response = await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'key=AAAADHtCBX4:APA91bFlK9ZKNKNP0c46KUBQRgnEpf4d1mXhjtjbZXO0Wcp3-zFTPYkKzqUNooJjw6NIwT7BCwlp0Zh9jQ8OpunTJcUk2GsHUj5pngLO-8CXiPPdhGzw0NCStfyryRIel6RkDhn5OTfH',
          },
          body: jsonEncode(object),
        );

        print(response.statusCode);
        print(response.body);
      } catch (Except) {
        print(Except);
      }
    }
  }

  Future<void> uploadAudio(String? extension) async {
    String filename = const Uuid().v1();
    int status = 1;

    await _firestore
        .collection('chat_Rooms')
        .doc(ChatroomID)
        .collection('messages')
        .doc(filename)
        .set({
      'senderName': _auth.currentUser!.displayName,
      'senderId': _auth.currentUser!.uid,
      'senderEmail': _auth.currentUser!.email,
      'reciverId': widget.receiverEmail,
      'message': '',
      'timestamp': Timestamp.now(),
      'type': 'Audio',
      'filename': filename,
    });
    var ref = FirebaseStorage.instance
        .ref()
        .child('audio')
        .child("$filename.${extension!}");
    var uploadTask = await ref.putData(imageBytes!).catchError((error) async {
      await _firestore
          .collection('chat_Rooms')
          .doc(ChatroomID)
          .collection('messages')
          .doc(filename)
          .delete();
      status = 0;
    });
    if (status == 1) {
      String imageUrl = await ref.getDownloadURL();
      await _firestore
          .collection('chat_Rooms')
          .doc(ChatroomID)
          .collection('messages')
          .doc(filename)
          .update({'message': imageUrl});
      print(imageUrl);
      try {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.receiverUid)
            .get();
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        print('fcmToken :' + data!['fcmToken']);
        var object = {
          'to': data['fcmToken'],
          'priority': 'high',
          'notification': {
            'title': _auth.currentUser!.displayName,
            'body': 'Audio'
          }
        };

        var response = await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'key=AAAADHtCBX4:APA91bFlK9ZKNKNP0c46KUBQRgnEpf4d1mXhjtjbZXO0Wcp3-zFTPYkKzqUNooJjw6NIwT7BCwlp0Zh9jQ8OpunTJcUk2GsHUj5pngLO-8CXiPPdhGzw0NCStfyryRIel6RkDhn5OTfH',
          },
          body: jsonEncode(object),
        );

        print(response.statusCode);
        print(response.body);
      } catch (Except) {
        print(Except);
      }
    }
  }

  Future<void> uploadDoc(String? extension) async {
    String filename = const Uuid().v1();
    int status = 1;

    await _firestore
        .collection('chat_Rooms')
        .doc(ChatroomID)
        .collection('messages')
        .doc(filename)
        .set({
      'senderName': _auth.currentUser!.displayName,
      'senderId': _auth.currentUser!.uid,
      'senderEmail': _auth.currentUser!.email,
      'reciverId': widget.receiverEmail,
      'message': '',
      'timestamp': Timestamp.now(),
      'type': 'PDF',
      'filename': filename,
    });
    var ref = FirebaseStorage.instance
        .ref()
        .child('pdf')
        .child("$filename.${extension!}");
    var uploadTask = await ref.putData(imageBytes!).catchError((error) async {
      await _firestore
          .collection('chat_Rooms')
          .doc(ChatroomID)
          .collection('messages')
          .doc(filename)
          .delete();
      status = 0;
    });
    if (status == 1) {
      String imageUrl = await ref.getDownloadURL();
      await _firestore
          .collection('chat_Rooms')
          .doc(ChatroomID)
          .collection('messages')
          .doc(filename)
          .update({'message': imageUrl});
      print(imageUrl);
      try {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.receiverUid)
            .get();
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        print('fcmToken :' + data!['fcmToken']);
        var object = {
          'to': data['fcmToken'],
          'priority': 'high',
          'notification': {
            'title': _auth.currentUser!.displayName,
            'body': 'PDF'
          }
        };

        var response = await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'key=AAAADHtCBX4:APA91bFlK9ZKNKNP0c46KUBQRgnEpf4d1mXhjtjbZXO0Wcp3-zFTPYkKzqUNooJjw6NIwT7BCwlp0Zh9jQ8OpunTJcUk2GsHUj5pngLO-8CXiPPdhGzw0NCStfyryRIel6RkDhn5OTfH',
          },
          body: jsonEncode(object),
        );

        print(response.statusCode);
        print(response.body);
      } catch (Except) {
        print(Except);
      }
    }
  }

  Future<void> uploadImage() async {
    String filename = const Uuid().v1();
    int status = 1;
    await _firestore
        .collection('chat_Rooms')
        .doc(ChatroomID)
        .collection('messages')
        .doc(filename)
        .set({
      'senderName': _auth.currentUser!.displayName,
      'senderId': _auth.currentUser!.uid,
      'senderEmail': _auth.currentUser!.email,
      'reciverId': widget.receiverEmail,
      'message': '',
      'timestamp': Timestamp.now(),
      'type': 'Image',
      'filename': filename,
    });
    var ref =
        FirebaseStorage.instance.ref().child('images').child("$filename.jpg");
    var uploadTask = await ref.putData(imageBytes!).catchError((error) async {
      await _firestore
          .collection('chat_Rooms')
          .doc(ChatroomID)
          .collection('messages')
          .doc(filename)
          .delete();
      status = 0;
    });
    if (status == 1) {
      String imageUrl = await ref.getDownloadURL();
      await _firestore
          .collection('chat_Rooms')
          .doc(ChatroomID)
          .collection('messages')
          .doc(filename)
          .update({'message': imageUrl});
      print(imageUrl);
      try {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.receiverUid)
            .get();
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        print('fcmToken :' + data!['fcmToken']);
        var object = {
          'to': data['fcmToken'],
          'priority': 'high',
          'notification': {
            'title': _auth.currentUser!.displayName,
            'body': 'image'
          }
        };

        var response = await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'key=AAAADHtCBX4:APA91bFlK9ZKNKNP0c46KUBQRgnEpf4d1mXhjtjbZXO0Wcp3-zFTPYkKzqUNooJjw6NIwT7BCwlp0Zh9jQ8OpunTJcUk2GsHUj5pngLO-8CXiPPdhGzw0NCStfyryRIel6RkDhn5OTfH',
          },
          body: jsonEncode(object),
        );

        print(response.statusCode);
        print(response.body);
      } catch (Except) {
        print(Except);
      }
    }
  }

  void openMediaDialogue() {
    TextStyle style = GoogleFonts.ptSans(color: Colors.white);
    showDialog(
      context: widget.context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade900,
          title: Text(
            "Upload?",
            style:
                GoogleFonts.anton(fontSize: 35, color: Colors.white, shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              )
            ]),
          ),
          content: Container(
            height: 150,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        uploadImage();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/imageup.png',
                            width: 100,
                          ),
                          Text(
                            "Image",
                            style: style,
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: getVideo,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/videoup.png',
                            width: 100,
                          ),
                          Text('Video', style: style)
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: getAudio,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/audioup.png',
                            width: 100,
                          ),
                          Text(
                            'Audio',
                            style: style,
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: getDoc,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/docup.png',
                            width: 100,
                          ),
                          Text(
                            'PDFs',
                            style: style,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _buildMessageList(),
        ),
        _buildMessageInput(),
      ],
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(35),
            bottomRight: Radius.circular(35),
          )),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              openMediaDialogue();
            },
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: TextField(
              obscureText: false,
              controller: _messageController,
              style: GoogleFonts.ptSansCaption(
                color: Colors.white,
              ),
              cursorColor: Colors.teal,
              decoration: InputDecoration(
                hintText: ' Enter Message Here',
                hintStyle: GoogleFonts.ptSansCaption(
                  color: Colors.grey.shade500,
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 2.0),
            child: GestureDetector(
              onTap: sendMessage,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.teal.shade500,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  border: Border.all(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Icon(
                    Icons.send_rounded,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
        widget.receiverUid,
        _auth.currentUser!.uid,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {}
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No messages'),
          );
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });
        return ListView.builder(
          controller: _scrollController,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot document = snapshot.data!.docs[index];
            return _buildMessageItem(document);
          },
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var alignment = (data['senderId'] == _auth.currentUser!.uid)
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
    return SizedBox(
      width: 100,
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child:
                Text(data['senderName'], style: const TextStyle(fontSize: 12)),
          ),
          data['type'] == 'text'
              ? data['senderId'] == _auth.currentUser!.uid
                  ? data['edit'] == true
                      ? GestureDetector(
                          onLongPress: () {
                            _showBottomSheetDetails(data, true, document);
                          },
                          child: ChatBubble(
                            value: data['edit'] ?? false,
                            message: data['message'],
                            document: document,
                          ))
                      : GestureDetector(
                          onLongPress: () {
                            _showBottomSheetDetails(data, true, document);
                          },
                          child: ChatBubble(
                            value: data['edit'] ?? false,
                            message: data['message'],
                            document: document,
                          ))
                  : GestureDetector(
                      onLongPress: () {
                        _showBottomSheetDetails(data, false, document);
                      },
                      child: ChatBubble(
                        value: data['edit'] ?? false,
                        message: data['message'],
                        document: document,
                      ))
              : data['type'] == null
                  ? ChatBubble(
                      value: data['edit'] ?? false,
                      message: data['message'],
                      document: document,
                    )
                  : Container(
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(widget.context).size.width * 0.2,
                      decoration: BoxDecoration(
                        color: (data['senderId'] == _auth.currentUser!.uid)
                            ? Colors.teal.shade300
                            : Colors.grey.shade300,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () => _handleMediaTap(data),
                        onLongPress: () async {
                          if (_auth.currentUser!.uid == data['senderId']) {
                            _showBottomSheetDetails(data, true, document);
                          } else {
                            _showBottomSheetDetails(data, false, document);
                          }
                        },
                        child: data['type'] == 'Image'
                            ? Column(
                                crossAxisAlignment: alignment,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    child: CachedNetworkImage(
                                      imageUrl: data['message'],
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    DateFormat('hh:mm a').format(
                                      data['timestamp'].toDate(),
                                    ),
                                    style: GoogleFonts.ptSans(
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              )
                            : data['message'] == ''
                                ? Container(
                                    padding: EdgeInsets.all(20),
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : data['type'] == 'Video'
                                    ? Column(
                                        crossAxisAlignment: alignment,
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 92, 2, 105),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                            ),
                                            padding: const EdgeInsets.all(20),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Image.asset(
                                                  'assets/videoup.png',
                                                  width: 150,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            data['filename'],
                                            style: GoogleFonts.ptSans(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            DateFormat('hh:mm a').format(
                                              data['timestamp'].toDate(),
                                            ),
                                            style: GoogleFonts.ptSans(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      )
                                    : data['type'] == 'Audio'
                                        ? Column(
                                            crossAxisAlignment: alignment,
                                            children: [
                                              Container(
                                                decoration: const BoxDecoration(
                                                  color: Color.fromARGB(
                                                      255, 190, 190, 6),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(20),
                                                  ),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Image.asset(
                                                      'assets/audioup.png',
                                                      width: 150,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                data['filename'],
                                                style: GoogleFonts.ptSans(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Text(
                                                DateFormat('hh:mm a').format(
                                                  data['timestamp'].toDate(),
                                                ),
                                                style: GoogleFonts.ptSans(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          )
                                        : Column(
                                            crossAxisAlignment: alignment,
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                decoration: const BoxDecoration(
                                                  color: Color.fromARGB(
                                                      255, 155, 24, 24),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(20),
                                                  ),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      'assets/docup.png',
                                                      width: 150,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                data['filename'],
                                                style: GoogleFonts.ptSans(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Text(
                                                DateFormat('hh:mm a').format(
                                                  data['timestamp'].toDate(),
                                                ),
                                                style: GoogleFonts.ptSans(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                      ),
                    ),
        ],
      ),
    );
  }

  void _showBottomSheet() {
    showBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        context: widget.context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(
              20,
            ),
            height: 300,
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/mic.json',
                  width: 200,
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'Listning......',
                  style: GoogleFonts.ptSansCaption(
                    color: Colors.white,
                  ),
                )
              ],
            ),
          );
        });
  }

  void _showBottomSheetDetails(Map<String, dynamic> data, bool value,
      DocumentSnapshot documentSnapshot) {
    showBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        context: widget.context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(
              20,
            ),
            height: data['type'] == 'text' ? 500 : 600,
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: Column(
              children: [
                Container(
                  height: 2,
                  width: 100,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Details',
                      style: GoogleFonts.ptSans(
                        color: Colors.white,
                        fontSize: 40,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                data['type'] != 'text'
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info,
                            size: 50,
                            color: Colors.teal.shade400,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'File Name',
                                style: GoogleFonts.ptSans(
                                  fontSize: 25,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                data['filename'],
                                style: GoogleFonts.ptSans(
                                  fontSize: 18,
                                  color: Colors.teal.shade400,
                                ),
                              )
                            ],
                          ),
                        ],
                      )
                    : Container(),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.calendar_month,
                      size: 50,
                      color: Colors.teal.shade400,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('MMMM-dd').format(
                            data['timestamp'].toDate(),
                          ),
                          style: GoogleFonts.ptSans(
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          DateFormat('EEEE yyyy').format(
                            data['timestamp'].toDate(),
                          ),
                          style: GoogleFonts.ptSans(
                            fontSize: 18,
                            color: Colors.teal.shade400,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      data['type'] == 'Image'
                          ? Icons.image
                          : data['type'] == 'Video'
                              ? Icons.videocam
                              : data['type'] == 'Audio'
                                  ? Icons.audio_file
                                  : Icons.textsms,
                      size: 50,
                      color: Colors.teal.shade400,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Type',
                          style: GoogleFonts.ptSans(
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          data['type'],
                          style: GoogleFonts.ptSans(
                            fontSize: 18,
                            color: Colors.teal.shade400,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                data['type'] == 'text'
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.backup,
                            size: 50,
                            color: Colors.teal.shade400,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.only(
                                left: 10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'BackUp URL',
                                    style: GoogleFonts.ptSans(
                                      fontSize: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Text(
                                      data['message'],
                                      style: GoogleFonts.ptSans(
                                        fontSize: 18,
                                        color: Colors.teal.shade400,
                                      ),
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 5,
                    right: 5,
                    bottom: 10,
                  ),
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                data['type'] == 'text'
                    ? data['senderId'] == _auth.currentUser!.uid
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      try {
                                        await FirebaseFirestore.instance
                                            .collection('chat_Rooms')
                                            .doc(ChatroomID)
                                            .collection('messages')
                                            .doc(documentSnapshot.id)
                                            .update({
                                          'message': 'Message Deleted',
                                          'type': null
                                        });
                                        Navigator.of(context).pop();
                                      } catch (e) {
                                        print(e);
                                      }
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      size: 40,
                                      color: Colors.teal.shade500,
                                    ),
                                  ),
                                  Text(
                                    "Delete?",
                                    style: GoogleFonts.ptSans(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      showEditBox(documentSnapshot);
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      size: 40,
                                      color: Colors.teal.shade400,
                                    ),
                                  ),
                                  Text(
                                    "Edit?",
                                    style: GoogleFonts.ptSans(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  )
                                ],
                              )
                            ],
                          )
                        : Container()
                    : data['senderId'] == _auth.currentUser!.uid
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () async {},
                                    icon: Icon(
                                      Icons.download,
                                      size: 40,
                                      color: Colors.teal.shade500,
                                    ),
                                  ),
                                  Text(
                                    "Save?",
                                    style: GoogleFonts.ptSans(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection('chat_Rooms')
                                          .doc(ChatroomID)
                                          .collection('messages')
                                          .doc(documentSnapshot.id)
                                          .update({
                                        'message': 'Message Deleted',
                                        'type': null
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      size: 40,
                                      color: Colors.teal.shade500,
                                    ),
                                  ),
                                  Text(
                                    "Delete?",
                                    style: GoogleFonts.ptSans(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  )
                                ],
                              )
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.download,
                                      size: 40,
                                      color: Colors.teal.shade500,
                                    ),
                                  ),
                                  Text(
                                    "Save?",
                                    style: GoogleFonts.ptSans(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          )
              ],
            ),
          );
        });
  }

  void _handleMediaTap(Map<String, dynamic> data) {
    data['type'] == 'Image'
        ? Navigator.of(widget.context).push(
            MaterialPageRoute(
              builder: (context) => ImagePage(imageUrl: data['message']),
            ),
          )
        : Navigator.of(widget.context).push(
            MaterialPageRoute(
              builder: (context) => VideoPlayerView(videoURL: data['message']),
            ),
          );
  }

  void showEditBox(DocumentSnapshot documentSnapshot) async {
    TextEditingController textEditingController = TextEditingController();
    (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.grey.shade900,
            title: Text(
              'Enter The New Message',
              style: GoogleFonts.ptSans(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              TextFormField(
                controller: textEditingController,
                obscureText: false,
                style: GoogleFonts.ptSansCaption(
                  color: Colors.white,
                ),
                cursorColor: Colors.teal,
                decoration: InputDecoration(
                  hintText: ' Enter Message Here',
                  hintStyle: GoogleFonts.ptSansCaption(
                    color: Colors.grey.shade400,
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (textEditingController.text.isNotEmpty) {
                        Navigator.of(context).pop();
                        try {
                          await FirebaseFirestore.instance
                              .collection('chat_Rooms')
                              .doc(ChatroomID)
                              .collection('messages')
                              .doc(documentSnapshot.id)
                              .update({
                            'message': textEditingController.text,
                            'type': 'text',
                            'edit': true,
                          });
                        } catch (e) {
                          print(e);
                        }
                      }
                    },
                    child: Text(
                      'Done',
                      style: GoogleFonts.ptSans(
                        fontSize: 20,
                        color: Colors.teal.shade500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )) ??
        false;
  }
}
