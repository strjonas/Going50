import 'package:flutter/material.dart';

/// A search and filter bar for the trip history screen.
///
/// Includes a search field with icon and a filter button that opens the filter sheet.
class SearchFilterBar extends StatefulWidget {
  /// Callback when the search query changes
  final Function(String) onSearch;

  /// Callback when the filter button is pressed
  final VoidCallback onFilterPressed;

  /// Current search query
  final String searchQuery;

  /// Constructor
  const SearchFilterBar({
    super.key,
    required this.onSearch,
    required this.onFilterPressed,
    this.searchQuery = '',
  });

  @override
  State<SearchFilterBar> createState() => _SearchFilterBarState();
}

class _SearchFilterBarState extends State<SearchFilterBar> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
  }

  @override
  void didUpdateWidget(SearchFilterBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != oldWidget.searchQuery) {
      _searchController.text = widget.searchQuery;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          // Search field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search trips...',
                  prefixIcon: const Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 16.0,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            widget.onSearch('');
                          },
                        )
                      : null,
                ),
                onChanged: widget.onSearch,
                textInputAction: TextInputAction.search,
              ),
            ),
          ),
          
          // Filter button
          const SizedBox(width: 8.0),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: IconButton(
              icon: const Icon(Icons.filter_list),
              tooltip: 'Filter',
              onPressed: widget.onFilterPressed,
            ),
          ),
        ],
      ),
    );
  }
} 