import 'dart:async';

import 'package:flutter/material.dart';

class MediaFilter {
  String query;
  double minDuration; // In minutes
  bool showFavoritesOnly;
  String? category;

  MediaFilter({
    this.query = '',
    this.minDuration = 0.0,
    this.showFavoritesOnly = false,
    this.category,
  });

  // Helper to check if any advanced filters are active
  bool get isCustomized =>
      minDuration > 0 || showFavoritesOnly || category != null;
}

class MediaSearchBar extends StatefulWidget {
  final Function(MediaFilter) onFilterChanged;

  const MediaSearchBar({super.key, required this.onFilterChanged});

  @override
  State<MediaSearchBar> createState() => _MediaSearchBarState();
}

class _MediaSearchBarState extends State<MediaSearchBar> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  // Internal state of the filters
  MediaFilter _currentFilter = MediaFilter();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _currentFilter.query = _searchController.text;
      widget.onFilterChanged(_currentFilter);
    });
  }

  void _openAdvancedFilters() async {
    // Show the UI-driven filter menu
    final result = await showModalBottomSheet<MediaFilter>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _FilterBottomSheet(initialFilter: _currentFilter),
    );

    if (result != null) {
      setState(() {
        _currentFilter = result;
        // Sync the text controller if the query was cleared in the modal
        if (_currentFilter.query.isEmpty) _searchController.clear();
      });
      widget.onFilterChanged(_currentFilter);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          labelText: 'Search Videos',
          hintText: 'What are you looking for?',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.tune),
                color: _currentFilter.isCustomized ? Colors.blue : null,
                onPressed: _openAdvancedFilters,
              ),
              if (_currentFilter.isCustomized)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}

// Separate StatefulWidget for the Bottom Sheet to handle its own UI state
class _FilterBottomSheet extends StatefulWidget {
  final MediaFilter initialFilter;
  const _FilterBottomSheet({required this.initialFilter});

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  late MediaFilter tempFilter;

  @override
  void initState() {
    super.initState();
    // Create a copy so we don't apply changes until "Apply" is pressed
    tempFilter = MediaFilter(
      query: widget.initialFilter.query,
      minDuration: widget.initialFilter.minDuration,
      showFavoritesOnly: widget.initialFilter.showFavoritesOnly,
      category: widget.initialFilter.category,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Filters", style: Theme.of(context).textTheme.headlineSmall),
              TextButton(
                onPressed: () => setState(() => tempFilter = MediaFilter()),
                child: const Text("Reset All"),
              ),
            ],
          ),
          const Divider(),
          SwitchListTile(
            title: const Text("Favorites Only"),
            value: tempFilter.showFavoritesOnly,
            onChanged: (val) =>
                setState(() => tempFilter.showFavoritesOnly = val),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text("Min Duration (minutes)"),
          ),
          Slider(
            value: tempFilter.minDuration,
            max: 120,
            divisions: 12,
            label: "${tempFilter.minDuration.round()}m",
            onChanged: (val) => setState(() => tempFilter.minDuration = val),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
              onPressed: () => Navigator.pop(context, tempFilter),
              child: const Text("Apply Filters"),
            ),
          ),
        ],
      ),
    );
  }
}
