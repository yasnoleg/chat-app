import 'package:chatapp/auth_firestore/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class Sign {
  //SIGNUP
  void SignUp(String email, String password) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
  }

  //SIGNIN
  void SignIn(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  }

  //SIGNOUT
  void SignOut() async {
    await FirebaseAuth.instance.signOut();
    FireStore().OnlineOffline('Offline');
  }

  //CHANGE USERNAME
  void ChangeUsername(String NewUsername) async {
    await FirebaseAuth.instance.currentUser!.updateDisplayName(NewUsername);
  }
}

class User {
  //
  final currentUser = FirebaseAuth.instance.currentUser!;
  //
  final id = FirebaseAuth.instance.currentUser!.uid;
  final email = FirebaseAuth.instance.currentUser!.email;
  final username = FirebaseAuth.instance.currentUser!.displayName;
  final pfpurl = FirebaseAuth.instance.currentUser!.photoURL;
}