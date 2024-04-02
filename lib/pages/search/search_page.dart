import 'package:chatapp/auth_firestore/firestore.dart';
import 'package:chatapp/pages/profile/anonymous.dart';
import 'package:chatapp/tools/ui_tools.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  
  //List friends
  List searchItems = [];

  //String 
  String searchtxt = '';

  //controller
  TextEditingController _controller = TextEditingController();


  @override
  Widget build(BuildContext context) {

    //sizes
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: FirstColor,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: height*0.1,
        title: TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'SEARCH',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(height*0.02),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 1,horizontal: width*0.03),
            filled: true,
            fillColor: ThirdColor,
            hintStyle: TextStyle(fontFamily: 'TEXT',fontSize: height*0.017)
          ),
          onChanged: (value) {
            setState(() {
              searchtxt = value;
            });
          },
        ),
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new_outlined),iconSize: height*0.022,),
      ),
      body: Container(
        color: FirstColor,
        child: Container(
          padding: EdgeInsets.only(left: width*0.022,right: width*0.022,top: height*0.01,),
          decoration: BoxDecoration(
            color: White,
            borderRadius: BorderRadius.only(topRight: Radius.circular(height*0.04),topLeft: Radius.circular(height*0.04)),
          ),
          child: StreamBuilder(
              stream: ( searchtxt!= "" && searchtxt!= null)?FirebaseFirestore.instance.collection("users").where("username",isNotEqualTo: searchtxt).orderBy('username').startAt([searchtxt,]).endAt([searchtxt+'\uf8ff',]).snapshots()
                  :FirebaseFirestore.instance.collection("users").snapshots(),
              builder:(BuildContext context,snapshot) {
                final data = snapshot.data?.docs;
                if (snapshot.connectionState == ConnectionState.waiting &&
                    snapshot.hasData != true) {
                  return Center(
                      child:CircularProgressIndicator(),
                  );
                }
                else{
                  return ListView.builder(
                    itemCount: data?.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: height*0.012),
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => AnonymousProfilePage(userData: data.toList()[index],),
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
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(height),
                            child: Image.network(data!.toList()[index]['pfpurl'],height: height*0.07,)
                          ),
                          title: Text(data.toList()[index]['username'].toString(),style: TextStyle(fontSize: height*0.021,fontFamily: 'H2',fontWeight: FontWeight.bold),),
                          subtitle: Text(data.toList()[index]['name'].toString(),style: TextStyle(fontSize: height*0.017,fontFamily: 'TEXT',fontWeight: FontWeight.w300),),
                          trailing: Icon(Icons.arrow_forward_ios_outlined,size: height*0.02,),
                        ),
                      );
                    }
                  );
                }
          }),
        ),
      )
    );
  }
}