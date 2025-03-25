import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:going50/core/theme/app_colors.dart';
import 'package:going50/presentation/providers/social_provider.dart';
import 'package:going50/core_models/user_profile.dart';
import 'package:going50/core/constants/route_constants.dart';

/// FriendsView displays the user's connections and allows finding new friends.
///
/// This component includes:
/// - List of current friends
/// - Ability to search for new friends
/// - Friend request functionality
/// - Can be displayed in compact mode for the main community screen
class FriendsView extends StatefulWidget {
  /// Whether to display in compact mode with limited entries and UI elements
  final bool isCompactMode;
  
  const FriendsView({
    super.key, 
    this.isCompactMode = false,
  });

  @override
  State<FriendsView> createState() => _FriendsViewState();
}

class _FriendsViewState extends State<FriendsView> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SocialProvider>(context);
    final friends = provider.friends;
    
    // In compact mode, display a simplified view
    if (widget.isCompactMode) {
      return _buildCompactView(context, friends, provider);
    }
    
    // Full view with search
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSearchBar(context),
        const SizedBox(height: 16),
        if (_isSearching)
          _buildSearchResults(context)
        else
          _buildFriendsList(context, friends),
      ],
    );
  }
  
  /// Build a compact view of friends for the main community screen
  Widget _buildCompactView(BuildContext context, List<UserProfile> friends, SocialProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (friends.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 8),
            const Text(
              'No friends yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
    
    // Show a limited number of friends in a simple format
    // Use just 2 items to ensure they're fully visible in compact view
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: friends.length > 2 ? 2 : friends.length,
      itemBuilder: (context, index) {
        final friend = friends[index];
        return InkWell(
          onTap: () {
            // Navigate to friend profile
            Navigator.of(context).pushNamed(
              CommunityRoutes.friendProfile,
              arguments: friend.id,
            );
          },
          borderRadius: BorderRadius.circular(8),
          child: _buildCompactFriendItem(context, friend),
        );
      },
    );
  }
  
  /// Build a compact friend item for the main screen
  Widget _buildCompactFriendItem(BuildContext context, UserProfile friend) {
    // Get time-based activity text based on createdAt timestamp
    final activityText = _getRelativeActivityTime(friend.createdAt);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Avatar placeholder
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                friend.name.substring(0, 1).toUpperCase(),
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Friend name
          Expanded(
            child: Text(
              friend.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Activity indicator - using actual data from user profile
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  activityText,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper to determine relative time for friend activity
  String _getRelativeActivityTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${(difference.inDays / 7).round()}w ago';
    }
  }
  
  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for friends...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _isSearching = false;
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 16,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                  _isSearching = value.isNotEmpty;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          if (!_isSearching)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Friends',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Show find friends dialog
                    _showFindFriendsDialog(context);
                  },
                  icon: const Icon(Icons.person_add, size: 16),
                  label: const Text('Find Friends'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
  
  Widget _buildFriendsList(BuildContext context, List<UserProfile> friends) {
    return Expanded(
      child: friends.isEmpty
          ? _buildEmptyFriendsList()
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: friends.length,
              itemBuilder: (context, index) {
                final friend = friends[index];
                return _buildFriendCard(context, friend);
              },
            ),
    );
  }
  
  Widget _buildEmptyFriendsList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          const Text(
            'No friends yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Connect with other eco-drivers',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Show find friends dialog
              _showFindFriendsDialog(context);
            },
            icon: const Icon(Icons.person_add),
            label: const Text('Find Friends'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFriendCard(BuildContext context, UserProfile friend) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Avatar placeholder
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                color: Colors.grey.shade700,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            
            // Friend info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    friend.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Member since ${_formatDate(friend.createdAt)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            
            // Actions
            IconButton(
              icon: const Icon(Icons.message_outlined),
              color: AppColors.secondary,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Messaging feature coming soon'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person_outlined),
              color: AppColors.secondary,
              onPressed: () {
                // Navigate to friend profile
                Navigator.of(context).pushNamed(
                  CommunityRoutes.friendProfile,
                  arguments: friend.id,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSearchResults(BuildContext context) {
    // Mock search results - in a real app, this would query a database
    final List<Map<String, dynamic>> searchResults = [
      {
        'id': 'result1',
        'name': 'Chris Taylor',
        'mutualFriends': 3,
        'ecoScore': 87,
      },
      {
        'id': 'result2',
        'name': 'Jordan Kim',
        'mutualFriends': 1,
        'ecoScore': 92,
      },
      {
        'id': 'result3',
        'name': 'Robin Chen',
        'mutualFriends': 0,
        'ecoScore': 76,
      },
    ].where((user) => 
        (user['name'] as String).toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
    
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Search Results (${searchResults.length})',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: searchResults.isEmpty
                ? Center(
                    child: Text(
                      'No users found matching "$_searchQuery"',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final result = searchResults[index];
                      return _buildSearchResultCard(context, result);
                    },
                  ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSearchResultCard(BuildContext context, Map<String, dynamic> result) {
    final SocialProvider provider = Provider.of<SocialProvider>(context, listen: false);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Avatar placeholder
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                color: Colors.grey.shade700,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            
            // User info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Flexible(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 12,
                              color: Colors.grey.shade700,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                '${result['mutualFriends']} mutual friends',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade700,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.eco_outlined,
                              size: 12,
                              color: AppColors.getEcoScoreColor(result['ecoScore'].toDouble()),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Eco Score: ${result['ecoScore']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Add friend button
            ElevatedButton(
              onPressed: () async {
                final success = await provider.addFriend(result['id']);
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Friend request sent to ${result['name']}'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  
                  // Clear search
                  _searchController.clear();
                  setState(() {
                    _isSearching = false;
                    _searchQuery = '';
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minimumSize: const Size(40, 36),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showFindFriendsDialog(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Find Friends',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Connect with other eco-drivers to compare your performance and compete in challenges together.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by name or email',
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Suggested Friends',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    children: [
                      _buildSuggestedFriendTile(
                        'Riley Johnson',
                        'Based on your location',
                        4,
                        88,
                      ),
                      const SizedBox(height: 12),
                      _buildSuggestedFriendTile(
                        'Morgan Smith',
                        'Similar driving patterns',
                        2,
                        92,
                      ),
                      const SizedBox(height: 12),
                      _buildSuggestedFriendTile(
                        'Casey Williams',
                        'Completed same challenges',
                        1,
                        79,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildSuggestedFriendTile(
    String name, String reason, int mutualFriends, int ecoScore) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              color: Colors.grey.shade700,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reason,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Flexible(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 12,
                            color: Colors.grey.shade700,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '$mutualFriends mutual friends',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.eco_outlined,
                            size: 12,
                            color: AppColors.getEcoScoreColor(ecoScore.toDouble()),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Eco Score: $ecoScore',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              minimumSize: const Size(40, 36),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
  
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }
} 