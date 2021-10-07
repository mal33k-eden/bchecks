import 'package:bchecks/models/owner.dart';
import 'package:bchecks/models/transaction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DataBaseService {
  String uid;

  DataBaseService({required this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference trxCollection =
      FirebaseFirestore.instance.collection('transactions');

  Future updateUserData(String nickname, String email) async {
    return await userCollection
        .doc(uid)
        .set({'nickname': nickname, 'email': email});
  }

  Owner _userFromFireBase(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
    return Owner(uid: uid, nickname: data['nickname'], email: data['email']);
  }

  //get user document
  Stream<Owner> get userData {
    return userCollection.doc(uid).snapshots().map(_userFromFireBase);
  }

  Future addUserTrx(String expense, int amount, String category,
      DateTime trxDate, String month, String year) async {
    return await trxCollection.doc().set({
      'uid': uid,
      'expense': expense,
      'amount': amount,
      'category': category,
      'date': trxDate,
      'month': month,
      'year': year
    });
  }

  Future updateUserTrx(String expense, int amount, String category,
      DateTime trxDate, String month, String year, String trxId) async {
    return await trxCollection.doc(trxId).set({
      'uid': uid,
      'expense': expense,
      'amount': amount,
      'category': category,
      'date': trxDate,
      'month': month,
      'year': year
    });
  }

  Future deleteUserTrx(String trxId) async {
    return await trxCollection.doc(trxId).delete();
  }

  Future updateUserBudget(int amount, String month, String year) async {
    userCollection
        .doc(uid)
        .collection("budgets")
        .where('month', isEqualTo: month)
        .where('year', isEqualTo: year)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      var data = querySnapshot.docs;
      if (data.isEmpty) {
        return await userCollection
            .doc(uid)
            .collection("budgets")
            .doc()
            .set({'amount': amount, 'month': month, 'year': year});
      } else {
        return await userCollection
            .doc(uid)
            .collection("budgets")
            .doc(data.first.id)
            .set({'amount': amount, 'month': month, 'year': year});
      }
    });
  }

  List<OwnerTransaction> _transactionsFromSnapShot(QuerySnapshot snapshot) {
    return snapshot.docs.map((DocumentSnapshot doc) {
      Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
      return OwnerTransaction(
          trxID: doc.id,
          uid: data['uid'],
          expense: data['expense'],
          amount: data['amount'],
          trxDate: data['date'],
          category: data['category']);
    }).toList();
  }

  Future<List<OwnerTransaction>> get userTrxs {
    return trxCollection.where('uid', isEqualTo: uid).get().then((value) {
      return value.docs.map((DocumentSnapshot doc) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        return OwnerTransaction(
            trxID: doc.id,
            uid: data['uid'],
            expense: data['expense'],
            amount: data['amount'],
            trxDate: data['date'],
            category: data['category']);
      }).toList();
    }).catchError((err) {
      print(err);
    });
  }

  Future updateBudgetData(String amount) async {
    return await userCollection
        .doc(uid)
        .set({'amount': amount, 'uid': uid, "date": '10-2021'});
  }
}
