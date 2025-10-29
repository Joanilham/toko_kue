import 'package:flutter/material.dart';
import 'package:toko_sahabat/auth/login_screen.dart';
import 'package:toko_sahabat/db/repository.dart';
import 'package:toko_sahabat/menu/edit_item_screen.dart';
import 'package:toko_sahabat/menu/total_screen.dart';
import 'package:toko_sahabat/models/item.dart';
import 'package:toko_sahabat/models/user.dart';
import 'package:toko_sahabat/utils/format.dart';

class MenuScreen extends StatefulWidget {
  final User user;
  const MenuScreen({super.key, required this.user});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<Item> _items = [];

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

  void _addItem() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditItemScreen()),
    );
    if (result == true) {
      _loadItems();
    }
  }

  void _editItem(Item item) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditItemScreen(item: item)),
    );
    if (result == true) {
      _loadItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Menu - Manage Items'),
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
            icon: const Icon(Icons.receipt_long),
            tooltip: 'View Transactions',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TotalScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(item.description),
              trailing: Text(formatCurrency.format(item.price)),
              onTap: () => _editItem(item),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
    );
  }
}