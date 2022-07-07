import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.black,
        title: Text("I&U Chats",),

          actions: [

            Container(
              width: 30,
              child: Image.asset("assets/images/5907.jpg"),

            )

          ],

          ),


          drawer: Drawer(),

    );



  }
}
