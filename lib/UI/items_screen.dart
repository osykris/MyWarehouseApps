import 'package:flutter/material.dart';
import 'package:uts_osy/UI/widgets/basicWidgets/custom_fab_widget.dart';
import 'package:uts_osy/UI/widgets/basicWidgets/item_card_widget.dart';
import 'package:uts_osy/providers/item_provider.dart';
import 'package:provider/provider.dart';
import 'package:uts_osy/providers/transaction_provider.dart';
import 'package:uts_osy/UI/widgets/inputWidgets/custom_add_item_dialog.dart';

class ItemsScreen extends StatelessWidget {
  const ItemsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Consumer2<ItemProvider, TransactionProvider>(
        builder: (context, items, transactions, child) {
      return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Items',  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22)),
            centerTitle: true,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: CustomFABWidget(
            heroTag: "0",
            // onPressed: () => openModalBottomSheet(context),
            onPressed: () async {
              Navigator.pop(context);
             await showInputDialog(context);
            },
            label: "Add Item",
            icon: Icons.add,
            width: width * 0.9,
          ),
          body: Column(
            children: [
              Expanded(
                child: items.itemList.isEmpty
                    ? const Center(
                        child: Text("No Items"),
                      )
                    : ListView.builder(
                        itemCount: items.itemList.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: Key(items.itemList[index].id.toString()),
                            background: Container(
                              color: Colors.red,
                              child: const Icon(Icons.delete),
                            ),
                            onDismissed: (direction) async {
                             for (var i = 0; i < transactions.transactionList.length; i++) {
                                if (transactions.transactionList[i].itemId == items.itemList[index].id) {
                                  await transactions.deleteTransaction(i, transactions.transactionList[i]);
                                } 
                              }
                              await items.deleteItem(index);
                            },
                            child: ItemCardWidget(
                              item: items.itemList[index],
                              index: index,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
