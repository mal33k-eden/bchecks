import 'package:bchecks/models/owner.dart';
import 'package:bchecks/widgets/forms/budget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WalletCard extends StatelessWidget {
  final num expenses;
  final num balance;
  final num budget;
  final Function refreshTotal;
  DateTime selectedDate;

  WalletCard(
      {required this.expenses,
      required this.balance,
      required this.budget,
      required this.selectedDate,
      Key? key,
      required this.refreshTotal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Owner?>(context);

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_upward, color: Colors.red[500]),
                  Text('E X P E N S E S',
                      style: TextStyle(color: Colors.grey[500], fontSize: 16)),
                ],
              ),
              Text(
                '\$$expenses',
                style: TextStyle(color: Colors.red, fontSize: 40),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[100],
                          ),
                          child: Center(
                            child: IconButton(
                              onPressed: () {
                                _showBudgetController(context, user!.uid);
                              },
                              color: Colors.purple,
                              icon: Icon(Icons.money),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Budget',
                                style: TextStyle(color: Colors.grey[300])),
                            SizedBox(
                              height: 5,
                            ),
                            Text('\$$budget',
                                style: TextStyle(
                                    color: Colors.grey[400],
                                    fontWeight: FontWeight.bold)),
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[100],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.credit_card,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Balance',
                                style: TextStyle(color: Colors.grey[300])),
                            SizedBox(
                              height: 5,
                            ),
                            Text('\$$balance',
                                style: TextStyle(
                                    color: (balance > 1)
                                        ? Colors.green[400]
                                        : Colors.red,
                                    fontWeight: FontWeight.bold)),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.black87,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade500,
                  offset: Offset(4.0, 4.0),
                  blurRadius: 15.0,
                  spreadRadius: 1.0),
              BoxShadow(
                  color: Colors.white10,
                  offset: Offset(-4.0, -4.0),
                  blurRadius: 15.0,
                  spreadRadius: 1.0),
            ]),
      ),
    );
  }

  void _showBudgetController(context, String uid) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return UpdateBudget(
            selectedDate: selectedDate,
            uid: uid,
            refreshTotal: refreshTotal,
          );
        });
  }
}
