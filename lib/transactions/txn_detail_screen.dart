import 'package:flutter/material.dart';
import 'package:toko_sahabat/db/repository.dart';
import 'package:toko_sahabat/models/txn.dart';
import 'package:toko_sahabat/utils/format.dart';
import 'package:intl/intl.dart';

class TxnDetailScreen extends StatefulWidget {
  final Txn txn;
  final bool isBuyer;

  const TxnDetailScreen({super.key, required this.txn, this.isBuyer = false});

  @override
  State<TxnDetailScreen> createState() => _TxnDetailScreenState();
}

class _TxnDetailScreenState extends State<TxnDetailScreen> {
  late String _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.txn.status;
  }

  Future<void> _updateStatus() async {
    await Repo.instance.updateTxnStatus(widget.txn.id!, _selectedStatus);
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction #${widget.txn.id}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Date: ${DateFormat.yMd().add_jms().format(DateTime.parse(widget.txn.datetime))}'),
            Text('Total: ${formatCurrency.format(widget.txn.total)}'),
            Text('Location: ${widget.txn.location}'),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: ['pending', 'terima', 'kirim', 'completed', 'cancelled']
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ))
                  .toList(),
              onChanged: widget.isBuyer
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() {
                          _selectedStatus = value;
                        });
                      }
                    },
            ),
            if (!widget.isBuyer) ...[
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateStatus,
                  child: const Text('Update Status'),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}