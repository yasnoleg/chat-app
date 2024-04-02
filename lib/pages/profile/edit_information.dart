import 'package:chatapp/tools/ui_tools.dart';
import 'package:flutter/material.dart';

class EditInformationPage extends StatefulWidget {
  EditInformationPage({super.key, this.element, this.userData, this.elementValue});


  String? element;
  Map? userData;
  String? elementValue;


  @override
  State<EditInformationPage> createState() => _EditInformationPageState();
}

class _EditInformationPageState extends State<EditInformationPage> {
  @override
  Widget build(BuildContext context) {
    
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    //Controllers
    final element_ = TextEditingController();

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
            Text('Edit ${widget.element}',style: TextStyle(color: White,fontFamily: 'H2',fontSize: height*0.03,fontWeight: FontWeight.w800),),
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
          child: Padding(
            padding: EdgeInsets.only(top: height*0.012,left: width*0.02,right: width*0.02),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.element!, style: TextStyle(color: Colors.black54,fontFamily: 'H2',fontSize: height*0.018,fontWeight: FontWeight.bold),),
                Padding(
                  padding: EdgeInsets.only(top: height*0.008,bottom: height*0.02),
                  child: TextField(
                    controller: element_,
                    decoration: InputDecoration(
                      hintText: widget.element == 'password' ? '******' : widget.elementValue,
                      hintStyle: TextStyle(color: Black.withOpacity(0.5),),
                      contentPadding: EdgeInsets.symmetric(vertical: height*0.01),
                    ),
                  ),
                ),
                Text('please only use numbers, letters, underscoes _ .', style: TextStyle(color: Colors.black54,fontFamily: 'TEXT',fontSize: height*0.014,fontWeight: FontWeight.w300),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}