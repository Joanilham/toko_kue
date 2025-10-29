import 'package:flutter/material.dart';
import 'package:toko_sahabat/auth/login_screen.dart';
import 'package:toko_sahabat/db/repository.dart';
import 'package:toko_sahabat/models/item.dart';
import 'package:toko_sahabat/models/user.dart';
import 'package:toko_sahabat/transactions/transaction_history_screen.dart';
import 'package:toko_sahabat/transactions/checkout_screen.dart';
import 'package:toko_sahabat/utils/format.dart';

class BuyerMenuScreen extends StatefulWidget {
  final User user;

  const BuyerMenuScreen({super.key, required this.user});

  @override
  State<BuyerMenuScreen> createState() => _BuyerMenuScreenState();
}

class _BuyerMenuScreenState extends State<BuyerMenuScreen> {
  List<Item> _items = [];
  final Map<int, int> _cart = {};

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final items = await Repo.instance.getAllItems();
    setState(() {
      _items = items;
    });
  }

  void _addToCart(Item item) {
    setState(() {
      _cart.update(item.id!, (value) => value + 1, ifAbsent: () => 1);
    });
  }

  void _removeFromCart(Item item) {
    setState(() {
      if (_cart.containsKey(item.id!) && _cart[item.id!]! > 0) {
        _cart.update(item.id!, (value) => value - 1);
        if (_cart[item.id!] == 0) {
          _cart.remove(item.id!);
        }
      }
    });
  }

  double _calculateTotal() {
    double total = 0;
    _cart.forEach((itemId, quantity) {
      final item = _items.firstWhere((item) => item.id == itemId);
      total += item.price * quantity;
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: Text('Selamat datang, ${widget.user.username}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Riwayat Transaksi',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      BuyerTransactionsScreen(user: widget.user),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                final quantity = _cart[item.id] ?? 0;
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(item.description),
                              Text(
                                formatCurrency.format(item.price),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () => _removeFromCart(item),
                            ),
                            Text(
                              '$quantity',
                              style: const TextStyle(fontSize: 16),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () => _addToCart(item),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: ${formatCurrency.format(_calculateTotal())}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: _cart.isEmpty
                      ? null
                      : () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TransactionsScreen(
                                user: widget.user,
                                cart: _cart,
                                items: _items,
                              ),
                            ),
                          );
                          if (result == true) {
                            setState(() {
                              _cart.clear();
                            });
                          }
                        },
                  child: const Text('Checkout'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}