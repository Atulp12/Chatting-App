import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{

    getUserByUsername(String username) async{
        return await FirebaseFirestore.instance.collection("users")
            .where("name",isEqualTo: username).get();

    }

    getUserByUserEmail(String userEmail) async{
        return await FirebaseFirestore.instance.collection("users")
            .where("name",isEqualTo: userEmail).get();

    }

    searchByName(String searchField) {
        return FirebaseFirestore.instance
            .collection("users")
            .where('userName', isEqualTo: searchField)
            .get();
    }

    uploadUserInfo(userMap){
        FirebaseFirestore.instance.collection("users").add(userMap);

    }

    createChatRoom(String chatRoomId,chatRoomMap){
        FirebaseFirestore.instance.collection("Chatroom").doc(chatRoomId)
            .set(chatRoomMap).catchError((e){
                print(e.toString());
        });
    }

    addConservationMessages(String chatroomId, messageMap){
        FirebaseFirestore.instance.collection("ChatRoom")
            .doc(chatroomId)
            .collection("chats")
            .add(messageMap).catchError((e){print(e.toString());});
    }

    getConversationMessages(String chatroomId,messageMap)  {
      return FirebaseFirestore.instance.collection("ChatRoom")
            .doc(chatroomId)
            .collection("chats")
            .orderBy("time",descending: false)
            .snapshots();
    }
    
     getChatRooms(String userName){
        return FirebaseFirestore.instance
            .collection("ChatRoom")
            .where("users",arrayContains: userName)
            .snapshots();
    }

}