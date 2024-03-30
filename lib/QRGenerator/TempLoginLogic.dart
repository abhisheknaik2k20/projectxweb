import 'package:firebase_auth/firebase_auth.dart';

class TempLoginLogic {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future signinTemp() async {
    try {
      await _auth.signInAnonymously();
      User? user = _auth.currentUser;
      return user;
    } catch (e) {
      print(e.toString());
    }
  }
}
