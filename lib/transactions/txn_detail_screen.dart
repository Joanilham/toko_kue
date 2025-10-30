import 'package:flutter/material.dart';
import 'package:toko_sahabat/db/repository.dart';
import 'package:toko_sahabat/models/txn.dart';
import 'package:toko_sahabat/transactions/receipt_screen.dart';
import 'package:toko_sahabat/utils/format.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

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

  void _printReceipt() async {
    final items = await Repo.instance.getTxnItems(widget.txn.id!);
    final cart = {for (var item in items) item.id!: item.quantity!};
    final allItems = await Repo.instance.getAllItems();

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReceiptScreen(
          txnId: widget.txn.id!,
          cart: cart,
          items: allItems,
          total: widget.txn.total,
        ),
      ),
    );
  }

  void _launchMaps() async {
    if (widget.txn.location != null) {
      final latlong = widget.txn.location!.split(',');
      final lat = double.parse(latlong[0]);
      final long = double.parse(latlong[1]);
      final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pesanan #${widget.txn.id}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Tanggal: ${DateFormat.yMd().add_jms().format(DateTime.parse(widget.txn.datetime))}'),
            Text('Total: ${formatCurrency.format(widget.txn.total)}'),
            Text('Lokasi: ${widget.txn.location ?? ''}'),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: ['pending', 'terima', 'kirim', 'selesai', 'batal']
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
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _printReceipt,
                  child: const Text('Cetak Struk'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _launchMaps,
                  child: const Text('Lihat di Google Maps'),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}