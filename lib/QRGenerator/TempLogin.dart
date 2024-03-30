// ignore_for_file: file_names
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:projectxweb/HomePage.dart';
import 'package:projectxweb/QRGenerator/IPDATA.dart';
import 'package:projectxweb/QRGenerator/TempLoginLogic.dart';

class TempAccountCreate extends StatefulWidget {
  const TempAccountCreate({super.key});

  @override
  State<TempAccountCreate> createState() => _TempAccountCreate();
}

class _TempAccountCreate extends State<TempAccountCreate> {
  TempLoginLogic logic = TempLoginLogic();
  User? user;
  late IPData ipdata;

  @override
  void initState() {
    super.initState();
    printIP();
    expectedLogin();
  }

  Future<IPData> printIP() async {
    try {
      final response = await Dio().get('https://ipinfo.io/json');
      if (response.statusCode == 200) {
        final data = response.data;
        print(data['ip']);
        print(data['city']);
        print(data['region']);
        ipdata = IPData(
            ipaddress: data['ip'],
            location: data['city'],
            city: data['region'],
            timestamp: Timestamp.now());
      } else {
        throw Exception('Failed to load IP address details');
      }
    } catch (error) {
      print('Error fetching IP address details: $error');
    }
    return ipdata;
  }

  void expectedLogin() async {
    user = await logic.signinTemp();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return user == null
        ? Container(
            color: Colors.grey.shade400,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.teal.shade400,
              ),
            ),
          )
        : StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.data() != null) {
                  print('successs');
                  ScanLogin(snapshot.data!.data()!['email'],
                      snapshot.data!.data()!['password'], user!.uid, ipdata);
                  return Container(
                    color: Colors.grey.shade400,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.teal.shade400,
                      ),
                    ),
                  );
                } else {
                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.teal.shade400,
                      centerTitle: true,
                      title: Text(
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
                    backgroundColor: Colors.teal.shade400,
                    body: Stack(
                      children: [
                        Column(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.teal.shade400,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 117, 117, 117),
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(100.0),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(30),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                  offset: const Offset(15, 7),
                                )
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: QrImageView(
                                      data:
                                          user!.uid + 'projectx-223eb.web.app',
                                      version: QrVersions.auto,
                                      size: 400.0,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 30),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            "To use the app on Desktop:-",
                                            style: GoogleFonts.roboto(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Flexible(
                                          child: Text(
                                            "1. Open the App on you're device",
                                            style: GoogleFonts.roboto(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                "2. Tap on ",
                                                style: GoogleFonts.roboto(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(5),
                                                ),
                                                color: Colors.grey.shade700,
                                              ),
                                              child: const Icon(
                                                Icons.menu,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                " and select ",
                                                style: GoogleFonts.roboto(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(5),
                                                ),
                                                color: Colors.grey.shade700,
                                              ),
                                              child: const Icon(
                                                Icons.laptop,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                " WEB-Login",
                                                style: GoogleFonts.roboto(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Flexible(
                                          child: Text(
                                            "3. Point your device to capture the code",
                                            style: GoogleFonts.roboto(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 40,
                                        ),
                                        Flexible(
                                          child: TextButton(
                                              onPressed: () {},
                                              child: Text(
                                                "Need help getting started ?",
                                                style: GoogleFonts.roboto(
                                                  fontSize: 20,
                                                  color: Colors.teal.shade400,
                                                ),
                                              )),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              } else {
                return Container(
                  color: Colors.grey.shade400,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.teal.shade400,
                    ),
                  ),
                );
              }
            },
          );
  }

  Future<Map<String, dynamic>?> getClientDetails() async {
    final response = await http.get(Uri.parse('https://ipapi.co/json/'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      print('Failed to load client details: ${response.statusCode}');
      return null;
    }
  }

  Future<void> ScanLogin(
      String email, String password, String USERID, IPData ipData) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(USERID).delete();
      print('deleted');
      await FirebaseAuth.instance.currentUser!.delete();
      print('siging out');
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print('signing in...');
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'WEB': USERID});
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('WEB')
          .doc(USERID)
          .set({
        'IP Address': ipdata.ipaddress,
        'City': ipdata.location,
        'Region': ipdata.city,
        'TimeStamp': ipdata.timestamp
      });
    } catch (Exception) {
      print(Exception);
    }

    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
      builder: (context) {
        return const HomePage();
      },
    ), (route) => false);
  }
}
