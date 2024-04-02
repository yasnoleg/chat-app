import 'package:chatapp/pages/profile/edit_profile.dart';
import 'package:chatapp/tools/ui_tools.dart';
import 'package:flutter/material.dart';

class FullProfilePage extends StatefulWidget {
  FullProfilePage({super.key, this.userData, this.FrNum, this.GrNum});

  Map? userData;
  int? FrNum;
  int? GrNum;

  @override
  State<FullProfilePage> createState() => _FullProfilePageState();
}

class _FullProfilePageState extends State<FullProfilePage> {


  @override
  Widget build(BuildContext context) {

  double height =MediaQuery.of(context).size.height;
  double width =MediaQuery.of(context).size.width;

    return SizedBox(
      height: height,
      width: width,
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
                          Text(widget.userData!['name'],style: TextStyle(color: Black,fontFamily: 'H2',fontSize: height*0.022,fontWeight: FontWeight.w700),),
                          SizedBox(height: height*0.015),
                          Text('Friends : ${widget.FrNum}',style: TextStyle(color: Black,fontFamily: 'H4',fontSize: height*0.018),),
                          SizedBox(height: height*0.01),
                          Text('Groups : ${widget.GrNum}',style: TextStyle(color: Black,fontFamily: 'H4',fontSize: height*0.018),),
                          SizedBox(height: height*0.01),
                          Text('Credit : ${widget.userData!['credit']['amount']} \$', style: TextStyle(color: Black,fontFamily: 'H4',fontSize: height*0.018),),
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
                      Text('France, Paris, 83',style: TextStyle(color: Black,fontFamily: 'H4',fontSize: height*0.016,fontWeight: FontWeight.w300),),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => EditProfilePage(userData: widget.userData,),
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
                        width: width*0.45,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: SecondColor,
                          borderRadius: BorderRadius.circular(height*0.015),
                        ),
                        child: Text('Edit Profile',style: TextStyle(color: White,fontFamily: 'TEXT',fontSize: height*0.018),),
                      ),
                    ),
                  ],
                ),
                Divider(height: 2,),
                SizedBox(height: height*0.015,),
                Row(
                  children: [
                    Text('ABOUT ME :',style: TextStyle(color: Black,fontFamily: 'H3',fontSize: height*0.02,fontWeight: FontWeight.w700),),
                    Expanded(child: SizedBox(width: 1,)),
                    Icon(Icons.edit,size: height*0.017,)
                  ],
                ),
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
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: width*0.03),
                      child: Icon(Icons.person,color: Colors.black54,size: height*0.028,),
                    ),
                    Text('Set Status', style: TextStyle(color: Colors.black54,fontFamily: 'H4',fontSize: height*0.018),),
                    Expanded(child: SizedBox(width: 1,)),
                    Icon(Icons.arrow_forward_ios_outlined,color: Colors.black54,size: height*0.015,),
                  ],
                ),
                SizedBox(height: height*0.02,),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: width*0.03),
                      child: Icon(Icons.language_outlined,color: Colors.black54,size: height*0.028,),
                    ),
                    Text('Chnage Language', style: TextStyle(color: Colors.black54,fontFamily: 'H4',fontSize: height*0.018),),
                    Expanded(child: SizedBox(width: 1,)),
                    Icon(Icons.arrow_forward_ios_outlined,color: Colors.black54,size: height*0.015,),
                  ],
                ),
                SizedBox(height: height*0.02,),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: width*0.03),
                      child: Icon(Icons.qr_code_2_outlined,color: Colors.black54,size: height*0.028,),
                    ),
                    Text('Scan QR Code', style: TextStyle(color: Colors.black54,fontFamily: 'H4',fontSize: height*0.018),),
                    Expanded(child: SizedBox(width: 1,)),
                    Icon(Icons.arrow_forward_ios_outlined,color: Colors.black54,size: height*0.015,),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}