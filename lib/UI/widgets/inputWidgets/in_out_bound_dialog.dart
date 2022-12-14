// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uts_osy/UI/widgets/smallElements/custom_dropdown_widget.dart';
import 'package:uts_osy/models/transactions/transaction_model.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:uts_osy/providers/item_provider.dart';
import 'package:uts_osy/providers/transaction_provider.dart';

Future showInOutBoundForm(context, bool isInBound) async {
  final itemProvider = Provider.of<ItemProvider>(context, listen: false);
  await itemProvider.getItems();
  var items = itemProvider.itemList;
  List<Map<String, dynamic>> itemsToPass = items
      .asMap()
      .map((index, item) {
        return MapEntry(
          index,
          {
            'value': item.id,
            'label': item.name,
            'icon': const Icon(Icons.stop),
          },
        );
      })
      .values
      .toList();
  final transactionProvider =
      Provider.of<TransactionProvider>(context, listen: false);
  TextEditingController idController = TextEditingController();
  String bound = isInBound ? "Inbound" : "Outbound";
  int itemId;
  TextEditingController quantityController = TextEditingController();
  DateTime inboundDate = DateTime.now();
  DateTime outboundDate = DateTime.now();

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text("Input Dialog")),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Form(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value.isNotEmpty && int.tryParse(value) == null) {
                          return "Please enter a valid ID";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.number,
                      controller: idController,
                      autofocus: true,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: "Transaction Id",
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: ((value) {
                        if (value.isEmpty){
                          return "Please enter a Quantity";
                        }
                         else if (value.isNotEmpty && int.tryParse(value) == null) {
                          return "Please enter a valid Quantity";
                        } else {
                          return null;
                        }
                      }),
                      keyboardType: TextInputType.number,
                      controller: quantityController,
                      autofocus: true,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: "Transaction Quantity",
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                     const SizedBox(
                      height: 10,
                    ),

                    CustomDropDown(
                      items: itemsToPass,
                      onChange: (changed) => setState(() {
                        itemId = int.parse(changed);
                      }),
                    ),
                     const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      autofocus: true,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: bound,
                        enabled: false,
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                     const SizedBox(
                      height: 10,
                    ),
                    DateTimePicker(
                      initialValue: '',
                      type: DateTimePickerType.dateTime,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      dateLabelText: 'Inbound Date',
                      onChanged: (val) => setState(() {
                        inboundDate = DateTime.tryParse(val);
                      }),
                      validator: (val) {
                        if(val.isEmpty){
                          return "Please enter a Inbound Date";
                        } else {
                          return null;
                        }
                      },
                    ),
                     const SizedBox(
                      height: 10,
                    ),
                    
                    DateTimePicker(
                      initialValue: '',
                      type: DateTimePickerType.dateTime,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      dateLabelText: 'Outbound Date',
                      onChanged: (val) => setState(() {
                        outboundDate = DateTime.tryParse(val);
                      }),
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Please enter a Outbound Date";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                  int generated = DateTime.now().millisecondsSinceEpoch;
                  Transaction addedTransaction = Transaction(
                    // id: int.parse(idController.text),
                    id: idController.text.isEmpty
                        ? generated
                        : int.parse(idController.text),
                    type: bound,
                    inbound_at: inboundDate,
                    outbound_at: outboundDate,
                    itemId: itemId,
                    quantity: quantityController.text.isNotEmpty
                        ? int.parse(quantityController.text)
                        : 0,
                  );
                  Navigator.pop(context);
                  transactionProvider.addTransaction(addedTransaction);
              },
              child: const Text('Save'),
            ),
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel')),
          ],
        );
      });
}
