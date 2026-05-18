import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../api/firebase_service.dart';
import '../components/components.dart';
import '../constants.dart';
import '../models/models.dart';
import 'checkout_page.dart';

class RestaurantPage extends ConsumerStatefulWidget {
  final Restaurant restaurant;
  final CartManager cartManager;
  final OrderManager ordersManager;

  const RestaurantPage({
    super.key,
    required this.restaurant,
    required this.cartManager,
    required this.ordersManager
  });

  @override
  ConsumerState<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends ConsumerState<RestaurantPage> with SingleTickerProviderStateMixin {
  static const double largeScreenPercentage = 0.9;
  static const double maxWidth = 1000;
  static const desktopThreshold = 700;
  static const double drawerWidth = 375.0;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  final TextEditingController _reviewController = TextEditingController();
  double _userRating = 5.0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  double _calculateConstrainedWidth(double screenWidth) {
    return (screenWidth > desktopThreshold
            ? screenWidth * largeScreenPercentage
            : screenWidth)
        .clamp(0.0, maxWidth);
  }

  int calculateColumnCount(double screenWidth) {
    return screenWidth > desktopThreshold ? 2 : 1;
  }

  void _submitReview() async {
    if (_reviewController.text.isEmpty) return;
    
    final firebaseService = ref.read(firebaseServiceProvider);
    await firebaseService.addReview(
      widget.restaurant.id, 
      _reviewController.text, 
      _userRating
    );
    
    _reviewController.clear();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final constrainedWidth = _calculateConstrainedWidth(screenWidth);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    
    final favorites = ref.watch(favoritesProvider).value ?? [];
    final isFavorite = favorites.contains(widget.restaurant.id);

    return Scaffold(
      key: scaffoldKey,
      endDrawer: _buildEndDrawer(),
      floatingActionButton: _buildFloatingActionButton(),
      body: Center(
        child: SizedBox(
          width: constrainedWidth,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                actions: [
                  IconButton(
                    icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, 
                      color: isFavorite ? Colors.red : Colors.white),
                    onPressed: () => ref.read(firebaseServiceProvider).toggleFavorite(widget.restaurant.id),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(widget.restaurant.name, 
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(widget.restaurant.imageUrl, fit: BoxFit.cover),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.black54, Colors.transparent],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.restaurant.address, style: textTheme.bodyMedium?.copyWith(color: colorScheme.outline)),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.star, size: 20, color: Colors.amber[700]),
                                    const SizedBox(width: 4),
                                    Text(widget.restaurant.rating.toString(), style: textTheme.titleMedium),
                                    const SizedBox(width: 16),
                                    Icon(Icons.location_on, size: 20, color: colorScheme.primary),
                                    const SizedBox(width: 4),
                                    Text('${widget.restaurant.distance} miles', style: textTheme.titleMedium),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text('About this trip', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(widget.restaurant.attributes, style: textTheme.bodyLarge),
                      const SizedBox(height: 32),
                      Text('Available Activities', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      _buildGridView(calculateColumnCount(screenWidth)),
                      const SizedBox(height: 32),
                      _buildReviewSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewSection() {
    final firebaseService = ref.watch(firebaseServiceProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Reviews', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        TextField(
          controller: _reviewController,
          decoration: InputDecoration(
            hintText: 'Share your experience...',
            suffixIcon: IconButton(
              icon: const Icon(Icons.send),
              onPressed: _submitReview,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        Row(
          children: [
            const Text('Rating: '),
            Slider(
              value: _userRating,
              min: 1,
              max: 5,
              divisions: 4,
              label: _userRating.toString(),
              onChanged: (val) => setState(() => _userRating = val),
            ),
          ],
        ),
        const SizedBox(height: 16),
        StreamBuilder<List<Review>>(
          stream: firebaseService.getReviews(widget.restaurant.id),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final reviews = snapshot.data!;
            if (reviews.isEmpty) return const Text('No reviews yet. Be the first!');
            
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Row(
                    children: [
                      Text(review.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      Text(' ${review.rating}', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  subtitle: Text(review.comment),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildGridView(int columns) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: columns == 2 ? 3.0 : 3.5,
        crossAxisCount: columns,
      ),
      itemBuilder: (context, index) {
        final item = widget.restaurant.items[index];
        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showBottomSheet(item),
          child: RestaurantItem(item: item),
        );
      },
      itemCount: widget.restaurant.items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  void _showBottomSheet(Item item) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: ItemDetails(
          item: item, 
          cartManager: widget.cartManager,
          quantityUpdated: () {
            setState(() {});
          },),
      ),
    );
  }

  Widget _buildEndDrawer() {
    return SizedBox(
      width: drawerWidth,
      child: Drawer(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(28), bottomLeft: Radius.circular(28))),
        child: CheckoutPage(
        cartManager: widget.cartManager,
        didUpdate: () {
          setState(() {});
        },
        onSubmit: (order) async {
          await ref.read(firebaseServiceProvider).saveOrder(order);
          widget.ordersManager.addOrder(order);
          if (mounted) {
            context.pop();
            context.go('/${FinanceTripTab.transactions.value}');
          }
        },
      )),
    );
  }

  Widget _buildFloatingActionButton() {
    if (widget.cartManager.isEmpty) return const SizedBox.shrink();
    
    return ScaleTransition(
      scale: _pulseAnimation,
      child: FloatingActionButton.extended(
        onPressed: () => scaffoldKey.currentState!.openEndDrawer(),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        icon: const Icon(Icons.wallet_travel),
        label: Text('Review Plan (${widget.cartManager.items.length})'),
      ),
    );
  }
}
