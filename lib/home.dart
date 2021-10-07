import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bchecks/services/db_queries.dart';
import 'package:bchecks/services/notify_local.dart';
import 'package:bchecks/widgets/forms/new_trx.dart';
import 'package:bchecks/widgets/home/all.dart';
import 'package:bchecks/widgets/home/bill.dart';
import 'package:bchecks/widgets/home/church.dart';
import 'package:bchecks/widgets/home/family.dart';
import 'package:bchecks/widgets/home/help.dart';
import 'package:bchecks/widgets/home/miscel.dart';
import 'package:bchecks/widgets/home/shopping.dart';
import 'package:bchecks/widgets/home/transport.dart';
import 'package:bchecks/widgets/wallet_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';

import 'models/owner.dart';

class HomePage extends StatefulWidget {
  String userId;
  HomePage({required this.userId, Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();
  late int displayedYear;
  late final DateTime initialDate;
  num budget = 0.00;
  num expenses = 0.00;
  Map<String, num> figures = {
    'bills': 00.00,
    'shopping': 00.00,
    'transport': 00.00,
    'help': 00.00,
    'family': 00.00,
    'church': 00.00,
    'misce': 00.00
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotifyLocal().permission(context);
    getTotals();
  }

  Future<num?> getTotals() async {
    num? bills = await DBQueries(
            uid: widget.userId, category: 'Bills', monYear: selectedDate)
        .userTrxsTotal;
    num? shopping = await DBQueries(
            uid: widget.userId, category: 'Shopping', monYear: selectedDate)
        .userTrxsTotal;
    num? transport = await DBQueries(
            uid: widget.userId, category: 'Transport', monYear: selectedDate)
        .userTrxsTotal;
    num? help = await DBQueries(
            uid: widget.userId, category: 'Help', monYear: selectedDate)
        .userTrxsTotal;
    num? family = await DBQueries(
            uid: widget.userId, category: 'Family', monYear: selectedDate)
        .userTrxsTotal;
    num? church = await DBQueries(
            uid: widget.userId, category: 'Church', monYear: selectedDate)
        .userTrxsTotal;
    num? misce = await DBQueries(
            uid: widget.userId,
            category: 'Miscellaneous',
            monYear: selectedDate)
        .userTrxsTotal;
    num? bud = await DBQueries(
            uid: widget.userId, category: 'all', monYear: selectedDate)
        .userBudget;

    setState(() {
      figures['bills'] = num.parse(bills.toStringAsFixed(2));
      figures['shopping'] = num.parse(shopping.toStringAsFixed(2));
      figures['transport'] = num.parse(transport.toStringAsFixed(2));
      figures['help'] = num.parse(help.toStringAsFixed(2));
      figures['family'] = num.parse(family.toStringAsFixed(2));
      figures['church'] = num.parse(church.toStringAsFixed(2));
      figures['misce'] = num.parse(misce.toStringAsFixed(2));
      var total = bills + shopping + transport + help + family + church + misce;
      expenses = num.parse(total.toStringAsFixed(2));
      budget = num.parse(bud!.toStringAsFixed(2));
      if (budget < expenses) {
        NotifyLocal().notifyEasy();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Owner?>(context);
    //print(figures['bills']);
    return Scaffold(
      //backgroundColor: Colors.grey[300],
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              _showMonthYearController(context);
            },
            icon: const Icon(Icons.tune_sharp)),
        // backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('BCHECKS'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, 'settings');
              },
              icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          WalletCard(
            expenses: expenses,
            balance: (budget - expenses),
            budget: budget,
            selectedDate: selectedDate,
            refreshTotal: getTotals,
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.green[800],
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade500,
                      offset: Offset(4.0, 4.0),
                      blurRadius: 15.0,
                      spreadRadius: 1.0),
                ]),
            margin: EdgeInsets.symmetric(vertical: 15),
            padding: EdgeInsets.all(20),
            height: 60,
            child: Text(
              DateFormat('MMMM,yyyy').format(selectedDate) + ' Summary',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
          Expanded(
              child: Container(
            child: GridView.count(
              padding: EdgeInsets.all(20),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              scrollDirection: Axis.vertical,
              crossAxisCount: 2,
              children: [
                BillWidget(
                  total: figures['bills'] ?? 0,
                ),
                ShoppingWidget(
                  total: figures['shopping'] ?? 0,
                ),
                TransportWidget(
                  total: figures['transport'] ?? 0,
                ),
                HelpWidget(
                  total: figures['help'] ?? 0,
                ),
                FamilyWidget(
                  total: figures['family'] ?? 0,
                ),
                ChurchWidget(
                  total: figures['church'] ?? 0,
                ),
                MiscWidget(
                  total: figures['misce'] ?? 0,
                ),
                AllWidget(
                  selectedDate: selectedDate,
                  refreshTotal: getTotals,
                )
              ],
            ),
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showNewTransactionForm();
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  void _showNewTransactionForm() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: NewTransactionForm(
              refreshTotal: getTotals,
              trx: [],
            ),
          );
        });
  }

  void _showMonthYearController(context) async {
    showMonthPicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 1, 5),
      lastDate: DateTime(DateTime.now().year + 1, 9),
      initialDate: selectedDate,
      locale: Locale("en"),
    ).then((date) {
      if (date != null) {
        setState(() {
          selectedDate = date;
          getTotals();
        });
      }
    });
  }
}
