import 'package:flutter/material.dart';

class MediaSearchBar<T> extends StatefulWidget {
  final void Function(String) onSearchChanged;
  final T Function(String)? onExpressionParsed;

  const MediaSearchBar({
    super.key,
    required this.onSearchChanged,
    this.onExpressionParsed,
  });

  @override
  State<MediaSearchBar> createState() => _MediaSearchBarState();
}

class _MediaSearchBarState<T> extends State<MediaSearchBar<T>> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      widget.onSearchChanged(_searchController.text);
      widget.onExpressionParsed?.call(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          labelText: 'Search Videos',
          hintText: 'What are you looking for?',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    );
  }
}
