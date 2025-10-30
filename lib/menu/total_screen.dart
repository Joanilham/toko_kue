import 'package:flutter/material.dart';
import 'package:toko_sahabat/db/repository.dart';
import 'package:toko_sahabat/models/txn.dart';
import 'package:toko_sahabat/transactions/txn_detail_screen.dart';
import 'package:toko_sahabat/utils/format.dart';
import 'package:intl/intl.dart';

class TotalScreen extends StatefulWidget {
  const TotalScreen({super.key});

  @override
  State<TotalScreen> createState() => _TotalScreenState();
}

class _TotalScreenState extends State<TotalScreen> {
  List<Txn> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final transactions = await Repo.instance.getAllTransactions();
    setState(() {
      _transactions = transactions;
    });
  }

  void _viewTransactionDetail(Txn txn) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TxnDetailScreen(txn: txn)),
    );
    if (result == true) {
      _loadTransactions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('semua transaksi'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadTransactions,
        child: ListView.builder(
          itemCount: _transactions.length,
          itemBuilder: (context, index) {
            final txn = _transactions[index];
            return Card(
              child: ListTile(
                title: Text('Transaksi #${txn.id}'),
                subtitle: Text(
                    'Pembeli: ${txn.buyerName ?? '-'}\nDate: ${DateFormat.yMd().add_jms().format(DateTime.parse(txn.datetime))}\nStatus: ${txn.status}'),
                trailing: Text(formatCurrency.format(txn.total)),
                isThreeLine: true,
                onTap: () => _viewTransactionDetail(txn),
              ),
            );
          },
        ),
      ),
    );
  }
}
