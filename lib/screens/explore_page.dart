import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

  @override
  Widget build(BuildContext context) {
    final trackerState = ref.watch(tripRepositoryProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add-trip'),
        label: const Text('New Trip'),
        icon: const Icon(Icons.add_location_alt),
      ),
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

              final activeTrips = trackerState.trips.where((t) => !t.isCompleted).toList();
              final completedTrips = trackerState.trips.where((t) => t.isCompleted).toList();

              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    floating: true,
                    pinned: false,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    title: _buildAnimatedSearchField(),
                    actions: [
                      IconButton(
                        icon: Icon(
                          Icons.sync, 
                          color: trackerState.isLoading ? Colors.grey : Colors.blue
                        ),
                        onPressed: trackerState.isLoading 
                            ? null 
                            : () => ref.read(tripRepositoryProvider.notifier).syncWithApi(),
                      ),
                      if (!_isSearchActive)
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () => setState(() => _isSearchActive = true),
                        ),
                      const SizedBox(width: 8),
                    ],
                    bottom: trackerState.isLoading 
                      ? const PreferredSize(
                          preferredSize: Size.fromHeight(2),
                          child: LinearProgressIndicator(minHeight: 2),
                        )
                      : null,
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      if (_isSearchActive && _searchQuery.isEmpty)
                        _buildSearchHistory(),

                      if (!_isSearchActive) ...[
                        _buildBudgetSummaryCard(context, trackerState),
                        _buildCategoryBreakdown(trackerState),
                        _buildTripsSection('Active Trips', activeTrips, false),
                        if (completedTrips.isNotEmpty)
                          _buildTripsSection('Past Adventures', completedTrips, true),
                      ],
                      
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 32, 20, 8),
                        child: Text(
                          _isSearchActive ? 'Search results' : 'Curated Destinations', 
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

  Widget _buildSearchHistory() {
    return ListenableBuilder(
      listenable: widget.settingsManager,
      builder: (context, child) {
        final history = widget.settingsManager.searchHistory;
        if (history.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Recent Searches', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: history.map((term) => ActionChip(
                  label: Text(term),
                  onPressed: () {
                    setState(() {
                      _searchQuery = term;
                      _searchController.text = term;
                    });
                  },
                )).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryBreakdown(CurrentTripData state) {
    final spending = state.categorySpending;
    if (spending.isEmpty) return const SizedBox.shrink();

    final categories = spending.keys.toList();
    
    return ListenableBuilder(
      listenable: widget.settingsManager,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 16, 24, 12),
              child: Text('Spending Breakdown', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final usdAmount = spending[cat]!;
                  final convertedAmount = widget.settingsManager.convert(usdAmount);
                  final symbol = widget.settingsManager.currencySymbol;

                  return Container(
                    width: 120,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_getCategoryIcon(cat), color: Theme.of(context).colorScheme.primary, size: 20),
                        const SizedBox(height: 4),
                        Text(cat, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text('$symbol${convertedAmount.toStringAsFixed(0)}', 
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Food': return Icons.restaurant;
      case 'Transport': return Icons.directions_car;
      case 'Housing': return Icons.hotel;
      case 'Entertainment': return Icons.local_activity;
      case 'Shopping': return Icons.shopping_bag;
      default: return Icons.receipt_long;
    }
  }

  Widget _buildTripsSection(String title, List<Trip> trips, bool isPast) {
    if (trips.isEmpty && isPast) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
          child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: trips.isNotEmpty ? trips.length : 1,
            itemBuilder: (context, index) {
              if (trips.isEmpty) {
                return _buildEmptyTripCard();
              }
              final trip = trips[index];
              return _buildTripCard(trip, isPast);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyTripCard() {
    return Container(
      width: 170,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: const Center(
        child: Text('No active trips', style: TextStyle(color: Colors.grey, fontSize: 13)),
      ),
    );
  }

  Widget _buildTripCard(Trip trip, bool isPast) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListenableBuilder(
      listenable: widget.settingsManager,
      builder: (context, child) {
        final convertedBudget = widget.settingsManager.convert(trip.budget);
        final symbol = widget.settingsManager.currencySymbol;

        return GestureDetector(
          onTap: () => context.push('/my-trip/${trip.id ?? 0}'),
          child: Container(
            width: 180,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isPast 
                  ? colorScheme.surfaceVariant.withOpacity(0.4)
                  : colorScheme.secondaryContainer.withOpacity(0.4),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(trip.title, maxLines: 1, overflow: TextOverflow.ellipsis, 
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 15,
                          decoration: isPast ? TextDecoration.lineThrough : null,
                        )),
                    ),
                    if (isPast) const Icon(Icons.check_circle, size: 14, color: Colors.green),
                  ],
                ),
                Text(trip.destination, style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant)),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('$symbol${convertedBudget.toStringAsFixed(0)}', 
                      style: TextStyle(
                        color: isPast ? Colors.grey : colorScheme.primary, 
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      )),
                    Icon(Icons.arrow_forward_ios, size: 12, color: colorScheme.primary.withOpacity(0.5)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBudgetSummaryCard(BuildContext context, CurrentTripData trackerState) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return ListenableBuilder(
      listenable: Listenable.merge([widget.orderManager, widget.cartManager, widget.settingsManager]),
      builder: (context, child) {
        final double totalBudgetUsd = widget.settingsManager.budgetLimit;
        final double currentSpentUsd = trackerState.currentSpending + widget.orderManager.totalSpent;
        
        final double currentSpent = widget.settingsManager.convert(currentSpentUsd);
        final double totalBudget = widget.settingsManager.convert(totalBudgetUsd);
        final String symbol = widget.settingsManager.currencySymbol;
        
        final double progress = totalBudgetUsd > 0 ? (currentSpentUsd / totalBudgetUsd).clamp(0.0, 1.0) : 0.0;

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
              Text('Monthly Spending Limit', style: textTheme.labelLarge?.copyWith(color: Colors.white70)),
              Text('$symbol${currentSpent.toStringAsFixed(0)}', 
                style: textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Limit: $symbol${totalBudget.toStringAsFixed(0)}', style: textTheme.labelSmall?.copyWith(color: Colors.white70)),
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

  Widget _buildAnimatedSearchField() {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: _searchController,
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            widget.settingsManager.addSearchTerm(value);
          }
        },
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
