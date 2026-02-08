import 'package:flutter/material.dart';
import '../../models/item.dart';
import '../../services/item_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ItemService _itemService = ItemService();
  final _searchController = TextEditingController();
  List<Item> _results = [];
  bool _isLoading = false;

  void _search() async {
    if (_searchController.text.isEmpty) return;
    
    setState(() => _isLoading = true);
    final items = await _itemService.getItems(search: _searchController.text);
    setState(() {
      _results = items;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search items...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
          onSubmitted: (_) => _search(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _search,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _results.isEmpty
              ? const Center(child: Text('Enter keywords to find items.'))
              : ListView.builder(
                  itemCount: _results.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final item = _results[index];
                    return ListTile(
                      title: Text(item.title),
                      subtitle: Text(item.itemType),
                      leading: item.images.isNotEmpty
                          ? Image.network(item.images[0].image, width: 50, fit: BoxFit.cover)
                          : const Icon(Icons.image),
                      onTap: () {
                        Navigator.pushNamed(context, '/item-detail', arguments: item);
                      },
                    );
                  },
                ),
    );
  }
}
