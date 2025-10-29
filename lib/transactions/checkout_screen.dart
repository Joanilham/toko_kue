import 'package:flutter/material.dart';
import 'package:toko_sahabat/db/repository.dart';
import 'package:toko_sahabat/models/item.dart';
import 'package:toko_sahabat/models/txn.dart';
import 'package:toko_sahabat/models/user.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toko_sahabat/transactions/receipt_screen.dart';
import 'package:toko_sahabat/utils/format.dart';

class TransactionsScreen extends StatefulWidget {
  final User user;
  final Map<int, int> cart;
  final List<Item> items;

  const TransactionsScreen(
      {super.key, required this.user, required this.cart, required this.items});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  Position? _currentPosition;
  bool _isFetchingLocation = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isFetchingLocation = true;
    });
    var status = await Permission.location.status;
    if (status.isDenied) {
      final result = await Permission.location.request();
      if (result.isGranted) {
        await _fetchPosition();
      }
    } else if (status.isGranted) {
      await _fetchPosition();
    }
    setState(() {
      _isFetchingLocation = false;
    });
  }

  Future<void> _fetchPosition() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error getting location: $e');
    }
  }

  double _totalPrice() {
    double total = 0;
    widget.cart.forEach((key, value) {
      final item = widget.items.firstWhere((element) => element.id == key);
      total += item.price * value;
    });
    return total;
  }

  Future<void> _checkout() async {
    final total = _totalPrice();
    final newTxn = Txn(
      userId: widget.user.id!,
      datetime: DateTime.now().toIso8601String(),
      total: total,
      location: _currentPosition != null
          ? '${_currentPosition!.latitude},${_currentPosition!.longitude}'
          : 'Location not available',
      status: 'pending',
    );

    final txnId = await Repo.instance.createTxn(newTxn);

    for (var entry in widget.cart.entries) {
      await Repo.instance.createTxnItem(txnId, entry.key, entry.value);
    }

    if (!mounted) return;

    final result = await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ReceiptScreen(
          txnId: txnId,
          cart: widget.cart,
          items: widget.items,
          total: total,
        ),
      ),
    );

    if (result == true) {
      if (!mounted) return;
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: widget.cart.length,
                itemBuilder: (context, index) {
                  final itemId = widget.cart.keys.elementAt(index);
                  final quantity = widget.cart[itemId];
                  final item = widget.items
                      .firstWhere((element) => element.id == itemId);
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text('Qty: $quantity'),
                    trailing:
                        Text(formatCurrency.format(item.price * quantity!)),
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
                  formatCurrency.format(_totalPrice()),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: _isFetchingLocation
                  ? const Row(children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 10),
                      Text("Getting location...")
                    ])
                  : Text(
                      'Location (GPS): ${_currentPosition != null ? "${_currentPosition!.latitude.toStringAsFixed(5)}, ${_currentPosition!.longitude.toStringAsFixed(5)}" : "Not available"}'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isFetchingLocation || _currentPosition == null
                    ? null
                    : _checkout,
                child: const Text('Confirm and Pay'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}