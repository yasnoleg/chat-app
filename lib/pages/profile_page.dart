import 'package:chatapp/auth_firestore/auth.dart';
import 'package:chatapp/auth_firestore/firestore.dart';
import 'package:chatapp/pages/profile/edit_profile.dart';
import 'package:chatapp/pages/profile/full_profile.dart';
import 'package:chatapp/tools/ui_tools.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  //Map to save user data
  Map userData = {};

  //List to save friends / groups length 
  List FrGrNum = [];


  //func to fetch user data
  FetchUserData() async{
    final data = await FireStore().Fetch(User().id);
    setState(() {
      userData = data;
    });
    print(userData);
  }

  FetchFriendServersLength() async {
    final data = [await FireStore().FetchFriendLength(User().id),await FireStore().FetchGroupsLength(User().id)];
    setState(() {
      FrGrNum = data;
    });
    print(FrGrNum);
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(microseconds: 1), () {
      //fetch user data
      FetchUserData();
      //fetch friend / groups length
      FetchFriendServersLength();
    });
  }



  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: null,
        ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').doc(User().id).snapshots(),
          builder: (context, snapshot) {
            final data = snapshot.data?.data();
              return (snapshot.connectionState == ConnectionState.waiting) ? Center(child: Lottie.asset('asset/animations/loading.json'))
              : Stack(
                children: [
                  Align(
                    alignment: Alignment(0, 0),
                    child: Container(
                      height: height*0.25,
                      width: width*0.8,
                      decoration: BoxDecoration(
                        color: White,
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(image: NetworkImage(data!['bannerurl']),fit: BoxFit.cover,opacity: 0.3),
                        boxShadow: [BoxShadow(
                          color: Colors.black38,
                          blurRadius: 2,
                          spreadRadius: 1,
                        )],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(0, -0.32),
                    child: GestureDetector(
                      onTap: () {
                      },
                      child: Container(
                          height: height*0.12,
                          width: height*0.12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 1,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: ClipRRect(borderRadius: BorderRadius.circular(height),child: Image.network(data!['pfpurl'],height: height*0.12,width: height*0.12,))),
                    ),
                  ),
                  Align(
                    alignment: Alignment(0, -0.1),
                    child: Text(data['name'],style: TextStyle(color: Black,fontFamily: 'H2',fontSize: height*0.025,fontWeight: FontWeight.w700),),
                  ),
                  Align(
                    alignment: Alignment(0, 0),
                    child: Text(FrGrNum.isEmpty ? 'LOADING DATA..' : '${FrGrNum[0]} Friends | ${FrGrNum[1]} Groups',style: TextStyle(color: Black,fontFamily: 'H3',fontSize: height*0.018,fontWeight: FontWeight.w600),),
                  ),
                  Align(
                    alignment: Alignment(-0.7, -0.25),
                    child: Text('${data['identity']}',style: TextStyle(color: Black,fontFamily: 'SPECIAL',fontSize: height*0.015,fontWeight: FontWeight.w600),),
                  ),
                  Align(
                    alignment: Alignment(-0.7, 0.25),
                    child: Text('@${data['username']}',style: TextStyle(color: Black,fontFamily: 'H3',fontSize: height*0.018,fontWeight: FontWeight.w600),),
                  ),
                  Align(
                    alignment: Alignment(0.7, -0.25),
                    child: Text('${data['credit']['amount']}.00 \$',style: TextStyle(color: Black,fontFamily: 'H3',fontSize: height*0.018,fontWeight: FontWeight.w600),),
                  ),
                  Align(
                    alignment: Alignment(0, 0.42),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            showModalBottomSheet(
                                context: context, 
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  )
                                ),
                                builder: ((context) {
                                  return Container(
                                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                    child: FullProfilePage(userData: userData, FrNum: FrGrNum[0], GrNum: FrGrNum[1],),
                                  );
                                })
                              );
                          },
                          child: Container(
                            height: height*0.05,
                            width: width*0.35,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: SecondColor,
                              borderRadius: BorderRadius.circular(height*0.018),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                )
                              ]
                            ),
                            child: Text('Display Profile',style: TextStyle(color: White,fontFamily: 'TEXT',fontSize: height*0.018),),
                          ),
                        ),
                        SizedBox(width: width*0.00,),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => EditProfilePage(userData: userData,),
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
                          child: Container(
                            height: height*0.05,
                            width: width*0.35,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: SecondColor,
                              borderRadius: BorderRadius.circular(height*0.018),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                )
                              ]
                            ),
                            child: Text('Edit Profile',style: TextStyle(color: White,fontFamily: 'TEXT',fontSize: height*0.018),),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
        ),
      ),
    );
  }
}