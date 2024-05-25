import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService{
  final userCollection = FirebaseFirestore.instance.collection("users");


  Future<void> registerUser({required String name, required String mail, required String password}) async{
    await userCollection.doc().set({
      "mail": mail,
      "name": name,
      "password": password
    });
  }


}