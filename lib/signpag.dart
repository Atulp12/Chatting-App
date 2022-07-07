import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_2/ChatRoomS.dart';
import 'package:project_2/Utlis/Auth.dart';
import 'package:project_2/Utlis/database.dart';
import 'package:project_2/Widgets/widgets.dart';
import 'package:project_2/helper/helperfunctions.dart';

class Signin extends StatefulWidget {
  final Function toggleView;
  Signin(this.toggleView);

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {

  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  AuthMethods authMethods = new AuthMethods();
  // DatabaseMethods databaseMethods = new DatabaseMethods();

  final formkey = GlobalKey<FormState>();

  bool isloading = false;
  late QuerySnapshot<Map<String, dynamic>> snapshotUserInfo;
  signIn() async {
    if(formkey.currentState!.validate()){
      setState((){
        isloading = true;
      });
      await authMethods
          .signInWithEmailAndPassword(
          emailTextEditingController.text, passwordTextEditingController.text)
          .then((result) async {
        if (result != null)  {
          snapshotUserInfo =
          await DatabaseMethods().getUserByUserEmail(emailTextEditingController.text);

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserUserNameSharedPreference(
              snapshotUserInfo.docs[0].data()["userName"]);
          HelperFunctions.saveUserUserEmailSharedPreference(
              snapshotUserInfo.docs[0].data()["userEmail"]);

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder:(context) => ChatRoom()));
        } else {
          setState(() {
            isloading = false;
            //show snackbar
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("I&U Chats"),
        elevation: 0.0,
        centerTitle: false,
      ),
      body:isloading ? Container(
        child: Center(child: CircularProgressIndicator()),
      ) :
      SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 30,
          alignment: Alignment.bottomCenter,

          child:Container(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0,vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                     key: formkey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (val){
                            return RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(val!) ? null : "Please provide a valid email";
                          },
                          controller: emailTextEditingController,
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration("Email"),
                        ),
                    TextFormField(
                      obscureText: true,
                      validator: (val){
                        return val!.length>6 ? null : "Password must be contain atleast 8 characters";
                      },
                      controller: passwordTextEditingController,
                      style: simpleTextStyle(),
                      decoration: textFieldInputDecoration("Password"),
                    ),
                    ],),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child:Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 16.0),
                      child: Text("Forgot Password?",style: simpleTextStyle(),),
                    ),
                  ),
                  SizedBox(height: 9.0,),
                  GestureDetector(
                    onTap: (){
                        signIn();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              const Color(0xff007EF4),
                              const Color(0xff2A75BC)
                            ]
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text("Sign In",style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),),
                    ),
                  ),
                  SizedBox(height: 16,),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text("Sign in with Google",style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                    ),),
                  ),
                  SizedBox(height: 16,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have account?",style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,),
                      ),
                      GestureDetector(
                        onTap: (){
                          widget.toggleView();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text("Register now",style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              decoration: TextDecoration.underline),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
 }
}
