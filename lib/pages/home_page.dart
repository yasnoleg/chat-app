import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatapp/DB/database.dart';
import 'package:chatapp/auth_firestore/auth.dart';
import 'package:chatapp/auth_firestore/firestore.dart';
import 'package:chatapp/pages/chat/chat_page.dart';
import 'package:chatapp/pages/search/search_page.dart';
import 'package:chatapp/tools/ui_tools.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver{

  //date time
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();

  //vars
  int currentIndex = 0;

  //FUNC
  String GenerateRoomId(String friendId) {
    List<String> ids = [friendId, User().id];
    ids.sort();
    String RoomId = ids.join('_');
    return RoomId;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    FireStore().OnlineOffline('Online');
  }

 @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FireStore().OnlineOffline('Online');
    } else {
      FireStore().OnlineOffline('Offline');
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: White,
      appBar: AppBar(
        title: Text('KillJoy', style: TextStyle(color: White,fontSize: height*0.03,fontFamily: 'SPECIAL',fontWeight: FontWeight.bold),),
        titleSpacing: 5,
        centerTitle: true,
        toolbarHeight: height*0.1,
        elevation: 0,
        backgroundColor: FirstColor,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: width*0.05),
            child: IconButton(
              onPressed: () async {
                Sign().SignOut();
              }, 
              icon: Image.asset('asset/icons/couronne.png',color: Colors.amber[500],height: height*0.015,),
            ),
          ),
        ],
      ),
      body: ClipRRect(
        child: Container(
          color: FirstColor,
          child: Container(
            padding: EdgeInsets.only(left: width*0.05,right: width*0.05),
            decoration: BoxDecoration(
              color: White,
              borderRadius: BorderRadius.only(topRight: Radius.circular(height*0.04),topLeft: Radius.circular(height*0.04)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Space
                SizedBox(height: height*0.03,),
        
                //title ' recent chats '
                Padding(
                  padding: EdgeInsets.only(left: width*0.03),
                  child: Text('Recent Chats', style: TextStyle(color: SecondColor,fontSize: height*0.026,fontFamily: 'H2',fontWeight: FontWeight.bold),),
                ),
        
                //friend list
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('users').doc(User().id).collection('direct').snapshots(),
                    builder: (context, snapshot) {
                      return (snapshot.connectionState == ConnectionState.waiting) 
                      ? Center(child: Lottie.asset('asset/animations/loading.json',height: height*0.1),)
                      : ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot friend = snapshot.data!.docs[index];
                          int count = snapshot.data!.docs.length;
                          return count == 0 
                          ? Lottie.asset('asset/animations/animation_lm3r3nhp.json')
                          : ContactCover(friend); 
                        },
                      );
                    }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: 
        AvatarGlow(
          glowColor: FirstColor,
          endRadius: 40,
          duration: Duration(milliseconds: 2000),
          repeat: true,
          showTwoGlows: true,
          curve: Curves.easeOutQuad,
          child: Container(
            height: height*0.06,
            width: height*0.06,
            decoration: BoxDecoration(
              color: SecondColor,
              borderRadius: BorderRadius.circular(height),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => SearchPage(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const begin = Offset(0.0, 1.0);
                    const end = Offset.zero;
                    const curve = Curves.ease;
                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  })
                );
              }, 
              icon: Image.asset('asset/icons/plus.png',height: height*0.021,width: height*0.021,scale: 1,color: White,),
            ),
          ),
        ),
      );
  }

  ContactCover(DocumentSnapshot friend) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(height),
        child: Image.network(friend['pfpurl'],height: height*0.07,),
      ),
      title: Text(friend['name'],style: TextStyle(color: Black,fontSize: height*0.023,fontFamily: 'H3',fontWeight: FontWeight.w500),),
      subtitle: Text('hello hru ?',style: TextStyle(color: Colors.grey[700],fontSize: height*0.018,fontFamily: 'TEXT',fontWeight: FontWeight.w500),),
      trailing: Text('22:13',style: TextStyle(color: Colors.grey[700],fontSize: height*0.016,fontFamily: 'H3',fontWeight: FontWeight.w500),),
      onTap: () {
        String RoomId = GenerateRoomId(friend['id']);
        FireStore().CreateContact(User().id, RoomId, friend['email'], friend['id'], friend['username'], friend['status'],friend['pfpurl'], friend['name']);
        FireStore().CreateContact(friend['id'], RoomId, User().email!, User().id, User().username!, 'Online', 'https://avatarfiles.alphacoders.com/357/357521.png', 'kaydo');
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => ChatPage(email: friend['email'], id: friend['id'], username: friend['username'], roomId: RoomId, pfpUrl: friend['pfpurl'], Status: friend['status'], name: friend['name'],),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.ease;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ));
      },
    );
  }
}