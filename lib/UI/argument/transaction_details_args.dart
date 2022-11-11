import 'package:uts_osy/models/items/item_model.dart';
import 'package:uts_osy/models/transactions/transaction_model.dart';

class TransactionsDetailsArgument {
 final Transaction transaction;
  final Item item;

  const TransactionsDetailsArgument(this.transaction, this.item);
}