import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  int selectedindex = 0;
  final name = TextEditingController();
  final last = TextEditingController();
  final email = TextEditingController();
  final message = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.85,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'GET IN TOUCH',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 40,
            ),
          ),
          const Text(
            "Have any Questions? We'd love to hear from you ",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 200.0,
                right: 200,
                top: 5,
                bottom: 5,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).height * 0.75,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                              left: 20,
                            ),
                            child: Text(
                              'Drop a Message',
                              style: TextStyle(
                                color: Colors.teal.shade400,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.15,
                                      child: TextFormField(
                                        controller: name,
                                        decoration: const InputDecoration(
                                          hintText: 'First Name',
                                          focusColor: Colors.teal,
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.teal),
                                          ),
                                        ),
                                        cursorColor: Colors.teal,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.15,
                                      child: TextFormField(
                                        controller: last,
                                        decoration: const InputDecoration(
                                          hintText: 'Last Name',
                                          focusColor: Colors.teal,
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.teal),
                                          ),
                                        ),
                                        cursorColor: Colors.teal,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width * 0.3,
                                  child: TextFormField(
                                    controller: email,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: const InputDecoration(
                                      hintText: 'Email',
                                      focusColor: Colors.teal,
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.teal),
                                      ),
                                    ),
                                    cursorColor: Colors.teal,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  width: MediaQuery.sizeOf(context).width * 0.3,
                                  child: TextFormField(
                                    controller: message,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 4,
                                    decoration: const InputDecoration(
                                      hintText: 'Message Here',
                                      focusColor: Colors.teal,
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                      ),
                                      disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                      ),
                                    ),
                                    cursorColor: Colors.teal,
                                  ),
                                ),
                                Text(
                                  'Rate your experience so far.....',
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedindex = 1;
                                        });
                                      },
                                      icon: Icon(Icons.star_border,
                                          color: selectedindex >= 1
                                              ? Colors.yellow
                                              : Colors.grey),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedindex = 2;
                                        });
                                      },
                                      icon: Icon(Icons.star_border,
                                          color: selectedindex >= 2
                                              ? Colors.yellow
                                              : Colors.grey),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedindex = 3;
                                        });
                                      },
                                      icon: Icon(Icons.star_border,
                                          color: selectedindex >= 3
                                              ? Colors.yellow
                                              : Colors.grey),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedindex = 4;
                                        });
                                      },
                                      icon: Icon(Icons.star_border,
                                          color: selectedindex >= 4
                                              ? Colors.yellow
                                              : Colors.grey),
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      Colors.teal,
                                    ),
                                  ),
                                  onPressed: () {
                                    if (name.text.isEmpty ||
                                        last.text.isEmpty ||
                                        email.text.isEmpty ||
                                        message.text.isEmpty) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Incomplete Details'),
                                            content: Text(
                                                'Please fill out all the details.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                },
                                                child: Text(
                                                  'OK',
                                                  style: TextStyle(
                                                    color: Colors.teal,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      if (selectedindex == 0) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Please Rate us'),
                                              content: Text(
                                                  'Please Rate us before Submitting.'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // Close the dialog
                                                  },
                                                  child: Text(
                                                    'OK',
                                                    style: TextStyle(
                                                      color: Colors.teal,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Request Submitted'),
                                              content: Text(
                                                'We shall look into it as soon as possible.',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // Close the dialog
                                                  },
                                                  child: Text(
                                                    'OK',
                                                    style: TextStyle(
                                                      color: Colors.teal,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );

                                        setState(() {
                                          name.clear();
                                          last.clear();
                                          email.clear();
                                          message.clear();
                                          selectedindex = 0;
                                        });
                                      }
                                    }
                                  },
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20.0,
                        bottom: 20.0,
                      ),
                      child: Container(
                        width: 1,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(
                          top: 10,
                          left: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Contact Info',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.locationPin,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                Text(
                                  '  Mumbai Bandra',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.mail,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                Text(
                                  '  projectx-e-233@gmail.com',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.phone,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                Text(
                                  '  +91-88307-53536',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Text(
                              'You can also find us on',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.facebook,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Icon(
                                  FontAwesomeIcons.linkedin,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Icon(
                                  FontAwesomeIcons.twitter,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Icon(
                                  FontAwesomeIcons.whatsapp,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
