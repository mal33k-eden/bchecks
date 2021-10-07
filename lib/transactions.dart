import 'package:bchecks/models/owner.dart';
import 'package:bchecks/trx/trx_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Transactions extends StatelessWidget {
  Transactions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Owner?>(context);
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Transactions'),
      ),
      body: Column(children: [
        SizedBox(
          height: 10.0,
        ),
        Expanded(
          child: TransactionList(
            userUid: user!.uid,
            selectedDate: arguments['date'],
            refreshTotal: arguments['refresh'],
          ),
        )
      ]),
    );
  }
}
