import 'package:bchecks/models/owner.dart';
import 'package:bchecks/models/transaction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DBQueries {
  String uid;
  DateTime monYear;
  String category;

  DBQueries({required this.uid, required this.monYear, required this.category});

  final CollectionReference trxCollection =
      FirebaseFirestore.instance.collection('transactions');
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<num> get userTrxsTotal {
    num total = 0;
    return trxCollection
        .where('uid', isEqualTo: uid)
        .where('category', isEqualTo: category)
        .where('month', isEqualTo: DateFormat('MM').format(monYear))
        .where('year', isEqualTo: DateFormat('yyyy').format(monYear))
        .get()
        .then((value) {
      for (QueryDocumentSnapshot<Object?> doc in value.docs) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        total += data['amount'] ?? 0;
      }
      return total;
    });
  }

  Future<List<OwnerTransaction>> get userTrxs {
    return trxCollection
        .where('uid', isEqualTo: uid)
        .where('month', isEqualTo: DateFormat('MM').format(monYear))
        .where('year', isEqualTo: DateFormat('yyyy').format(monYear))
        .get()
        .then((value) {
      return value.docs.map((DocumentSnapshot doc) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        return OwnerTransaction(
            trxID: doc.id,
            uid: data['uid'],
            expense: data['expense'],
            amount: data['amount'],
            trxDate: data['date'].toDate(),
            category: data['category']);
      }).toList();
    }).catchError((err) {
      print(err);
    });
  }

  Future get userBudget {
    return userCollection
        .doc(uid)
        .collection("budgets")
        .where('month', isEqualTo: DateFormat('MM').format(monYear))
        .where('year', isEqualTo: DateFormat('yyyy').format(monYear))
        .get()
        .then((QuerySnapshot querySnapshot) {
      var data = querySnapshot.docs;
      if (data.isEmpty) {
        return 0.00;
      } else {
        return data.first['amount'];
      }
    }).catchError((err) {
      print(err);
      return null;
    });
  }
}
