import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:uts_osy/UI/argument/transaction_details_args.dart';
import 'package:uts_osy/UI/widgets/basicWidgets/custom_fab_widget.dart';
import 'package:uts_osy/UI/widgets/inputWidgets/in_out_bound_dialog.dart';
import 'package:uts_osy/UI/widgets/inputWidgets/filters_dialog.dart';
import 'package:uts_osy/UI/widgets/basicWidgets/transaction_card_widget.dart';
import 'package:uts_osy/main.dart';
import 'package:uts_osy/models/items/item_model.dart';
import 'package:uts_osy/models/transactions/transaction_model.dart';
import 'package:uts_osy/providers/item_provider.dart';
import 'package:uts_osy/providers/transaction_provider.dart';
import 'package:uts_osy/screens/Welcome/welcome_screen.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key key}) : super(key: key);

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  Widget build(BuildContext context) {
    TransactionProvider transactionProvider =
        Provider.of<TransactionProvider>(context);
    context.watch<ItemProvider>().getItems();
    context.watch<TransactionProvider>().getTransactions();

    final controller = FloatingSearchBarController();

    context
        .watch<TransactionProvider>()
        .transactionsWithFilter(transactionProvider.filters);

    @override
    // ignore: unused_element
    void dispose() {
      if (!controller.isClosed) {
        controller.dispose();
      }
      super.dispose();
    }

    buildResultList(transactionProvider, itemProvider) {
      List<Transaction> listOfTransactions = transactionProvider.filters.isEmpty
          ? transactionProvider.transactionList
          : transactionProvider.transactionOperationList;
      return transactionProvider.transactionList.isEmpty ||
              itemProvider.itemList.isEmpty
          ? const Center(
              child: Text(
                'No Transactions Found',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : ListView.builder(
              itemCount: listOfTransactions.length,
              itemBuilder: (context, index) {
                Transaction transaction = listOfTransactions[index];
                int itemId = transaction.itemId;
                List<Item> items = itemProvider.itemList as List<Item>;
                Item item = items.firstWhere((element) => element.id == itemId);

                return InkWell(
                  onTap: () => Navigator.pushNamed(
                      context, '/transactionDetails',
                      arguments:
                          TransactionsDetailsArgument(transaction, item)),
                  child: Dismissible(
                    key: Key(listOfTransactions[index].id.toString()),
                    background: Container(
                      color: Colors.red,
                      child: const Icon(Icons.delete),
                    ),
                    onDismissed: (direction) async {
                      transactionProvider.deleteTransaction(index, transaction);
                    },
                    child: TransactionCardWidget(
                      transaction: listOfTransactions[index],
                      item: item,
                      index: index,
                    ),
                  ),
                );
              },
            );
    }

    buildSearchList(List<Transaction> transactions, itemProvider) {
      return ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          Transaction transaction = transactions[index];
          int itemId = transaction.itemId;
          Item item = itemProvider.itemList.firstWhere((element) {
            element as Item;
            return element.id == itemId;
          });

          return InkWell(
            onTap: () => Navigator.pushNamed(context, '/transactionDetails',
                arguments:
                    TransactionsDetailsArgument(transactions[index], item)),
            child: TransactionCardWidget(
              transaction: transaction,
              item: item,
              index: index,
            ),
          );
        },
      );
    }

    Widget buildSearchBar(transactionProvider) {
      final actions = [
        FloatingSearchBarAction(
          child: CircularButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () async {
              List<int> newFilters = await filtersDialog(context) ?? [];
              transactionProvider.setFilters(newFilters);
            },
          ),
          showIfOpened: true,
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: true,
        ),
      ];

      return Consumer2<TransactionProvider, ItemProvider>(
        builder: (context, transaction, item, _) => FloatingSearchBar(
          controller: controller,
          leadingActions: [FloatingSearchBarAction.back()],
          hint: 'Search for something',
          transitionDuration: const Duration(milliseconds: 800),
          transitionCurve: Curves.easeInOutCubic,
          physics: const BouncingScrollPhysics(),
          axisAlignment: 0,
          openAxisAlignment: 0.0,
          actions: actions,
          debounceDelay: const Duration(milliseconds: 500),
          onQueryChanged: transaction.searchForTransaction,
          scrollPadding: EdgeInsets.zero,
          transition: CircularFloatingSearchBarTransition(spacing: 16),
          isScrollControlled: true,
          builder: (context, _) =>
              transaction.transactionList.isEmpty || item.itemList.isEmpty
                  ? const Center(
                      child: Text(
                        'No Transactions',
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  : buildSearchList(
                      transaction.transactionOperationList as List<Transaction>,
                      item),
          body: transaction.transactionList.isEmpty || item.itemList.isEmpty
              ? const Center(
                  child: Text(
                    'No Transactions',
                    style: TextStyle(fontSize: 20),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: buildResultList(transaction, item),
                    )),
                  ],
                ),
        ),
      );
    }

    return Consumer<TransactionProvider>(
        builder: (context, transactions, child) {
      return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomFABWidget(
              heroTag: "0",
              label: "  Send  ",
              icon: Icons.arrow_upward,
              onPressed: () => showInOutBoundForm(context, false),
            ),
            const SizedBox(width: 10),
            CustomFABWidget(
              heroTag: "1",
              label: "Receive",
              icon: Icons.arrow_downward,
              onPressed: () => showInOutBoundForm(context, true),
            ),
          ],
        ),
        appBar: AppBar(
          title: const Text(
            'Transactions',
          ),
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              }),
          actions: [
            InkWell(
              onTap: () => Navigator.pushNamed(context, '/items'),
              child: SvgPicture.asset(
                "assets/addItem.svg",
                width: 30,
                height: 30,
                color: Colors.black,
              ),
            ),
          ],

          // Other Sliver Widgets
        ),
        body: buildSearchBar(transactions),
      );
    });
  }
}
