import 'package:bchecks/models/owner.dart';
import 'package:bchecks/models/transaction.dart';
import 'package:bchecks/models/trx_category.dart';
import 'package:bchecks/services/database.dart';
import 'package:bchecks/widgets/forms/shared.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewTransactionForm extends StatefulWidget {
  final Function refreshTotal;
  final List<dynamic> trx;
  NewTransactionForm({Key? key, required this.refreshTotal, required this.trx})
      : super(key: key);

  @override
  _NewTransactionFormState createState() => _NewTransactionFormState();
}

class _NewTransactionFormState extends State<NewTransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final expenseController = TextEditingController();
  final amountController = TextEditingController();
  final dateController = TextEditingController();
  late OwnerTransaction transaction;
  String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    dateController.text = selectedDate + ' 00:00:00';
    if (widget.trx.isNotEmpty) {
      transaction = widget.trx.first;
    }
  }

  int? _category_value;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Owner?>(context);
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Add A New Transaction',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: textFieldDecorator.copyWith(
                  label: const Text('Expense'), hintText: 'e.g House Rent'),
              onChanged: (val) {},
              validator: (val) => validateTextField(val),
              controller: expenseController,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: textFieldDecorator.copyWith(
                  label: const Text('Amount'), hintText: '20'),
              onChanged: (val) {},
              validator: (val) => validateTextField(val),
              controller: amountController,
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              decoration: textFieldDecorator.copyWith(
                  label: const Text('Date'), hintText: 'Select Date'),
              controller: dateController,
              validator: (val) => validateTextField(val),
              onTap: () => _selectDate(context),
            ),
            const Text(
              'What did you spend on?',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 18),
            ),
            //InputDatePickerFormField(firstDate: firstDate, lastDate: lastDate)
            const SizedBox(
              height: 30,
            ),
            Wrap(
              spacing: 10,
              alignment: WrapAlignment.spaceEvenly,
              direction: Axis.horizontal,
              children: List<Widget>.generate(
                trx_categories.length,
                (int index) {
                  return ChoiceChip(
                    backgroundColor: _category_value == index
                        ? trx_categories[index].color
                        : Colors.black,
                    avatar: Icon(
                      trx_categories[index].icon,
                      color: _category_value == index
                          ? Colors.white
                          : trx_categories[index].color,
                    ),
                    elevation: 10,
                    pressElevation: 5,
                    shadowColor: Colors.black87,
                    selectedColor: trx_categories[index].color,
                    label: Text(
                      trx_categories[index].name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    selected: _category_value == index,
                    onSelected: (bool selected) {
                      setState(() {
                        _category_value = selected ? index : null;
                      });
                    },
                  );
                },
              ).toList(),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                style: btnStyle,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (_category_value == null) {
                      showSnackBar(
                          context: context,
                          message: 'select an expense category');
                    } else {
                      showSnackBar(
                          context: context, message: 'Processing Data');
                      _addNewTrx(user!.uid);
                    }
                  }
                },
                child: const Text(
                  'Add Expense',
                  style: const TextStyle(fontSize: 19),
                ))
          ],
        ),
      ),
    );
  }

  void _addNewTrx(user) async {
    String category;
    category = trx_categories[_category_value!].name;
    await DataBaseService(uid: user).addUserTrx(
        expenseController.text,
        int.parse(amountController.text),
        category,
        DateTime.parse(dateController.text),
        DateFormat('MM').format(DateTime.parse(dateController.text)),
        DateFormat('yyyy').format(DateTime.parse(dateController.text)));
    widget.refreshTotal();
    Navigator.pop(context);
  }

  _selectDate(BuildContext context) async {
    final DateTime? datePicked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1999),
      lastDate: DateTime(3000),
    );

    if (datePicked != null && datePicked != selectedDate) {
      setState(() {
        selectedDate = DateFormat('yyyy-MM-dd').format(datePicked);
        dateController.text = selectedDate + ' 00:00:00';
      });
    }
  }
}
