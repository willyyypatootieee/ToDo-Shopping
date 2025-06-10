import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shopping_list_model.dart';
import '../widgets/shopping_list_item.dart';
import '../models/shopping_item.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});
  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen>
    with WidgetsBindingObserver {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _saveState();
    } else if (state == AppLifecycleState.resumed) {
      _loadState();
    }
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    final items = context.read<ShoppingListModel>().items;
    final jsonList = items
        .map((e) => {'name': e.name, 'isDone': e.isDone})
        .toList();
    await prefs.setString('shopping_list', jsonEncode(jsonList));
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('shopping_list');
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      final items = jsonList
          .map((e) => ShoppingItem(name: e['name'], isDone: e['isDone']))
          .toList();
      context.read<ShoppingListModel>().setItems(items);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Belanja',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: color.primaryContainer,
        foregroundColor: color.onPrimaryContainer,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Tambah item baru',
                      filled: true,
                      fillColor: color.surfaceContainerHighest,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 0,
                      ),
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        context.read<ShoppingListModel>().addItem(value.trim());
                        _controller.clear();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: () {
                    final value = _controller.text.trim();
                    if (value.isNotEmpty) {
                      context.read<ShoppingListModel>().addItem(value);
                      _controller.clear();
                    }
                  },
                  shape: const CircleBorder(),
                  backgroundColor: color.primary,
                  foregroundColor: color.onPrimary,
                  mini: true,
                  child: const Icon(Icons.add_rounded),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<ShoppingListModel>(
              builder: (context, model, _) {
                if (model.items.isEmpty) {
                  return Center(
                    child: Text(
                      'Belum ada item',
                      style: TextStyle(color: color.outline, fontSize: 18),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: model.items.length,
                  itemBuilder: (context, index) {
                    final item = model.items[index];
                    return ShoppingListItem(
                      item: item,
                      onToggle: () => model.toggleItem(index),
                      onDelete: () => model.removeItem(index),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: color.surface,
    );
  }
}
