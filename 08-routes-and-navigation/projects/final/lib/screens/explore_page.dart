import 'package:flutter/material.dart';
import '../api/mock_yummy_service.dart';
import '../components/components.dart';
import '../models/models.dart';

class ExplorePage extends StatelessWidget {
  final mockService = MockYummyService();
  final CartManager cartManager;
  final OrderManager orderManager;

  ExplorePage({
    super.key,
    required this.cartManager, 
    required this.orderManager});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: mockService.getExploreData(),
        builder: (context, AsyncSnapshot<ExploreData> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final restaurants = snapshot.data?.restaurants ?? [];
            final categories = snapshot.data?.categories ?? [];
            final posts = snapshot.data?.friendPosts ?? [];
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  title: const Text('Explore', style: TextStyle(fontWeight: FontWeight.bold)),
                  actions: [
                    IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
                  ],
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Text('Top Destinations', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    RestaurantSection(
                      restaurants: restaurants,
                      cartManager: cartManager,
                      orderManager: orderManager,
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Text('Trip Updates', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    PostSection(posts: posts),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Text('Plan by Category', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    CategorySection(categories: categories),
                    const SizedBox(height: 20),
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
}