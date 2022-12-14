import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uts_osy/UI/transaction_details_screen.dart';
import 'package:uts_osy/models/transactions/transaction_model.dart';
import 'package:uts_osy/providers/transaction_provider.dart';


class SearchWidget extends SearchDelegate<Transaction> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, Transaction()); // for closing the search page and going back
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SearchFinder(query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SearchFinder(query: query);
  }
}

class SearchFinder extends StatelessWidget {
  final String query;

  const SearchFinder({Key key, this.query}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    context.watch<TransactionProvider>().getTransactions();
    TransactionProvider databaseProvider = Provider.of<TransactionProvider>(context);
    return FutureBuilder<List<Transaction>>(
      future: databaseProvider.searchForTransaction(query),
      builder: (context, snapshot) {
        ///* this is where we filter data

        return snapshot.data == null
            ? Center(
                child: Text(
                  'No results found !',
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        color: Colors.black,
                      ),
                ),
              )
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  // passing as a custom list
                  final Transaction contactListItem = snapshot.data[index];

                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TransactionDetailsScreen()));
                    },
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contactListItem.quantity.toString(),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          contactListItem.id.toString(),
                          textScaleFactor: 1.0,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(color: Colors.black),
                        ),
                      ],
                    ),
                  );
                },
              );
      },
    );
  }
}