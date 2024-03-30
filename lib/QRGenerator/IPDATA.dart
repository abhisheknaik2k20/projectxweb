import 'package:cloud_firestore/cloud_firestore.dart';

class IPData {
  String ipaddress;
  String location;
  String city;
  Timestamp timestamp;
  IPData({
    required this.ipaddress,
    required this.location,
    required this.city,
    required this.timestamp,
  });
}
