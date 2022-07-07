import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_2/ConversationScreen.dart';


class AuthMethods{
     final FirebaseAuth _auth = FirebaseAuth.instance;

     User1? _userFromFirebaseUser(user) {
       if (user != null) {
         return User1(uid: user.uid, userId: '');
       } else {
         return null;
       }
     }

     // Future signInWithEmailAndPassword(String email, String password) async {
     //  try{
     //    await _auth.signInWithEmailAndPassword(email: email, password: password);
     //    return "Signed in";
     //  }on FirebaseAuthException catch(e){
     //    return e.message;
     //  }
     // }
     Future signInWithEmailAndPassword(String email, String password) async {
       try {
         UserCredential result = await _auth.signInWithEmailAndPassword(
             email: email, password: password);
         User? user = result.user;
         return _userFromFirebaseUser(user);
       } catch (e) {
         print(e.toString());
         return null;
       }
     }

     //
     // Future signUpWithEmailAndPassword(String email, String password) async {
     //   try {
     //     await _auth.createUserWithEmailAndPassword(
     //         email: email, password: password);
     //     return "Sign up";
     //   }on FirebaseAuthException catch (e) {
     //     return e.message;
     //   }
     // }
     //
     Future resetPass(String email) async {
       try {
         return await _auth.sendPasswordResetEmail(email: email);
       } catch (e) {
         print(e.toString());
         return null;
       }
     }
     Future signOut() async{
       try{
         return await _auth.signOut();
       }catch(e){
         print(e.toString());
       }
     }

     Future signUpWithEmailAndPassword(String email, String password) async {
       try {
         UserCredential result = await _auth.createUserWithEmailAndPassword(
             email: email, password: password);
         User? user = result.user;
         return _userFromFirebaseUser(user);
       } catch (e) {
         print(e.toString());
         return null;
       }
     }
     //
     // Future resetPass(String email) async {
     //   try {
     //     return await _auth.sendPasswordResetEmail(email: email);
     //   } catch (e) {
     //     print(e.toString());
     //     return null;
     //   }
     // }

     // Future<User> signInWithGoogle(BuildContext context) async {
     //   final GoogleSignIn _googleSignIn = new GoogleSignIn();
     //
     //   final GoogleSignInAccount googleSignInAccount =
     //   await _googleSignIn.signIn();
     //   final GoogleSignInAuthentication googleSignInAuthentication =
     //   await googleSignInAccount.authentication;
     //
     //   final AuthCredential credential = GoogleAuthProvider.getCredential(
     //       idToken: googleSignInAuthentication.idToken,
     //       accessToken: googleSignInAuthentication.accessToken);
     //
     //   AuthResult result = await _auth.signInWithCredential(credential);
     //   FirebaseUser userDetails = result.user;
     //
     //   if (result == null) {
     //   } else {
     //     Navigator.push(context, MaterialPageRoute(builder: (context) => Chat()));
     //   }
     // }

     // Future signOut() async {
     //   try {
     //     return await _auth.signOut();
     //   } catch (e) {
     //     print(e.toString());
     //     return null;
     //   }
     // }

}
class User1{
  late String userId;
  User1({required this.userId, required uid}) {
    // TODO: implement
    throw UnimplementedError();
  }
}



