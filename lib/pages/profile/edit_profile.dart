import 'package:chatapp/pages/profile/edit_information.dart';
import 'package:chatapp/tools/ui_tools.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({super.key, this.userData});

  Map? userData;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    //Controllers
    final name_ = TextEditingController();
    final username_ = TextEditingController();
    final email_ = TextEditingController();
    final password_ = TextEditingController();

    return Scaffold(
      backgroundColor: White,
      appBar: AppBar(
        toolbarHeight: height*0.1,
        backgroundColor: FirstColor,elevation: 0,
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new_outlined,size: height*0.025,)),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Settings',style: TextStyle(color: White,fontFamily: 'H2',fontSize: height*0.03,fontWeight: FontWeight.w800),),
          ],
        ),
      ),
      body: Container(
        color: FirstColor,
        child: Container(
          height: height,
          padding: EdgeInsets.only(left: width*0.012,right: width*0.012,top: height*0.008),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topRight: Radius.circular(height*0.04),topLeft: Radius.circular(height*0.04)),
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height*0.05,),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => EditInformationPage(element: 'name',userData: widget.userData,elementValue: widget.userData!['name'],),
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
                  child: Padding(
                    padding: EdgeInsets.only(left: width*0.02,right: width*0.02),
                    child: Row(
                      children: [
                        Text('Name', style: TextStyle(color: Colors.black,fontFamily: 'H4',fontSize: height*0.022,fontWeight: FontWeight.bold),),
                        Expanded(child: SizedBox(width: 1,)),
                        Text(widget.userData!['name'], style: TextStyle(color: Colors.black54,fontFamily: 'H4',fontSize: height*0.02),),
                        SizedBox(width: width*0.035,),
                        Icon(Icons.arrow_forward_ios_outlined,color: Colors.black54,size: height*0.015,),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: height*0.05,),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => EditInformationPage(element: 'username',userData: widget.userData,elementValue: widget.userData!['username'],),
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
                  child: Padding(
                    padding: EdgeInsets.only(left: width*0.02,right: width*0.02),
                    child: Row(
                      children: [
                        Text('Username', style: TextStyle(color: Colors.black,fontFamily: 'H4',fontSize: height*0.022,fontWeight: FontWeight.bold),),
                        Expanded(child: SizedBox(width: 1,)),
                        Text(widget.userData!['username'], style: TextStyle(color: Colors.black54,fontFamily: 'H4',fontSize: height*0.02),),
                        SizedBox(width: width*0.035,),
                        Icon(Icons.arrow_forward_ios_outlined,color: Colors.black54,size: height*0.015,),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: height*0.05,),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => EditInformationPage(element: 'email',userData: widget.userData,elementValue: widget.userData!['email'],),
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
                  child: Padding(
                    padding: EdgeInsets.only(left: width*0.02,right: width*0.02),
                    child: Row(
                      children: [
                        Text('E-mail', style: TextStyle(color: Colors.black,fontFamily: 'H4',fontSize: height*0.022,fontWeight: FontWeight.bold),),
                        Expanded(child: SizedBox(width: 1,)),
                        Text(widget.userData!['email'], style: TextStyle(color: Colors.black54,fontFamily: 'H4',fontSize: height*0.02),),
                        SizedBox(width: width*0.035,),
                        Icon(Icons.arrow_forward_ios_outlined,color: Colors.black54,size: height*0.015,),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: height*0.05,),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => EditInformationPage(element: 'phone number',userData: widget.userData,elementValue: widget.userData!['phonenumber'].toString(),),
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
                  child: Padding(
                    padding: EdgeInsets.only(left: width*0.02,right: width*0.02),
                    child: Row(
                      children: [
                        Text('Phone Number', style: TextStyle(color: Colors.black,fontFamily: 'H4',fontSize: height*0.022,fontWeight: FontWeight.bold),),
                        Expanded(child: SizedBox(width: 1,)),
                        Text('${widget.userData!['phonenumber']}', style: TextStyle(color: Colors.black54,fontFamily: 'H4',fontSize: height*0.02),),
                        SizedBox(width: width*0.035,),
                        Icon(Icons.arrow_forward_ios_outlined,color: Colors.black54,size: height*0.015,),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: height*0.05,),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => EditInformationPage(element: 'password',userData: widget.userData,elementValue: widget.userData!['password'],),
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
                  child: Padding(
                    padding: EdgeInsets.only(left: width*0.02,right: width*0.02),
                    child: Row(
                      children: [
                        Text('Password', style: TextStyle(color: Colors.black,fontFamily: 'H4',fontSize: height*0.022,fontWeight: FontWeight.bold),),
                        Expanded(child: SizedBox(width: 1,)),
                        Text('****', style: TextStyle(color: Colors.black54,fontFamily: 'H4',fontSize: height*0.02),),
                        SizedBox(width: width*0.035,),
                        Icon(Icons.arrow_forward_ios_outlined,color: Colors.black54,size: height*0.015,),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left:height*0.1,right: height*0.1,bottom: height*0.03,top: height*0.08),
                  child: Lottie.asset('asset/animations/settings.json'),
                ),
                Padding(
                  padding: EdgeInsets.only(left: width*0.02),
                  child: TextButton(
                    onPressed: () {}, 
                    child: Text('Enable Double Accounts',style: TextStyle(color: SecondColor,fontFamily: 'H3',fontWeight: FontWeight.bold,fontSize: height*0.02),),
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