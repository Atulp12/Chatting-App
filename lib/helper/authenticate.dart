import 'package:flutter/material.dart';
import 'package:project_2/Signup.dart';
import 'package:project_2/signpag.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;

  void toggleView(){
    setState((){
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showSignIn){
      return Signin(toggleView);
    }else{
      return Signup(toggleView);
    }
  }
}
