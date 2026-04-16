import 'package:flutter/material.dart';
import '../api/mock_yummy_service.dart';
import '../components/components.dart';
import '../models/models.dart';

class ExplorePage extends StatefulWidget {
  final CartManager cartManager;
  final OrderManager orderManager;

  const ExplorePage({
    super.key,
    required this.cartManager, 
    required this.orderManager});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final mockService = MockYummyService();
  late Future<ExploreData> _exploreDataFuture;

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
            final restaurants = snapshot.data?.restaurants ?? [];
            final categories = snapshot.data?.categories ?? [];
            final posts = snapshot.data?.friendPosts ?? [];
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  expandedHeight: 70,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text('Trip Dashboard', 
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      )),
                    centerTitle: false,
                    titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    _buildBudgetSummaryCard(context),
                    _buildCategoryBreakdown(context),
                    
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 32, 20, 8),
                      child: Text('Curated Destinations', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                    ),
                    RestaurantSection(
                      restaurants: restaurants,
                      cartManager: widget.cartManager,
                      orderManager: widget.orderManager,
                    ),
                    
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

  Widget _buildBudgetSummaryCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return ListenableBuilder(
      listenable: widget.cartManager,
      builder: (context, child) {
        const double totalBudget = 3000.0; 
        final double currentSpent = 1250.0 + widget.cartManager.totalCost;
        final double progress = (currentSpent / totalBudget).clamp(0.0, 1.0);

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
              // Анимация текста суммы
              TweenAnimationBuilder<double>(
                key: ValueKey(currentSpent), // Ключ заставляет анимацию играть при каждом изменении
                tween: Tween<double>(begin: 0, end: currentSpent),
                duration: const Duration(milliseconds: 1500),
                builder: (context, value, child) {
                  return Text('\$${value.toStringAsFixed(0)}', 
                    style: textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold));
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Budget Progress', style: textTheme.labelMedium?.copyWith(color: Colors.white70)),
                  // Анимация текста процентов
                  TweenAnimationBuilder<double>(
                    key: ValueKey(progress),
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
              // Анимация полоски прогресса
              TweenAnimationBuilder<double>(
                key: ValueKey(progress),
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
      {'icon': Icons.flight, 'label': 'Flights', 'amount': '\$850'},
      {'icon': Icons.hotel, 'label': 'Hotels', 'amount': '\$1,200'},
      {'icon': Icons.restaurant, 'label': 'Food', 'amount': '\$400'},
      {'icon': Icons.local_activity, 'label': 'Events', 'amount': '\$350'},
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
                            const SizedBox(height: 6),
                            Text(cat['label'] as String, style: const TextStyle(fontSize: 12)),
                            Text(cat['amount'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
