import 'package:flutter/material.dart';
import 'package:toko_sahabat/db/repository.dart';
import 'package:toko_sahabat/models/item.dart';

class EditItemScreen extends StatefulWidget {
  final Item? item;

  const EditItemScreen({super.key, this.item});

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item?.name ?? '');
    _descriptionController = TextEditingController(text: widget.item?.description ?? '');
    _priceController = TextEditingController(text: widget.item?.price.toString() ?? '');
  }

  Future<void> _saveItem() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final description = _descriptionController.text;
      final price = double.tryParse(_priceController.text) ?? 0.0;

      final item = Item(
        id: widget.item?.id,
        name: name,
        description: description,
        price: price,
      );

      if (widget.item == null) {
        await Repo.instance.createItem(item);
      } else {
        await Repo.instance.updateItem(item);
      }

      if (!mounted) return;
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'tambah item' : 'Edit Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Item'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'isi nama item terlebih dahulu';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Deskripsi Item'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'isi deskripsi item terlebih dahulu';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Harga Item'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || double.tryParse(value) == null) {
                    return 'isi harga item terlebih dahulu';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveItem,
                child: const Text('Simpan Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}