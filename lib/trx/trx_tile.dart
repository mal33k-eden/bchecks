import 'package:bchecks/models/transaction.dart';
import 'package:bchecks/models/trx_category.dart';
import 'package:bchecks/widgets/forms/new_trx.dart';
import 'package:bchecks/widgets/forms/update_trx.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TrxTile extends StatefulWidget {
  final OwnerTransaction transaction;
  final Function refreshTotal;
  TrxTile({required this.transaction, Key? key, required this.refreshTotal})
      : super(key: key);

  @override
  State<TrxTile> createState() => _TrxTileState();
}

class _TrxTileState extends State<TrxTile> {
  var trxKeys = {
    'Bills': 0,
    'Family': 1,
    'Shopping': 2,
    'Help': 3,
    'Transport': 4,
    'Church': 5,
    'Miscellaneous': 6
  };

  @override
  Widget build(BuildContext context) {
    final int k = trxKeys[widget.transaction.category] ?? 0;
    IconData i = trx_categories[k].icon;
    Color c = trx_categories[k].color;
    return ListTile(
        onTap: () {
          _showNewTransactionForm(context, widget.transaction);
        },
        leading: CircleAvatar(
          backgroundColor: c,
          child: Icon(
            i,
            size: 24,
            color: Colors.white,
          ),
        ),
        title: Text(widget.transaction.expense,
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black)),
        subtitle: Text(
            DateFormat('MM-dd-yyyy').format(widget.transaction.trxDate),
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black)),
        trailing: Text(
          '-\$${widget.transaction.amount.toString()}',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ));
  }

  void _showNewTransactionForm(
      BuildContext context, OwnerTransaction transaction) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: UpdateTransactionForm(
                refreshTotal: widget.refreshTotal, trx: transaction),
          );
        });
  }
}
