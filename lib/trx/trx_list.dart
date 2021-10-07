import 'package:bchecks/models/owner.dart';
import 'package:bchecks/models/transaction.dart';
import 'package:bchecks/services/database.dart';
import 'package:bchecks/services/db_queries.dart';
import 'package:bchecks/trx/trx_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class TransactionList extends StatefulWidget {
  final String userUid;
  final DateTime selectedDate;
  final Function refreshTotal;
  TransactionList({
    Key? key,
    required this.userUid,
    required this.selectedDate,
    required this.refreshTotal,
  }) : super(key: key);

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  final CollectionReference trxCollection =
      FirebaseFirestore.instance.collection('transactions');

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Owner?>(context);
    return FutureBuilder<List<OwnerTransaction>>(
        future: DBQueries(
                uid: user!.uid, monYear: widget.selectedDate, category: 'all')
            .userTrxs,
        builder: (BuildContext context, snapshot) {
          List<OwnerTransaction>? d = snapshot.data ?? [];
          if (d.isNotEmpty) {
            return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: snapshot.data?.length,
                itemBuilder: (BuildContext context, int index) {
                  final i = snapshot.data!.elementAt(index);
                  return Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    // elevation: 5,
                    //color: Color.alphaBlend(Colors.amber, Colors.black),
                    child: Dismissible(
                      background: Container(
                        alignment: AlignmentDirectional.centerEnd,
                        color: Colors.red,
                        child: const Padding(
                          padding: EdgeInsets.all(18.0),
                          child: Icon(
                            Icons.delete_forever_sharp,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ),
                      key: Key(index.toString()),
                      onDismissed: (direction) {
                        DataBaseService(uid: user.uid).deleteUserTrx(i.trxID);
                      },
                      child: TrxTile(
                          transaction: snapshot.data!.elementAt(index),
                          refreshTotal: widget.refreshTotal),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      border: Border.all(width: 1, color: Colors.transparent),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade500,
                            offset: const Offset(4.0, 4.0),
                            blurRadius: 15.0,
                            spreadRadius: 1.0),
                      ],
                    ),
                  );
                });
          } else {
            return Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Yay!",
                  style: TextStyle(fontSize: 40, color: Colors.green[900]),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "All Tidy this Month",
                  style: TextStyle(fontSize: 20, color: Colors.green[900]),
                ),
                SvgPicture.asset('assets/images/clean.svg'),
              ],
            );
          }
        });
  }
}
