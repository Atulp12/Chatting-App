import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_2/ChatRoomS.dart';
import 'package:project_2/ConversationScreen.dart';
import 'package:project_2/Homepage.dart';
import 'package:project_2/search.dart';
import 'package:project_2/Homepage.dart';
import 'package:project_2/signpag.dart';
import 'package:project_2/Signup.dart';
import 'package:project_2/helper/authenticate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_2/helper/helperfunctions.dart';
import 'package:project_2/main.dart';
import 'package:project_2/signpag.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  bool userIsLoggedIn = false;

  @override
  State<MyApp> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }


  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState()async{
    await HelperFunctions.getUserLoggedInSharedPreference().then((value){
      setState((){
        userIsLoggedIn = value!;
      });
    });
  }

  // final user = FirebaseAuth.instance.currentUser;

  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme: ThemeData(primarySwatch: Colors.cyan),
      darkTheme: ThemeData(
          // scaffoldBackgroundColor: Color(0xFF42A5F5),
          brightness: Brightness.dark
      ),
      // home: userIsLoggedIn ? ChatRoom() : Authenticate(),
        home: userIsLoggedIn != null ?  userIsLoggedIn ? ChatRoom() : Authenticate()
            : Container(
        child: Center(
        child: Authenticate(),
    ),
        ),
      
    );
  }
}


