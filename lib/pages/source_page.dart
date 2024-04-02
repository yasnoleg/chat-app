import 'package:chatapp/components/audio/audioplayer.dart';
import 'package:chatapp/pages/home_page.dart';
import 'package:chatapp/pages/profile_page.dart';
import 'package:chatapp/tools/ui_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SourcePage extends StatefulWidget {
  const SourcePage({super.key});

  @override
  State<SourcePage> createState() => _SourcePageState();
}

class _SourcePageState extends State<SourcePage> {

  //vars
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    //size screen
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: White,
      body: listOfPages[currentIndex],
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(20),
        height: screenWidth * .155,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.15),
              blurRadius: 30,
              offset: Offset(0, 10),
            ),
          ],
          borderRadius: BorderRadius.circular(50),
        ),
        child: ListView.builder(
          itemCount: 4,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: screenWidth * .024),
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              setState(() {
                currentIndex = index;
                HapticFeedback.lightImpact();
              });
              print(currentIndex);
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Stack(
              children: [
                SizedBox(
                  width: screenWidth * .2125,
                  child: Center(
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      curve: Curves.fastLinearToSlowEaseIn,
                      height: index == currentIndex ? screenWidth * .12 : 0,
                      width: index == currentIndex ? screenWidth * .2125 : 0,
                      decoration: BoxDecoration(
                        color: index == currentIndex
                            ? SecondColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: screenWidth * .2125,
                  alignment: Alignment.center,
                  child: Image.asset(
                    currentIndex == 0 ? listOfFillIcons1[index] : currentIndex == 1 ? listOfFillIcons2[index] : currentIndex == 2 ? listOfFillIcons3[index] : listOfFillIcons4[index],
                    height: screenWidth * .06,
                    width: screenWidth * .06,
                    color: index == currentIndex
                        ? White
                        : Colors.black26,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> listOfPages = [
    HomePage(),
    Scaffold(appBar: AppBar(),body: Center(child: AudioPlayerWidget())),
    Container(),
    ProfilePage(),
  ];

  List<String> listOfFillIcons1 = [
    'asset/icons/maison (1).png',
    'asset/icons/commentaire.png',
    'asset/icons/a.png',
    'asset/icons/utilisateur.png',
  ];
  List<String> listOfFillIcons2 = [
    'asset/icons/maison.png',
    'asset/icons/commenter.png',
    'asset/icons/a.png',
    'asset/icons/utilisateur.png',
  ];
  List<String> listOfFillIcons3 = [
    'asset/icons/maison.png',
    'asset/icons/commentaire.png',
    'asset/icons/a (1).png',
    'asset/icons/utilisateur.png',
  ];
  List<String> listOfFillIcons4 = [
    'asset/icons/maison.png',
    'asset/icons/commentaire.png',
    'asset/icons/a.png',
    'asset/icons/utilisateur (1).png',
  ];
}