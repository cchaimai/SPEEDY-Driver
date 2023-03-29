import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});
  // reference for our collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("dUsers");

  final CollectionReference bankCollection =
      FirebaseFirestore.instance.collection("banks");

  final CollectionReference bankHistoryCollection =
      FirebaseFirestore.instance.collection("bankhistory");

  final CollectionReference workHistoryCollection =
      FirebaseFirestore.instance.collection("workhistory");

  // saving the userdata
  Future<void> savingUserData(String email) async {
    return await userCollection.doc(uid).set({
      "email": email,
      "uid": uid,
    });
  }

  Future<void> createBank(String name, String account, String image) async {
    DocumentReference bankDocumentReference = await bankCollection.add({
      "owner": uid,
      "name": name,
      "account": account,
      "image": image,
    });

    await bankDocumentReference.update({
      "id": bankDocumentReference.id,
    });
  }

  Future<void> createBankHistory(String account, num amount) async {
    DocumentReference bankHistoryDocumentReference =
        await bankHistoryCollection.add({
      "owner": uid,
      "day": DateFormat('dd MMM yy', 'th').format(DateTime.now()),
      "time": DateFormat('HH:mm').format(DateTime.now()),
      "account": account,
      "amount": amount,
    });

    await bankHistoryDocumentReference.update({
      "id": bankHistoryDocumentReference.id,
    });
  }

  Future<void> createWorkHistory(num amount) async {
    DocumentReference workHistoryDocumentReference =
        await workHistoryCollection.add({
      "owner": uid,
      "day": DateFormat('dd MMM yy', 'th').format(DateTime.now()),
      "time": DateFormat('HH:mm').format(DateTime.now()),
      "amount": amount,
    });

    await workHistoryDocumentReference.update({
      "id": workHistoryDocumentReference.id,
    });
  }
}
