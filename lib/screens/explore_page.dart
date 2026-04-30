import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/mock_yummy_service.dart';
import '../components/components.dart';
import '../models/models.dart';
import '../models/settings_manager.dart';
import '../repositories/trip_repository.dart';

class ExplorePage extends ConsumerStatefulWidget {
  final CartManager cartManager;
  final OrderManager orderManager;
  final SettingsManager settingsManager;

  const ExplorePage({
    super.key,
    required this.cartManager, 
    required this.orderManager,
    required this.settingsManager,
  });

  @override
  ConsumerState<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends ConsumerState<ExplorePage> {
  final mockService = MockYummyService();
  late Future<ExploreData> _exploreDataFuture;
  bool _isSearchActive = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _exploreDataFuture = mockService.getExploreData();
  }

  Future<void> _testApiCall() async {
    final service = ref.read(trackerServiceProvider);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Calling API...'), duration: Duration(seconds: 1)),
    );

    try {
      final response = await service.getTrips();
      if (response.isSuccessful) {
        print('✅ SUCCESS: ${response.body}');
        _showResultDialog('API Response', response.body.toString());
      } else {
        print('❌ ERROR: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ FAILED: $e');
    }
  }

  void _showResultDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: FutureBuilder(
          future: _exploreDataFuture,
          builder: (context, AsyncSnapshot<ExploreData> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final allRestaurants = snapshot.data?.restaurants ?? [];
              final categories = snapshot.data?.categories ?? [];
              final posts = snapshot.data?.friendPosts ?? [];

              final filteredRestaurants = allRestaurants.where((r) {
                return r.name.toLowerCase().contains(_searchQuery.toLowerCase());
              }).toList();

              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    floating: true,
                    pinned: false,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    title: _buildAnimatedSearchField(),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.cloud_sync, color: Colors.blue),
                        onPressed: _testApiCall,
                      ),
                      if (!_isSearchActive)
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () => setState(() => _isSearchActive = true),
                        ),
                      const SizedBox(width: 8),
                    ],
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      if (!_isSearchActive) ...[
                        _buildBudgetSummaryCard(context),
                        _buildBudgetBreakdown(context),
                      ],
                      
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 32, 20, 8),
                        child: Text(
                          _isSearchActive ? 'Search Results' : 'Curated Destinations', 
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5)
                        ),
                      ),

                      RestaurantSection(
                        key: ValueKey(_searchQuery),
                        restaurants: filteredRestaurants,
                        cartManager: widget.cartManager,
                        orderManager: widget.orderManager,
                      ),
                      
                      if (!_isSearchActive) ...[
                        const Padding(
                          padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
                          child: Text('Trip Feed', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                        ),
                        PostSection(posts: posts),
                        CategorySection(categories: categories),
                        const SizedBox(height: 120),
                      ],
                    ]),
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _buildBudgetSummaryCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return ListenableBuilder(
      listenable: Listenable.merge([widget.settingsManager, widget.cartManager, widget.orderManager]),
      builder: (context, child) {
        final trackerState = ref.watch(tripRepositoryProvider);
        const double totalBudgetUsd = 3000.0; 
        final double currentSpentUsd = 1250.0 + 
                                     widget.orderManager.totalSpent + 
                                     widget.cartManager.totalCost +
                                     trackerState.currentSpending;
        
        final double currentSpent = widget.settingsManager.convert(currentSpentUsd);
        final String symbol = widget.settingsManager.currencySymbol;
        final double progress = (currentSpentUsd / totalBudgetUsd).clamp(0.0, 1.0);

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colorScheme.primary, colorScheme.primary.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              )
            ]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Current Spending', style: textTheme.labelLarge?.copyWith(color: Colors.white70)),
              Text('$symbol${currentSpent.toStringAsFixed(0)}', 
                style: textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Budget Progress', style: textTheme.labelSmall?.copyWith(color: Colors.white70)),
                  Text('${(progress * 100).toInt()}%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white24,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 10,
                borderRadius: BorderRadius.circular(5),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBudgetBreakdown(BuildContext context) {
    final items = [
      {'icon': Icons.flight, 'label': 'Flights', 'amount': 850.0},
      {'icon': Icons.hotel, 'label': 'Hotels', 'amount': 1200.0},
      {'icon': Icons.restaurant, 'label': 'Food', 'amount': 400.0},
      {'icon': Icons.local_activity, 'label': 'Events', 'amount': 350.0},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 12),
          child: Text('Budget Breakdown', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final amount = widget.settingsManager.convert(item['amount'] as double);
              return Container(
                width: 100,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item['icon'] as IconData, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(height: 4),
                    Text(item['label'] as String, style: const TextStyle(fontSize: 11)),
                    Text('${widget.settingsManager.currencySymbol}${amount.toInt()}', 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedSearchField() {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Search destinations...',
          prefixIcon: const Icon(Icons.search, size: 20),
          suffixIcon: _isSearchActive 
            ? IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () {
                  setState(() {
                    _isSearchActive = false;
                    _searchQuery = '';
                    _searchController.clear();
                  });
                },
              )
            : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }
}
