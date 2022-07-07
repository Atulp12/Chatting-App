import 'package:flutter/material.dart';
import 'package:project_2/ConversationScreen.dart';
import 'package:project_2/Utlis/Auth.dart';
import 'package:project_2/Utlis/database.dart';
import 'package:project_2/helper/Constants.dart';
import 'package:project_2/helper/helperfunctions.dart';
import 'package:project_2/search.dart';
import 'package:project_2/signpag.dart';
import 'package:project_2/helper/authenticate.dart';

class ChatRoom extends StatefulWidget {
  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  late Stream chatRooms;


  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context,AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ChatRoomsTile(
                userName: snapshot.data.documents[index].data['chatRoomId']
                    .toString()
                    .replaceAll("_", "")
                    .replaceAll(Constants.myName, ""),
                chatroomId: snapshot.data.documents[index].data["chatRoomId"],
              );
            })
            : Container();
      },
    );
  }

  void initState(){
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = (await HelperFunctions.getUserNameSharedPreference())!;
    DatabaseMethods().getChatRooms(Constants.myName).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${Constants
                .myName}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("I&U Chats"),
        elevation: 0.0,
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: (){
              authMethods.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => Authenticate()
                  ));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
            child : const Icon(Icons.exit_to_app)),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { Navigator.push(context, MaterialPageRoute
          (builder: (context) => SearchScreen()
        )); },
        child: Icon(Icons.search),
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatroomId;

  ChatRoomsTile({required this.userName,required this.chatroomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ConversationScreen(
              chatroomId
            ),
        ));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30)),
              child: Text(userName.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w300)),
            ),
            SizedBox(
              width: 12,
            ),
            Text(userName,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}
