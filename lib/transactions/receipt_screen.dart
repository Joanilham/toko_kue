import 'package:flutter/material.dart';
import 'package:toko_sahabat/models/item.dart';
import 'package:toko_sahabat/utils/format.dart';

class ReceiptScreen extends StatelessWidget {
  final int txnId;
  final Map<int, int> cart;
  final List<Item> items;
  final double total;

  const ReceiptScreen({
    super.key,
    required this.txnId,
    required this.cart,
    required this.items,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Transaction #$txnId',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Items:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  final itemId = cart.keys.elementAt(index);
                  final quantity = cart[itemId];
                  final item =
                      items.firstWhere((element) => element.id == itemId);
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text('Qty: $quantity'),
                    trailing: Text(formatCurrency.format(item.price * quantity!)),
                  );
                },
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  formatCurrency.format(total),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Kembali ke menu utama pembeli dan hapus semua layar di atasnya
                  Navigator.pop(context, true);
                },
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}