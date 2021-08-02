import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/adaptive_flat_button.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(
        _amountController.text); //takes String, converts into double. Since
    //void _addNewTransaction method expects double type.

    // ignore: unnecessary_null_comparison
    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      print('Invalid Entry');
      return; //just a 'return' means addTx won't execute.
    }

    widget.addTx(
      //"widget." helps access properties of widget class from inside state class.
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );

    Navigator.of(context)
        .pop(); //closes modal sheet automatically once data is entered and "done" is executed manually.
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom +
                10, //viewInsets gives info about anything lapping into our view.
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            //Add Transaction button shifted to rightmost corner of the card.
            children: [
              TextField(
                //properties of textfield aren't affected by crossAxisAlignment.
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title of Transaction'),
                onSubmitted: (_) => _submitData(),
                // onChanged: (val) => titleInput = val,
              ),
              TextField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Amount in ₹'),
                // onChanged: (val) => amountInput = val,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: Text(
                        // ignore: unnecessary_null_comparison
                        _selectedDate == null
                            ? 'No Date chosen!'
                            : 'Picked Date: ${DateFormat.yMMMd().format(_selectedDate!)}',
                      ),
                    ),
                    AdaptiveButton('Choose Date', _presentDatePicker),
                  ],
                ),
              ),
              OutlineButton(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
                onPressed: _submitData,
                textColor: Theme.of(context).primaryColor,
                child: Text('Add transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
