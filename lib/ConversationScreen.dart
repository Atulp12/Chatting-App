import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_2/Utlis/database.dart';
import 'package:project_2/helper/Constants.dart';

class ConversationScreen extends StatefulWidget {
  final String chatroomId;
  ConversationScreen(this.chatroomId);



  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();
  late Stream<QuerySnapshot> chatMessagesStream;

  Widget ChatMessageList(){
       return StreamBuilder(
         stream: chatMessagesStream,
         builder: (context,AsyncSnapshot snapshot){
           return snapshot.hasData ? ListView.builder(
             itemCount: snapshot.data!.docs.length,
               itemBuilder: (context,index){
                return MessageTile(snapshot.data!.documents[index].data["message"],
                    snapshot.data!.documents[index].data["SendByMe"] == Constants.myName);
               }
           ) : Container();
         },
       );
  }
  
  sendMessage(){
    if(messageController.text.isNotEmpty){
      Map<String,dynamic> messageMap = {
        "message" : messageController.text,
        "sendBy" : Constants.myName,
        "time" : DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addConservationMessages(widget.chatroomId, messageMap);
      setState(() {
        messageController.text = "";
      });
    }
    
  }
  
  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatroomId,messageController).then((value){
      setState((){
        chatMessagesStream = value;
      });
    });
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
      body: Container(
        child: Stack(
          children: [
            ChatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(

                decoration: BoxDecoration(
                    color: Colors.black26,
                  // borderRadius: BorderRadius.circular(25)
                ),

                padding: EdgeInsets.symmetric(horizontal: 25,vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "Message",
                          hintStyle: TextStyle(color: Colors.black12),
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: (){
                        sendMessage();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
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
                          child: Image.asset("assets/images/send.png",width: 50,height: 50,)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe, [data]);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left:  isSendByMe ? 0 : 24,right: isSendByMe ? 24 : 0 ),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors : isSendByMe ? [
              const Color(0xff007EF4),
              const Color(0xff2A75BC)
            ]
              : [
                const Color(0x1AFFFFFF),
                const Color(0x1AFFFFFF)
            ],
          ),
          borderRadius: isSendByMe ?
              BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
              ) :
          BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomRight: Radius.circular(23)
          ),
        ),
        child: Text(message,
        style: TextStyle(
          color: Colors.black,
          fontSize: 17,
        ),),
      ),
    );
  }
}

