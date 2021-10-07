import 'package:bchecks/services/database.dart';
import 'package:bchecks/widgets/forms/shared.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class UpdateBudget extends StatefulWidget {
  DateTime selectedDate;
  final Function refreshTotal;
  String uid;
  UpdateBudget({
    Key? key,
    required this.selectedDate,
    required this.uid,
    required this.refreshTotal,
  }) : super(key: key);

  @override
  State<UpdateBudget> createState() => _UpdateBudgetState();
}

class _UpdateBudgetState extends State<UpdateBudget> {
  final _budgetForm = GlobalKey<FormState>();
  final amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 30,
      scrollable: true,
      title: const Text('Update Budget'),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Form(
            key: _budgetForm,
            child: Column(
              children: [
                TextFormField(
                  decoration: textFieldDecorator.copyWith(
                      label: const Text('Amount'), hintText: '0.00'),
                  onChanged: (val) {},
                  validator: (val) => validateTextField(val),
                  controller: amountController,
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                    'Budget Period: ${DateFormat("MMMM,yyyy").format(widget.selectedDate)}'),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    style: btnStyle,
                    onPressed: () {
                      if (_budgetForm.currentState!.validate()) {
                        showSnackBar(
                            context: context, message: 'Processing Data');
                        _addBudget(context);
                      }
                    },
                    child: const Text(
                      'Update Budget',
                      style: const TextStyle(fontSize: 19),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addBudget(BuildContext context) {
    DataBaseService(uid: widget.uid).updateUserBudget(
        int.parse(amountController.text),
        DateFormat('MM').format(widget.selectedDate),
        DateFormat('yyyy').format(widget.selectedDate));
    Navigator.pop(context);
    widget.refreshTotal();
  }
}
