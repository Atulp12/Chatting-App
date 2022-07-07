
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_2/ConversationScreen.dart';
import 'package:project_2/Utlis/database.dart';
import 'package:project_2/Widgets/widgets.dart';
import 'package:project_2/helper/Constants.dart';
// import 'package:project_2/helper/helperfunctions.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController = new TextEditingController();
  QuerySnapshot<Map<String, dynamic>>?  searchSnapshot ;

  String get userName => userName;
  get users => users;
  bool isLoading = false;
  bool haveUserSearched = false;

  initiateSearch() async {
    if (searchTextEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await databaseMethods.getUserByUsername(searchTextEditingController.text)
          .then((snapshot) {
        searchSnapshot = snapshot;
        print("$searchSnapshot");
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  Widget searchList(){
    if (searchSnapshot != null) {
      return ListView.builder(
      itemCount: searchSnapshot?.docs.length,
        shrinkWrap: true,
        itemBuilder: (context , index)
        {
          return SearchTile(
            userEmail : searchSnapshot?.docs[index].data()["userName"],
            userName : searchSnapshot?.docs[index].data()["userEmail"],
          );

        });
    } else {
      return Container();
    }
  }

  /// create chatroom,send user to conversation screen,pushreplacement
  createChatroomAndStartConversation({ required String userName}){
      List<String> users = [Constants.myName,userName];
      String chatRoomID = getChatRoomId(userName, Constants.myName);

      Map<String,dynamic> chatroomMap = {
        "users" : users,
        "chatroomID" : chatRoomID,
      };
      DatabaseMethods().createChatRoom(chatRoomID,chatroomMap);
      Navigator.push(context, MaterialPageRoute(builder:
          (context)=> ConversationScreen(chatRoomID),
      ));
  }



  Widget SearchTile({ required String userName, required String userEmail}){
    return Container(
      child: Row(
        children: [
          Column(
            children: [
              Text(userName,style: simpleTextStyle(),),
              Text(userEmail,style: simpleTextStyle(),),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              createChatroomAndStartConversation(
                userName : userName
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
              child: Text("Message") ,
            ),
          ),
        ],
      ),
    );
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState(){
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("I&U Chats"),
        elevation: 0.0,
        centerTitle: false,
      ),
      backgroundColor: Colors.white,
      body: isLoading ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ) :
      Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25,vertical: 20),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                        controller: searchTextEditingController,
                        decoration: InputDecoration(
                          hintText: "Search username..",
                        ),
                      ),
                  ),
                  GestureDetector(
                    onTap: (){
                       initiateSearch();
                      },
                    child: Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  const Color(0x36FFFFFF),
                                  const Color(0x0FFFFFFF)
                                ],
                                begin: FractionalOffset.topLeft,
                                end: FractionalOffset.bottomRight
                            ),
                            borderRadius: BorderRadius.circular(40)
                        ),
                        padding: EdgeInsets.all(12),
                        child: Image.asset("assets/images/5613.jpg",width: 50,height: 50,)),
                  ),
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}



