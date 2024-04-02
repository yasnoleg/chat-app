
import 'dart:io';

import 'package:chatapp/DB/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class Storage {

  //intance
  final storage = FirebaseStorage.instance.ref();

  //Upload voice 
  UploadVoice(String roomId, String path, String msgId, String name, String id, String date, String time) async {
    try {
      UploadTask uploadTask = storage.child('$roomId/${msgId}.mp3').putFile(File(path));
      String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    } catch (e) {
      print('ERROE OCCURED WHILE UPLOADING TO FIREBASE ${e.toString()}');
    }
    print('YOUR FILE URL IS : ${await GetFileUrl(roomId,msgId)}');

    DataBase().insertVoice(msgId, name, id, roomId, date, time, '${await GetFileUrl(roomId,msgId)}');
  }

  //Get URL of voice
  GetFileUrl(String roomId, String msgId) {
    final data = storage.child(roomId).child('${msgId}.mp3').getDownloadURL();
    return data.then((value) => value);
  }
}

class Audio {
  //
  CreateDirectory() async {
    //get app directory
    Directory directory = await getApplicationCacheDirectory();

    //create our own directory
    String filepath = directory.path + '/' + DateTime.now().millisecondsSinceEpoch.toString();
  }
}