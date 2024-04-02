import 'package:chatapp/auth_firestore/auth.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  //Controllers
  final _emailcont = TextEditingController();
  final _passcont = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text('email'),
          SizedBox(height: 10,),
          TextField(
            controller: _emailcont,
          ),
          SizedBox(height: 20,),
          Text('password'),
          SizedBox(height: 10,),
          TextField(
            controller: _passcont,
          ),
          SizedBox(height: 30,),
          GestureDetector(
            onTap: () {
              Sign().SignIn(_emailcont.text.trim(), _passcont.text.trim());
            },
            child: Container(
              alignment: Alignment.center,
              height: 30,
              width: 60,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 244, 54, 219),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('SignIn'),
            ),
          ),
        ],
      ),
    );
  }
}