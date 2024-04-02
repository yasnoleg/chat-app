import 'dart:io';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatapp/DB/storage.dart';
import 'package:chatapp/components/audio/audioplayer.dart';
import 'package:chatapp/tools/ui_tools.dart';
import 'package:chatapp/DB/database.dart';
import 'package:chatapp/auth_firestore/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:swipe_to/swipe_to.dart';

class ChatPage extends StatefulWidget { 
  String email;
  String id;
  String username;
  String roomId;
  String pfpUrl;
  String Status;
  String name;
  ChatPage({super.key, required this.email, required this.id, required this.username, required this.roomId, required this.pfpUrl, required this.Status,required this.name});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with  TickerProviderStateMixin, WidgetsBindingObserver{

  //Controller
  final _msgcontroller = TextEditingController();
  late AnimationController lottieController;
  final player = AudioPlayer();

  //Time Date
  DateTime date = DateTime.now();

  //Vars
  String fill = 'empty';
  bool displayBlur = false;
  late final Status;
  HexColor? couleur;
  String state = '';
  String status = '';
  String Name = '';
  bool visibility = true;
  bool allowSendingMessage = true;
  bool reply = false;

  //maps
  List? messages = [];

  //position
  double? dx;
  double? dy;

  //message size
  double? h;
  double? w;

  //GlobalKey
  GlobalKey ItemKeY = GlobalKey();

  //datasnapshot
  Map? shotsnap;
  String? kEy;

  //record voice 
  final recorder = FlutterSoundRecorder();
  final voicePlayer = FlutterSoundPlayer();
  String? fileName;
  bool isRecorderReady = false;
  bool isRecording = false;

  Future record() async {
    if (!isRecorderReady) return;

    await recorder.startRecorder(toFile: 'audio');

  }

  Future stop() async {
    if (!isRecorderReady) return;

    final path = await recorder.stopRecorder();
  }

  Future send(String msgId, String name, String id, String date, String time, ) async {
    if (!isRecorderReady) return;

    final path = await recorder.stopRecorder();
    final audioFile = File(path!);
    
    Storage().UploadVoice(widget.roomId, path, msgId, name, id, date, time);
  }

  Future initRecorder() async {
    final microStatus = await Permission.microphone.request();

    if (microStatus != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }

    await recorder.openRecorder();

    isRecorderReady = true;

    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }



  //func
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
    value: 0.2
  )..forward();
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.linearToEaseOut,
  );

  @override
  void dispose() {
    _controller.dispose();
    recorder.closeRecorder();
    super.dispose();
  }

  GetChatStateOfFriend() async {
    //get chat state of my friend
    var data = await DataBase().FriendChatState(widget.roomId, widget.id);
    setState(()  => state =  data);
  }

  //get State of friend anytime (allways)
  FriendState(String roomId) {
    DataBase().database.child(roomId).child(widget.id).onValue.listen((event) {
      var data = event.snapshot;
      setState(() => state = data.child('state').value.toString());
      if(data.child('state').value == 'seeing'){
        Future.delayed(Duration(seconds: 5), () {
          setState(() => visibility = false);
        });
      }else{
        setState(() => visibility = true);
      }
     });
  }

  //get Status of friend anytime (allways)
  FriendStatus() async {
    await FirebaseFirestore.instance.collection('users').doc(widget.id).snapshots().listen((event) { 
      var data = event.data();
      setState(() => status = data!['status']);
    });
  }

  //get Status of friend anytime (allways)
  FriendName() async {
    await FirebaseFirestore.instance.collection('users').doc(User().id).snapshots().listen((event) { 
      var data = event.data();
      setState(() => Name = data!['name']);
    });
  }

  //fetch messages
  GetMessages(String roomId) {
    DataBase().database.child(roomId).child('msg').onValue.listen((event) {
      messages!.clear();
      Map<dynamic, dynamic> values = event.snapshot.value as Map;
      values.forEach((key, value) { 
        setState(() {
          messages?.add(value);
        });
      });
      QuickSortMaList();
    });
  }

  //quick sort to order MESSAGES
  int min = 0;
  Map temp = {};
  QuickSortMaList() {
    for (var i = 0; i < (messages!.length - 1); i++) {
      min = i;
      for (var j = i+1; j < messages!.length + 0; j++) {
        if(int.parse(messages![j]['index']) < int.parse(messages![min]['index'])){
          setState(() {
            min = j;
          });
        }
      }
      setState(() {
        temp = messages![i];
        messages![i] = messages![min];
        messages![min] = temp;
      });
    }
  }

  //get offset of message
  getSourceWidgetOffset(BuildContext context) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    return offset;
  }

  String url = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initRecorder();

    //get chat state of my friend
    Future.delayed(Duration(milliseconds: 300), () {
      GetChatStateOfFriend();
    });

    //frind status
    Future.delayed(Duration(milliseconds: 10), () {
      FriendStatus();
    });

    //frind name
    Future.delayed(Duration(milliseconds: 10), () {
      FriendName();
    });

    //change my state
    DataBase().MyChatState(widget.roomId, User().id, 'seeing');

    //Get Messages
   Future.delayed(Duration(milliseconds: 5), () {
     GetMessages(widget.roomId);
   });

  }

  //WHEN I COME IN/ GO OUT OF THE CONVERSATION 
 @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      DataBase().MyChatState(widget.roomId, User().id, 'seeing');
    } else {
      DataBase().MyChatState(widget.roomId, User().id, 'see');
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    //Height Width
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double topPadding = MediaQuery.of(context).padding.top;
    double safeAreaHeight = MediaQuery.of(context).viewInsets.bottom;
    double safeAreaHeightBottom = MediaQuery.of(context).viewInsets.bottom;

    //Selected widget
    SelectedMessage(double height, double width, Map Message, String key, HexColor color) {
      return Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                displayBlur = false;
                allowSendingMessage = true;
              });
            },
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: width*0.6
              ),
              child: Container(
                padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 4),
                decoration: BoxDecoration(
                  border: Border.all(width: 0.1),
                  color: color,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(height*0.02),topRight: Radius.circular(height*0.02),bottomLeft: Radius.circular(height*0.02),bottomRight: Radius.circular(height*0.02)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Message['msg'],style: MessageStyle,),
                    SizedBox(height: height*0.005),
                    Text(Message['time'],style: TextStyle(fontSize: 8),),
                  ],
                ),
              ),
            )
          ),
        ],
      );
    }

    //Widget Appbar
    AppBar appBar = AppBar(
          titleSpacing: 3,
          elevation: 0,
          toolbarHeight: height*0.12,
          backgroundColor: FirstColor,
          leading: IconButton(onPressed: () {
            Navigator.of(context).pop();
            DataBase().MyChatState(widget.roomId, User().id, 'seen');
            }, 
            icon: Image.asset('asset/icons/angle-gauche.png',height: height*0.03,width: height*0.03,scale: 26,)),
          title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(widget.pfpUrl,height: height*0.065,width: height*0.065,),
                ),
                SizedBox(width: height*0.022,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.name,style: TextStyle(color: Black,fontFamily: 'H2',fontSize: height*0.028,fontWeight: FontWeight.w900,letterSpacing: 0),),
                    Row(
                      children: [
                        Text(status + ', ',style: TextStyle(color: Black,fontFamily: 'H4',fontSize: height*0.015,fontWeight: FontWeight.w200,letterSpacing: 0),),
                        Text(state == 'taping' ? 'taping...' : state,style: TextStyle(color: Black,fontFamily: 'H4',fontSize: height*0.015,fontWeight: FontWeight.w200,letterSpacing: 0),),
                      ],
                    ),
                  ],
                ),
                Expanded(child: SizedBox(width: width*0.01,)),
                IconButton(onPressed: () async {
                  player.play(UrlSource('https://firebasestorage.googleapis.com/v0/b/chatapp-ce8c6.appspot.com/o/FZSlO8fjXFcTQ8bwgl8OVWQYHym1_hsOSvCqQxKgicCUZSj1GXNnMr4k2%2Fvoice.mp3?alt=media&token=8a9c3e64-5cf2-4bf6-8eab-49500a00b60c'));
                  
                }, icon: Image.asset('asset/icons/camera-video-alt.png',height: height*0.03,width: height*0.03,)),
                IconButton(onPressed: () async {
                  player.stop();
                }, icon: Image.asset('asset/icons/phoneCall.png',height: height*0.05,width: height*0.05,scale: 2,)),
                SizedBox(width: width*0.01,),
              ],
            ),
          );

    //appbar height
    double appBarHeight = appBar.preferredSize.height;


    List urls = [
      'https://firebasestorage.googleapis.com/v0/b/chatapp-ce8c6.appspot.com/o/FZSlO8fjXFcTQ8bwgl8OVWQYHym1_hsOSvCqQxKgicCUZSj1GXNnMr4k2%2Fvoice5.mp3?alt=media&token=4325c6bd-435a-4121-aea8-21b2b7dba0f6',
      'https://firebasestorage.googleapis.com/v0/b/chatapp-ce8c6.appspot.com/o/FZSlO8fjXFcTQ8bwgl8OVWQYHym1_hsOSvCqQxKgicCUZSj1GXNnMr4k2%2Fvoice2.mp3?alt=media&token=04261706-bc25-4337-8663-f4829a88e47e',
      'https://firebasestorage.googleapis.com/v0/b/chatapp-ce8c6.appspot.com/o/FZSlO8fjXFcTQ8bwgl8OVWQYHym1_hsOSvCqQxKgicCUZSj1GXNnMr4k2%2Fvoice.mp3?alt=media&token=8a9c3e64-5cf2-4bf6-8eab-49500a00b60c',
    ];


    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
        return DataBase().MyChatState(widget.roomId, User().id, 'seen');
      },
      child: Scaffold(
        backgroundColor: FirstColor,
        appBar: appBar,
        body: ClipRRect(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(height*0.035),topRight: Radius.circular(height*0.035)),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('asset/backgrounds/light_back_1.jpg'),
                fit: BoxFit.cover
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(bottom: height*0.006),
              child: Stack(
                children: [
                  SizedBox(
                    height: height,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      reverse: true,
                      child: StreamBuilder(
                        stream: FirebaseDatabase.instance.ref().child(widget.roomId).child('msg').onValue,
                        builder: (context, snapshot) {
                          return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: messages!.length,
                            itemBuilder: (context, index) {
                              //export data from database
                              final snap = snapshot.data!.snapshot;
                              final data = snap.value;
                              final key = snap.key;
                              //create Globalkey
                              final TikKeyGlo = GlobalKey<FormState>(debugLabel: '$index');

                              if (messages![index]['type'] == 'voice') {
                                return Padding(
                                  padding: EdgeInsets.only(right: width*0.02,bottom: height*0.003),
                                  child: Row(
                                    children: [
                                      Expanded(child: SizedBox(width: width*.005,)),
                                      AudioPlayerWidget(audioUrl: messages![index]['voiceUrl'],),
                                    ],
                                  ),
                                );
                              } else {
                                if (messages![index]['id'] == User().id) {
                                  return Padding(
                                        padding: EdgeInsets.only(left: 0,right: width*0.02,top: 1,bottom: 2),
                                        child: Row(
                                          key: TikKeyGlo,
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            SwipeTo(
                                              onLeftSwipe: () {
                                                setState(() {
                                                  shotsnap = messages![index];
                                                  reply = true;
                                                });
                                              },
                                              child: GestureDetector(
                                                onDoubleTap: () {
                                                  snap.child('msg ${index+1}').child('reaction').ref.update({
                                                    User().id : User().email
                                                  });
                                                },
                                                onLongPress: () {
                                                  Offset position = getSourceWidgetOffset(TikKeyGlo.currentContext!);
                                                  Size? size = TikKeyGlo.currentContext!.size;
                                                  setState(() {
                                                    shotsnap = messages![index];
                                                    couleur = SecondColor;
                                                    kEy = key;
                                                    h = size!.height;
                                                    w = size.width;
                                                    displayBlur = true;
                                                  });
                                                },
                                                child: ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                    maxWidth: width*0.6
                                                  ),
                                                  child: Container(
                                                    padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 4),
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Color.fromARGB(255, 224, 222, 222),
                                                          blurRadius: 0,
                                                        ),
                                                      ],
                                                      border: Border.all(width: 0.1),
                                                      color: SecondColor,
                                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(height*0.02),topRight: Radius.circular(height*0.02),bottomLeft: Radius.circular(height*0.02),bottomRight: Radius.circular(4)),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(messages![index]['msg'],style: MessageStyle,),
                                                        SizedBox(height: height*0.005,),
                                                        Text(messages![index]['time'],style: TextStyle(fontSize: 8),),
                                                        messages![index]['reaction'] != null ? Container(
                                                          height: height*0.03,
                                                          width: height*0.05,
                                                          decoration: BoxDecoration(
                                                            color: White,
                                                            borderRadius: BorderRadius.circular(height*0.04),
                                                          ),
                                                          child: Lottie.asset('asset/animations/heart_like.json',repeat: false),
                                                        ) : Container()
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                } else {
                                  return Container();
                                }
                              }
                            }
                          );
                        }
                      ),
                    ),
                  ),

                  //Animation of seeing / taping ...
                  Align(
                    alignment: Alignment(-1, 1),
                    child: state == 'taping' 
                    ? Lottie.asset('asset/animations/animation_lm4u2c6b.json',width: height*0.15,height: height*0.15) 
                    : state == 'seeing' 
                      ? Visibility(
                        visible: visibility,
                        child: Lottie.asset('asset/animations/animation_lm4ues1o.json',width: height*0.14,height: height*0.14,repeat: false,)) 
                      : Container(),
                  ),

                  //Blur
                  displayBlur == true ? SizedBox.expand(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 7,sigmaY: 7),
                      child: Container(),
                    ),
                  ) : Container(),
                  displayBlur == true ? Positioned(
                    left:(( width/4)),
                    top: height-(height/2)-(height/4.7)-h!,
                    right: ( width/4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SelectedMessage(height, width, shotsnap!, kEy!, couleur!),
                        SizedBox(height: height*0.01,),
                        Container(
                          height: height*0.3,
                          width: w!,
                          decoration: BoxDecoration(
                            color: Black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(height*0.015),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: shotsnap!['msg']));
                                }, 
                                child: Text('Copy',style: TextStyle(color: White,fontSize: height*0.02,fontFamily: 'TEXT',fontWeight: FontWeight.w500),),
                              ),
                              Divider(),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    displayBlur = false;
                                    reply = true;
                                  });
                                }, 
                                child: Text('Replay',style: TextStyle(color: White,fontSize: height*0.02,fontFamily: 'TEXT',fontWeight: FontWeight.w500),),
                              ),
                              Divider(),
                              TextButton(
                                onPressed: () {}, 
                                child: Text('Forward',style: TextStyle(color: White,fontSize: height*0.02,fontFamily: 'TEXT',fontWeight: FontWeight.w500),),
                              ),
                              Divider(),
                              TextButton(
                                onPressed: () {
                                  DataBase().deleteMessage(widget.roomId, shotsnap!['index']);
                                  setState(() {
                                    displayBlur = false;
                                  });
                                }, 
                                child: Text('Delete',style: TextStyle(color: White,fontSize: height*0.02,fontFamily: 'TEXT',fontWeight: FontWeight.w500),),
                              ),
                            ],
                          ),
                      ),
                      ],
                    ),) 
                    : Container(),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: recorder.isRecording ? 
        Container(
          decoration: BoxDecoration(
            color: White,
          ),
          child: StreamBuilder<RecordingDisposition>(
            stream: recorder.onProgress,
            builder: (context, snapshot) {
              final duration = snapshot.hasData ? snapshot.data!.duration : Duration.zero; 
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('${duration.inSeconds} s',style: TextStyle(color: Black,fontFamily: 'TEXT')),
                  GestureDetector(
                    onTap: () async {
                      int num = await DataBase().length(widget.roomId);
                      await send('voice ${num+1}', Name, User().id, DateFormat('dd/MM/yyyy').format(date).toString(), DateFormat.jm().format(date).toString());
                      setState(() {
                        isRecorderReady = false;
                      });
                    },
                    child: Text('SEND',style: TextStyle(color: SecondColor,fontFamily: 'TEXT'),),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await stop();
                      setState(() {
                        isRecorderReady = false;
                      });
                    },
                    child: Text('CANCEL',style: TextStyle(color: SecondColor,fontFamily: 'TEXT'),),
                  ),
                  IconButton(
                    onPressed: () {}, 
                    icon: AvatarGlow(
                      glowColor: FirstColor,
                      endRadius: 20,
                      duration: Duration(milliseconds: 2000),
                      repeat: true,
                      showTwoGlows: true,
                      curve: Curves.easeOutQuad,
                      child: Container(
                        height: height*0.01,
                        width: height*0.01,
                        decoration: BoxDecoration(
                          color: SecondColor,
                          borderRadius: BorderRadius.circular(height),
                        ),
                        child: IconButton(
                          onPressed: () {}, 
                          icon: Image.asset('asset/icons/avion-en-papier.png',height: height*0.008,width: height*0.008,scale: 1,color: White,),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          ),
        ) : Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SizedBox(
            height: reply == true ? height*0.12 : height*0.06,
            child: Column(
              children: [
                reply == true ? Container(
                  height: height*0.06,
                  width: width,
                  decoration: BoxDecoration(
                    color: White
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: width*0.05,right: width*0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(shotsnap!['name'],style: TextStyle(fontFamily: 'H4',color: SecondColor,fontWeight: FontWeight.w900,fontSize: height*0.022),maxLines: 1,),
                        Row(
                          children: [
                            Container(height: height*0.02,width: width*0.01,decoration: BoxDecoration(borderRadius: BorderRadius.circular(height*0.005),color: SecondColor,),),
                            SizedBox(width: width*0.02,),
                            SizedBox(width: width*0.7,child: Text(shotsnap!['msg'],style: TextStyle(fontFamily: 'TEXT',fontSize: height*0.017),maxLines: 1,overflow: TextOverflow.fade,softWrap: false,)),
                            Expanded(child: SizedBox(width: width*0.001,),),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  reply = false;
                                });
                              },
                              child: Icon(Icons.cancel_outlined,color: Colors.grey[400],size: height*0.023,)
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ) : Container(),
                Container(
                  decoration: BoxDecoration(
                  color: White
                  ),
                  constraints: BoxConstraints(
                    maxHeight: height*0.06
                  ),
                  child: Row(
                    children: [
                      IconButton(onPressed: () { }, icon: Image.asset('asset/icons/rayon-de-sourire.png',color: Colors.grey[500],height: height*0.03,)),
                      Expanded(
                        child: TextField(
                          readOnly: !allowSendingMessage,
                          controller: _msgcontroller,
                          maxLines: 10,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: height*0.01,horizontal: width*0.01),
                            labelText: 'Message',
                            isCollapsed: true,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            hintStyle: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'H4',
                              letterSpacing: 2
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none
                            ),
                          ),
                          onChanged: (value) {
                            DataBase().MyChatState(widget.roomId, User().id, 'taping');
                            if (value.isEmpty) {
                              DataBase().MyChatState(widget.roomId, User().id, 'see');
                              setState(() {
                                fill = 'empty';
                              });
                            } else {
                              DataBase().MyChatState(widget.roomId, User().id, 'taping');
                              setState(() {
                                fill = 'filled';
                              });
                            }
                            if (_msgcontroller.value.text.isEmpty) {
                              DataBase().MyChatState(widget.roomId, User().id, 'seen');
                              setState(() {
                                fill = 'empty';
                              });
                            }
                          },
                        ),
                      ),
                      fill != 'empty' ? IconButton(
                        onPressed: () async {
                            int num = await DataBase().length(widget.roomId);
                            DataBase().insertMessages('msg ${num+1}',Name, _msgcontroller.text.trim(), User().id, widget.roomId, DateFormat('dd/MM/yyyy').format(date).toString(), DateFormat.jm().format(date).toString(),);
                            _msgcontroller.clear();
                            setState(() {
                              fill = 'empty';
                            });

                          }, 
                        icon: Image.asset('asset/icons/avion-en-papier.png',color: SecondColor,height: height*0.025,)
                        )
                         : IconButton(onPressed: () {}, icon: Image.asset('asset/icons/document.png',color: Colors.grey[500],height: height*0.03,)),
                        fill != 'empty' ? Container() : IconButton(onPressed: () async {
                          print('recording');
                          if (recorder.isRecording) {
                            await stop();
                          }else{
                            await record();
                          }
                          setState(() {
                            isRecorderReady = true;
                          });
                        }, icon: Image.asset('asset/icons/microphone.png',color: Colors.grey[500],height: height*0.03,)),
                        fill != 'empty' ? SizedBox(width: width*0.02,) : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}