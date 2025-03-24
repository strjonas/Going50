import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:going50/core/constants/route_constants.dart';
import 'package:going50/core_models/trip.dart';
import 'package:going50/presentation/providers/insights_provider.dart';
import 'package:going50/presentation/screens/insights/components/search_filter_bar.dart';
import 'package:going50/presentation/screens/insights/components/trip_list_item.dart';
import 'package:going50/presentation/screens/insights/components/filter_sheet.dart';

/// The Trip History Screen allows users to browse and search past trips.
///
/// Includes:
/// - Search functionality
/// - Filtering options
/// - Sorting controls
/// - Grouped trip list by date
class TripHistoryScreen extends StatefulWidget {
  /// Constructor
  const TripHistoryScreen({super.key});

  @override
  State<TripHistoryScreen> createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen> {
  // Search and filter state
  String _searchQuery = '';
  DateTimeRange? _dateRange;
  RangeValues _ecoScoreRange = const RangeValues(0, 100);
  RangeValues _distanceRange = const RangeValues(0, 100);
  List<String> _selectedEventTypes = [];
  
  // Sorting state
  String _sortBy = 'date'; // 'date', 'score', 'distance'
  bool _sortAscending = false;
  
  // Scroll controller for infinite scrolling
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    
    // Load initial trips
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshTrips();
    });
    
    // Set up scroll listener for infinite scrolling
    _scrollController.addListener(_scrollListener);
  }
  
  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }
  
  /// Listen for scroll events to implement infinite scrolling
  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      // When we're near the bottom, load more trips
      _loadMoreTrips();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Search and filter bar
          SearchFilterBar(
            onSearch: _handleSearch,
            onFilterPressed: _showFilterSheet,
            searchQuery: _searchQuery,
          ),
          
          // Sorting controls
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                Text(
                  'Sort by:',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(width: 8),
                _buildSortDropdown(),
                const SizedBox(width: 16),
                IconButton(
                  icon: Icon(_sortAscending ? Icons.arrow_upward : Icons.arrow_downward),
                  onPressed: _toggleSortOrder,
                  tooltip: _sortAscending ? 'Ascending' : 'Descending',
                  iconSize: 20,
                ),
                const Spacer(),
                if (_hasActiveFilters())
                  TextButton.icon(
                    icon: const Icon(Icons.filter_alt_off, size: 18),
                    label: const Text('Clear Filters'),
                    onPressed: _clearFilters,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
              ],
            ),
          ),
          
          // Trip list
          Expanded(
            child: Consumer<InsightsProvider>(
              builder: (context, insightsProvider, child) {
                if (insightsProvider.isLoading && insightsProvider.recentTrips.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                
                if (insightsProvider.errorMessage != null && insightsProvider.recentTrips.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading trips',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          insightsProvider.errorMessage ?? 'Unknown error',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _refreshTrips,
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                }
                
                // Apply filters and search to the trips
                final filteredTrips = _getFilteredTrips(insightsProvider.recentTrips);
                
                if (filteredTrips.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No trips found',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _searchQuery.isNotEmpty
                              ? 'Try different search terms'
                              : _hasActiveFilters()
                                  ? 'Try different filter settings'
                                  : 'No trips recorded yet',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 24),
                        if (_hasActiveFilters() || _searchQuery.isNotEmpty)
                          ElevatedButton(
                            onPressed: _clearFilters,
                            child: const Text('Clear Filters'),
                          ),
                      ],
                    ),
                  );
                }
                
                // Group trips by date for display
                final groupedTrips = _groupTripsByDate(filteredTrips);
                
                return RefreshIndicator(
                  onRefresh: _refreshTrips,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: groupedTrips.length + (insightsProvider.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Show loading indicator at the bottom when loading more
                      if (insightsProvider.isLoading && index == groupedTrips.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      
                      final dateGroup = groupedTrips[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date header
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Text(
                              dateGroup.key,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // Trip items
                          ...dateGroup.trips.map((trip) => TripListItem(
                            trip: trip,
                            onTap: () => _navigateToTripDetail(trip.id),
                          )),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  /// Build the sort dropdown button
  Widget _buildSortDropdown() {
    return DropdownButton<String>(
      value: _sortBy,
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _sortBy = value;
          });
        }
      },
      items: const [
        DropdownMenuItem(
          value: 'date',
          child: Text('Date'),
        ),
        DropdownMenuItem(
          value: 'score',
          child: Text('Eco-Score'),
        ),
        DropdownMenuItem(
          value: 'distance',
          child: Text('Distance'),
        ),
      ],
      isDense: true,
      underline: const SizedBox(),
    );
  }
  
  /// Toggle between ascending and descending sort order
  void _toggleSortOrder() {
    setState(() {
      _sortAscending = !_sortAscending;
    });
  }
  
  /// Handle search query changes
  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
  }
  
  /// Show the filter sheet
  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: FilterSheet(
                initialDateRange: _dateRange,
                initialEcoScoreRange: _ecoScoreRange,
                initialDistanceRange: _distanceRange,
                initialSelectedEventTypes: _selectedEventTypes,
                onApply: (dateRange, ecoScoreRange, distanceRange, selectedEventTypes) {
                  setState(() {
                    _dateRange = dateRange;
                    _ecoScoreRange = ecoScoreRange;
                    _distanceRange = distanceRange;
                    _selectedEventTypes = selectedEventTypes;
                  });
                },
              ),
            );
          },
        );
      },
    );
  }
  
  /// Check if any filters are active
  bool _hasActiveFilters() {
    return _dateRange != null || 
           _ecoScoreRange.start > 0 || 
           _ecoScoreRange.end < 100 ||
           _distanceRange.start > 0 || 
           _distanceRange.end < 100 ||
           _selectedEventTypes.isNotEmpty;
  }
  
  /// Clear all filters
  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _dateRange = null;
      _ecoScoreRange = const RangeValues(0, 100);
      _distanceRange = const RangeValues(0, 100);
      _selectedEventTypes = [];
    });
  }
  
  /// Apply filters, search, and sorting to trips
  List<Trip> _getFilteredTrips(List<Trip> trips) {
    // Apply date range filter
    List<Trip> filteredTrips = trips;
    
    if (_dateRange != null) {
      filteredTrips = filteredTrips.where((trip) {
        return trip.startTime.isAfter(_dateRange!.start) && 
               trip.startTime.isBefore(_dateRange!.end.add(const Duration(days: 1)));
      }).toList();
    }
    
    // Apply eco-score filter (simulated as we don't have direct access to eco-score)
    if (_ecoScoreRange.start > 0 || _ecoScoreRange.end < 100) {
      filteredTrips = filteredTrips.where((trip) {
        // Simple eco-score calculation for filtering
        final calculatedScore = _calculateEcoScore(trip);
        return calculatedScore >= _ecoScoreRange.start && 
               calculatedScore <= _ecoScoreRange.end;
      }).toList();
    }
    
    // Apply distance filter
    if (_distanceRange.start > 0 || _distanceRange.end < 100) {
      filteredTrips = filteredTrips.where((trip) {
        final distance = trip.distanceKm ?? 0;
        return distance >= _distanceRange.start && 
               distance <= _distanceRange.end;
      }).toList();
    }
    
    // Apply event type filters
    if (_selectedEventTypes.isNotEmpty) {
      filteredTrips = filteredTrips.where((trip) {
        for (final eventType in _selectedEventTypes) {
          switch (eventType) {
            case 'aggressive_acceleration':
              if ((trip.aggressiveAccelerationEvents ?? 0) > 0) return true;
              break;
            case 'hard_braking':
              if ((trip.hardBrakingEvents ?? 0) > 0) return true;
              break;
            case 'idling':
              if ((trip.idlingEvents ?? 0) > 0) return true;
              break;
            case 'excessive_speed':
              if ((trip.excessiveSpeedEvents ?? 0) > 0) return true;
              break;
          }
        }
        return false;
      }).toList();
    }
    
    // Apply search
    if (_searchQuery.isNotEmpty) {
      final searchLower = _searchQuery.toLowerCase();
      filteredTrips = filteredTrips.where((trip) {
        // Search in date/time
        final dateTime = DateFormat('MMM d, yyyy h:mm a').format(trip.startTime).toLowerCase();
        if (dateTime.contains(searchLower)) return true;
        
        // Could expand search to include other trip attributes in the future
        
        return false;
      }).toList();
    }
    
    // Apply sorting
    filteredTrips.sort((a, b) {
      switch (_sortBy) {
        case 'date':
          return _sortAscending 
              ? a.startTime.compareTo(b.startTime)
              : b.startTime.compareTo(a.startTime);
        case 'score':
          final scoreA = _calculateEcoScore(a);
          final scoreB = _calculateEcoScore(b);
          return _sortAscending 
              ? scoreA.compareTo(scoreB)
              : scoreB.compareTo(scoreA);
        case 'distance':
          final distanceA = a.distanceKm ?? 0;
          final distanceB = b.distanceKm ?? 0;
          return _sortAscending 
              ? distanceA.compareTo(distanceB)
              : distanceB.compareTo(distanceA);
        default:
          return _sortAscending 
              ? a.startTime.compareTo(b.startTime)
              : b.startTime.compareTo(a.startTime);
      }
    });
    
    return filteredTrips;
  }
  
  /// Group trips by date for display
  List<TripDateGroup> _groupTripsByDate(List<Trip> trips) {
    // Map to store trips by date string
    final groupMap = <String, List<Trip>>{};
    final dateFormat = DateFormat('EEEE, MMMM d, yyyy');
    
    // Group trips by date
    for (final trip in trips) {
      final dateString = dateFormat.format(trip.startTime);
      if (!groupMap.containsKey(dateString)) {
        groupMap[dateString] = [];
      }
      groupMap[dateString]!.add(trip);
    }
    
    // Convert to list of date groups
    return groupMap.entries.map((entry) {
      return TripDateGroup(key: entry.key, trips: entry.value);
    }).toList();
  }
  
  /// Navigate to trip detail screen
  void _navigateToTripDetail(String tripId) async {
    await Provider.of<InsightsProvider>(context, listen: false).selectTrip(tripId);
    if (!mounted) return;
    Navigator.of(context).pushNamed(InsightsRoutes.tripDetail, arguments: tripId);
  }
  
  /// Refresh trips from provider
  Future<void> _refreshTrips() async {
    await Provider.of<InsightsProvider>(context, listen: false).refreshTrips();
  }
  
  /// Load more trips for infinite scrolling
  Future<void> _loadMoreTrips() async {
    final provider = Provider.of<InsightsProvider>(context, listen: false);
    if (!provider.isLoading) {
      await provider.loadMoreTrips();
    }
  }
  
  /// Calculate eco-score from trip data for filtering and sorting
  /// Ideally this would come directly from the Trip object
  double _calculateEcoScore(Trip trip) {
    // Base score
    double score = 75.0;
    
    // Deduct points for events
    if (trip.aggressiveAccelerationEvents != null && trip.aggressiveAccelerationEvents! > 0) {
      score -= trip.aggressiveAccelerationEvents! * 3;
    }
    
    if (trip.hardBrakingEvents != null && trip.hardBrakingEvents! > 0) {
      score -= trip.hardBrakingEvents! * 4;
    }
    
    if (trip.idlingEvents != null && trip.idlingEvents! > 0) {
      score -= trip.idlingEvents! * 2;
    }
    
    if (trip.excessiveSpeedEvents != null && trip.excessiveSpeedEvents! > 0) {
      score -= trip.excessiveSpeedEvents! * 3;
    }
    
    // Ensure score stays within 0-100 range
    return score.clamp(0.0, 100.0);
  }
}

/// Helper class to represent a group of trips by date
class TripDateGroup {
  final String key;
  final List<Trip> trips;
  
  TripDateGroup({
    required this.key,
    required this.trips,
  });
} 