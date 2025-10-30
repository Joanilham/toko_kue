import 'package:flutter/material.dart';
import 'package:toko_sahabat/db/repository.dart';
import 'package:toko_sahabat/models/item.dart';
import 'package:toko_sahabat/models/txn.dart';
import 'package:toko_sahabat/models/user.dart';
import 'package:toko_sahabat/utils/format.dart';
import 'package:intl/intl.dart';

class BuyerTransactionsScreen extends StatefulWidget {
  final User user;

  const BuyerTransactionsScreen({super.key, required this.user});

  @override
  State<BuyerTransactionsScreen> createState() =>
      _BuyerTransactionsScreenState();
}

class _BuyerTransactionsScreenState extends State<BuyerTransactionsScreen> {
  List<Txn> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final transactions =
        await Repo.instance.getTransactionsByUserId(widget.user.id!);
    setState(() {
      _transactions = transactions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaksi Saya'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadTransactions,
        child: ListView.builder(
          itemCount: _transactions.length,
          itemBuilder: (context, index) {
            final txn = _transactions[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ExpansionTile(
                title: Text(
                  'Transaksi #${txn.id}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Tanggal: ${txn.datetime != null ? DateFormat.yMd().add_jms().format(DateTime.parse(txn.datetime!)) : '-'}'),
                    Text('Total: ${formatCurrency.format(txn.total ?? 0)}'),
                    Text('Status: ${txn.status.toUpperCase()}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Lokasi: ${txn.location ?? '-'}'),
                        const SizedBox(height: 8),
                        const Text('Item:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        FutureBuilder<List<Item>>(
                          future: Repo.instance.getTxnItems(txn.id!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Text('Tidak ada item dalam transaksi.');
                            }
                            final items = snapshot.data!;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: items.map((item) {
                                return ListTile(
                                  title: Text(item.name),
                                  subtitle: Text('Qty: ${item.quantity ?? 0}'),
                                  trailing: Text(formatCurrency
                                      .format(item.price * (item.quantity ?? 0))),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}