import 'package:chatapp/tools/ui_tools.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AnonymousProfilePage extends StatefulWidget {
  AnonymousProfilePage({super.key, this.userData, this.FrNum, this.GrNum});

  QueryDocumentSnapshot<Map<String, dynamic>>? userData;
  int? FrNum;
  int? GrNum;

  @override
  State<AnonymousProfilePage> createState() => _AnonymousProfilePageState();
}

class _AnonymousProfilePageState extends State<AnonymousProfilePage> {
  @override
  Widget build(BuildContext context) {

  double height =MediaQuery.of(context).size.height;
  double width =MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: FirstColor,
        centerTitle: true,
        toolbarHeight: height*0.1,
        leading: IconButton(onPressed: () {
          Navigator.of(context).pop();
        }, icon: Icon(Icons.arrow_back_ios_new_outlined),iconSize: height*0.02,),
        elevation: 0,
      ),
      body: Container(
        color: FirstColor,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: White,
            borderRadius: BorderRadius.only(topRight: Radius.circular(height*0.04),topLeft: Radius.circular(height*0.04)),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: width*0.02,right: width*0.02,top: height*0.005,bottom: height*0.01),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(height*0.018),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(height*0.05),
                          child: Image.network(widget.userData!['pfpurl'],height: height*0.15,width: height*0.15,),
                        ),
                        SizedBox(width: width*0.06,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.userData!['name'],style: TextStyle(color: Black,fontFamily: 'H2',fontSize: height*0.027,fontWeight: FontWeight.w700,letterSpacing: 1),),
                              SizedBox(height: height*0.01),
                              Text('Groups : 50',style: TextStyle(color: Black,fontFamily: 'H4',fontSize: height*0.018),),
                            ],
                          ),
                        ),
                        Expanded(flex: 1,child: SizedBox(width: width*0.8,))
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: height*0.01,bottom: height*0.01),
                      child: Row(
                        children: [
                          Icon(Icons.add_location_alt_outlined,size: height*0.015,),
                          SizedBox(width: width*0.01,),
                          Text('Canada, New-Brunswick, Fredericton',style: TextStyle(color: Black,fontFamily: 'H4',fontSize: height*0.016,fontWeight: FontWeight.w300),),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            
                          },
                          child: Container(
                            height: height*0.05,
                            width: width*0.45,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: SecondColor,
                              borderRadius: BorderRadius.circular(height*0.015),
                            ),
                            child: Text('Add Friend',style: TextStyle(color: White,fontFamily: 'TEXT',fontSize: height*0.018),),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            
                          },
                          child: Container(
                            height: height*0.05,
                            width: width*0.35,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: SecondColor,
                              borderRadius: BorderRadius.circular(height*0.015),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Send Message  ',style: TextStyle(color: White,fontFamily: 'TEXT',fontSize: height*0.018),),
                                Image.asset('asset/icons/commentaire.png',height: height*0.02,width: height*0.02,color: White,),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 2,),
                    SizedBox(height: height*0.015,),
                    Text('ABOUT ME :',style: TextStyle(color: Black,fontFamily: 'H3',fontSize: height*0.02,fontWeight: FontWeight.w700),),
                    Text('${widget.userData!['bio']}',style: TextStyle(color: Black,fontFamily: 'H4',fontSize: height*0.015,fontWeight: FontWeight.w200),maxLines: 4,),
                    Divider(height: 2,),
                    SizedBox(height: height*0.015,),
                    Text('Interesting :',style: TextStyle(color: Black,fontFamily: 'H3',fontSize: height*0.02,fontWeight: FontWeight.w700),),
                    SizedBox(height:height*0.008),
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: height*0.025,
                          width: width*0.12,
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.5),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Text('gaming',style: TextStyle(color: Black,fontFamily: 'H4',fontSize: height*0.015,fontWeight: FontWeight.w200),maxLines: 4,)
                        ),
                        SizedBox(width: width*0.03,),
                        Container(
                          alignment: Alignment.center,
                          height: height*0.025,
                          width: width*0.15,
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.5),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Text('travelling',style: TextStyle(color: Black,fontFamily: 'H4',fontSize: height*0.015,fontWeight: FontWeight.w200),maxLines: 4,)
                        ),
                        SizedBox(width: width*0.03,),
                        Container(
                          alignment: Alignment.center,
                          height: height*0.025,
                          width: width*0.16,
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.5),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Text('Streaming',style: TextStyle(color: Black,fontFamily: 'H4',fontSize: height*0.015,fontWeight: FontWeight.w200),maxLines: 4,)
                        ),
                      ],
                    ),
                    SizedBox(height: height*0.01,),
                    Divider(height: 2,),
                    SizedBox(height: height*0.02,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {}, 
                          child: Text('POSTS',style: TextStyle(color: Black,fontFamily: 'H3',fontSize: height*0.02,fontWeight: FontWeight.w700),),
                        ),
                        Text('|',style: TextStyle(color: Black,fontFamily: 'H3',fontSize: height*0.02,fontWeight: FontWeight.w700),),
                        TextButton(
                          onPressed: () {}, 
                          child: Text('WITH YOU',style: TextStyle(color: Black,fontFamily: 'H3',fontSize: height*0.02,fontWeight: FontWeight.w700),),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}