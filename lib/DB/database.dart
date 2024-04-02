import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DataBase {
  //var
  final database = FirebaseDatabase.instance.ref();

  //func insert
  void insertMessages(String msgId,String name, String msg, String id, String roomId, String date, String time) {
    database.child(roomId).child('msg').child(msgId).set({
      'type': 'text',
      'id': id,
      'index': msgId.split(' ')[1],
      'name': name,
      'msg': msg,
      'date': date,
      'time': time,
      'reply': false,
    });
  }
  void insertReplyMessages(String msgId,String name, String msg, String id, String roomId, String date, String time, Map friendMessage) {
    database.child(roomId).child('msg').child(msgId).set({
      'type': 'text',
      'id': id,
      'index': msgId.split(' ')[1],
      'name': name,
      'msg': msg,
      'date': date,
      'time': time,
      'reply': true,
      'to': friendMessage,
    });
  }
  void insertVoice(String msgId,String name, String id, String roomId, String date, String time, String voiceUrl) {
    database.child(roomId).child('msg').child(msgId).set({
      'type': 'voice',
      'voiceUrl' : voiceUrl,
      'id': id,
      'index': msgId.split(' ')[1],
      'name': name,
      'date': date,
      'time': time,
      'reply': false,
    });
  }

  //Delete Message
  void deleteMessage(String roomId, String index) async {
    await database.child(roomId).child('msg').child('msg $index').child('msg').remove();
  }


  //func fetch
  Future<Iterable<DataSnapshot>> fetch(String roomId) {
    final data = database.child(roomId).get();
    return data.then((value) => value.children);
  }

  //func call
  Query CallMessages(String roomId) {
    return database.child(roomId).child('msg');
  }

  //my state in chat
  MyChatState(String roomId, String id, String state) {
    database.child(roomId).child(id).update({
      'state': state,
    });
  }

  //CHAT STATE OF MY FRIEND
  FriendChatState(String roomId, String friendId) {
    return database.child(roomId).child(friendId).child('state').get().then((value) => value.value);
  }

  //func length
  length(String roomId) {
    final data = database.child(roomId).child('msg').get();
    return data.then((value) => value.children.length);
  }
}