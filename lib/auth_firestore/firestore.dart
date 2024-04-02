import 'package:chatapp/auth_firestore/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStore {
  //firestore
  final _usersfirestore = FirebaseFirestore.instance.collection('users');

  //func online / offline
  void OnlineOffline(String status) async {
    await _usersfirestore.doc(User().id).update({
      'status': status,
      'id': User().id,
    });
  }

  //fetch
  Fetch(String id) {
    return _usersfirestore.doc(id).get().then((value) => value.data());
  }
  FetchFriendLength(String id) async {
    return _usersfirestore.doc(id).collection('direct').get().then((value) => value.docs.length);
  }
  FetchGroupsLength(String id) async {
    return _usersfirestore.doc(id).collection('groups').get().then((value) => value.docs.length);
  }

  //create contact
  void CreateContact(String userId, String directId, String friendEmail, String friendId, String friendUsername, String friendStatus, String friendPfp, String friendName) async {
    await _usersfirestore.doc(userId).collection('direct').doc(directId).set({
      'email': friendEmail,
      'id': friendId,
      'username': friendUsername,
      'status': friendStatus,
      'pfpurl': friendPfp,
      'name': friendName,
    });
  }

  //search
  Search(String username) async {
    return _usersfirestore.where('username', isGreaterThanOrEqualTo: username).get().then(
      (value) => value.docs.map((e) => e.data())
    );
  }
}