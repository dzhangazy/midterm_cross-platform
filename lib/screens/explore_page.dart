import 'package:flutter/material.dart';
import '../api/mock_yummy_service.dart';
import '../components/components.dart';
import '../models/models.dart';
import '../models/settings_manager.dart';

class ExplorePage extends StatefulWidget {
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
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: FutureBuilder(
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
                  pinned: true,
                  expandedHeight: _isSearchActive ? 120 : 70,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  title: _buildAnimatedSearchField(),
                  bottom: _isSearchActive ? _buildSearchHistoryHeader() : null,
                  actions: [
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
                      _buildCategoryBreakdown(context),
                    ],
                    
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 32, 20, 8),
                      child: Text(
                        _isSearchActive ? 'Search Results' : 'Curated Destinations', 
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5)
                      ),
                    ),

                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: filteredRestaurants.isEmpty 
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40.0),
                              child: Text('No destinations found'),
                            ),
                          )
                        : RestaurantSection(
                            key: ValueKey(_searchQuery),
                            restaurants: filteredRestaurants,
                            cartManager: widget.cartManager,
                            orderManager: widget.orderManager,
                          ),
                    ),
                    
                    if (!_isSearchActive) ...[
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
                        child: Text('Trip Feed', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                      ),
                      PostSection(posts: posts),
                      
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
                        child: Text('Explore by Category', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                      ),
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
    );
  }

  PreferredSizeWidget _buildSearchHistoryHeader() {
    final history = widget.settingsManager.searchHistory;
    if (history.isEmpty) return const PreferredSize(preferredSize: Size.zero, child: SizedBox());

    return PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: history.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ActionChip(
                label: Text(history[index]),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
                onPressed: () {
                  setState(() {
                    _searchQuery = history[index];
                    _searchController.text = history[index];
                  });
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAnimatedSearchField() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: _isSearchActive ? MediaQuery.of(context).size.width * 0.85 : 200,
      height: 45,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: _searchController,
        autofocus: _isSearchActive,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        onSubmitted: (value) {
          widget.settingsManager.addSearchTerm(value);
          setState(() {}); 
        },
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

  Widget _buildBudgetSummaryCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    // Используем ListenableBuilder, чтобы всё менялось мгновенно
    return ListenableBuilder(
      listenable: widget.settingsManager,
      builder: (context, child) {
        const double totalBudgetUsd = 3000.0; 
        final double currentSpentUsd = 1250.0 + widget.cartManager.totalCost;
        
        // КОНВЕРТАЦИЯ
        final double totalBudget = widget.settingsManager.convert(totalBudgetUsd);
        final double currentSpent = widget.settingsManager.convert(currentSpentUsd);
        final String symbol = widget.settingsManager.currencySymbol;

        final double progress = (currentSpentUsd / totalBudgetUsd).clamp(0.0, 1.0);

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colorScheme.primary, colorScheme.primary.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Current Spending', style: textTheme.labelLarge?.copyWith(color: Colors.white70)),
              TweenAnimationBuilder<double>(
                key: ValueKey('${currentSpent}_$symbol'), // Ключ меняется при смене валюты
                tween: Tween<double>(begin: 0, end: currentSpent),
                duration: const Duration(milliseconds: 1500),
                builder: (context, value, child) {
                  return Text('$symbol${value.toStringAsFixed(0)}', 
                    style: textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold));
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Budget Progress', style: textTheme.labelMedium?.copyWith(color: Colors.white70)),
                  TweenAnimationBuilder<double>(
                    key: ValueKey('${progress}_$symbol'),
                    tween: Tween<double>(begin: 0, end: progress),
                    duration: const Duration(milliseconds: 1500),
                    builder: (context, value, child) {
                      return Text('${(value * 100).toInt()}%', 
                        style: textTheme.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TweenAnimationBuilder<double>(
                key: ValueKey('${progress}_bar'),
                tween: Tween<double>(begin: 0, end: progress),
                duration: const Duration(milliseconds: 1500),
                curve: Curves.easeOutQuart,
                builder: (context, value, child) {
                  return Container(
                    height: 14,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: value,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryBreakdown(BuildContext context) {
    final categories = [
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
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              return ListenableBuilder(
                listenable: widget.settingsManager,
                builder: (context, child) {
                  final amount = widget.settingsManager.convert(cat['amount'] as double);
                  final symbol = widget.settingsManager.currencySymbol;

                  return TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 1000 + (index * 200)), 
                    curve: Curves.elasticOut,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Opacity(
                          opacity: value.clamp(0.0, 1.0),
                          child: Container(
                            width: 110,
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.1)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(cat['icon'] as IconData, size: 26, color: Theme.of(context).colorScheme.primary),
                                const SizedBox(height: 4),
                                Text(cat['label'] as String, style: const TextStyle(fontSize: 12)),
                                Text('$symbol${amount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              );
            },
          ),
        ),
      ],
    );
  }
}
