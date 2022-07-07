import 'package:flutter/material.dart';
import 'package:project_2/ChatRoomS.dart';
import 'package:project_2/Utlis/Auth.dart';
import 'package:project_2/Utlis/database.dart';
import 'package:project_2/Widgets/widgets.dart';
import 'package:project_2/helper/helperfunctions.dart';

class Signup extends StatefulWidget {
  final Function toggleView;
  Signup(this.toggleView);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {


  TextEditingController usernameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  bool isloading = false;
  final formkey = GlobalKey<FormState>();

  SignMeUP() async {
    if(formkey.currentState!.validate()){
       setState(
           (){
             isloading = true;
           }
       );
       await authMethods.signUpWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text)
       .then((val){
         // print("${val.uid}");
         if(val != null) {
           Map<String, String> userInfoMap = {
             "userName": usernameTextEditingController.text,
             "userEmail": emailTextEditingController.text,
           };

           databaseMethods.uploadUserInfo(userInfoMap);

           HelperFunctions.saveUserLoggedInSharedPreference(true);
           HelperFunctions.saveUserUserNameSharedPreference(
               usernameTextEditingController.text);
           HelperFunctions.saveUserUserEmailSharedPreference(
               emailTextEditingController.text);
           Navigator.pushReplacement(context, MaterialPageRoute(
               builder: (context) => ChatRoom()
           ));
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
      body: isloading ? Container(
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
                            return val!.isEmpty || val.length<4 ? "This will never work": null;
                          },
                          controller: usernameTextEditingController,
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration("Username"),
                        ),
                        TextFormField(
                          controller: emailTextEditingController,
                          style: simpleTextStyle(),
                          validator: (val){
                            return RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val!) ? null : "Please provide a valid email";
                          },
                          decoration: textFieldInputDecoration("Email"),
                        ),
                        TextFormField(
                          obscureText: true,
                          controller: passwordTextEditingController,
                          style: simpleTextStyle(),
                          validator: (val){
                            return val!.length>6 ? null : "Password must be contain atleast 8 characters";
                          },
                          decoration: textFieldInputDecoration("Password"),
                        ),
                      ],
                    ),
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
                       SignMeUP();
                    },
                  child :Container(
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
                    child: Text("Sign Up",style: TextStyle(
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
                    child: Text("Sign up with Google",style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                    ),),
                  ),
                  SizedBox(height: 16,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have account?",style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,),
                      ),
                      GestureDetector(
                        onTap: (){
                          widget.toggleView();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text("SignIn now",style: TextStyle(
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
