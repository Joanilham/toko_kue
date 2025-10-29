import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:toko_sahabat/db/app_db.dart';
import 'package:toko_sahabat/models/item.dart';
import 'package:toko_sahabat/models/txn.dart';
import 'package:toko_sahabat/models/user.dart';

class Repo {
  static final Repo instance = Repo._init();
  Repo._init();

  Future<User?> login(String username, String password) async {
    final db = await AppDatabase.instance.database;
    final hashedPassword = sha256.convert(utf8.encode(password)).toString();
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, hashedPassword],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<int> register(User user) async {
    final db = await AppDatabase.instance.database;
    final hashedPassword = sha256.convert(utf8.encode(user.password)).toString();
    final userWithHashedPassword = user.copyWith(password: hashedPassword);
    return await db.insert('users', userWithHashedPassword.toMap());
  }

  Future<int> createItem(Item item) async {
    final db = await AppDatabase.instance.database;
    return await db.insert('items', item.toMap());
  }

  Future<List<Item>> getAllItems() async {
    final db = await AppDatabase.instance.database;
    final List<Map<String, dynamic>> maps = await db.query('items');
    return List.generate(maps.length, (i) {
      return Item.fromMap(maps[i]);
    });
  }

  Future<int> updateItem(Item item) async {
    final db = await AppDatabase.instance.database;
    return await db.update(
      'items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> createTxn(Txn txn) async {
    final db = await AppDatabase.instance.database;
    return await db.insert('txns', txn.toMap());
  }

  Future<int> createTxnItem(int txnId, int itemId, int quantity) async {
    final db = await AppDatabase.instance.database;
    return await db.insert('txn_items', {
      'txn_id': txnId,
      'item_id': itemId,
      'quantity': quantity,
    });
  }

  Future<List<Txn>> getAllTransactions() async {
    final db = await AppDatabase.instance.database;
    final List<Map<String, dynamic>> maps =
        await db.query('txns', orderBy: 'datetime DESC');
    return List.generate(maps.length, (i) {
      return Txn.fromMap(maps[i]);
    });
  }

  Future<List<Txn>> getTransactionsByUserId(int userId) async {
    final db = await AppDatabase.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'txns',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'datetime DESC',
    );
    return List.generate(maps.length, (i) {
      return Txn.fromMap(maps[i]);
    });
  }

  Future<int> updateTxnStatus(int txnId, String status) async {
    final db = await AppDatabase.instance.database;
    return await db.update(
      'txns',
      {'status': status},
      where: 'id = ?',
      whereArgs: [txnId],
    );
  }

  Future<Txn?> getTxnById(int txnId) async {
    final db = await AppDatabase.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'txns',
      where: 'id = ?',
      whereArgs: [txnId],
    );

    if (maps.isNotEmpty) {
      return Txn.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getTxnItems(int txnId) async {
    final db = await AppDatabase.instance.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT i.name, ti.quantity, i.price 
      FROM txn_items ti
      JOIN items i ON i.id = ti.item_id
      WHERE ti.txn_id = ?
    ''', [txnId]);
    return maps;
  }
}