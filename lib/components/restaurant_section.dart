import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../components/components.dart';
import '../models/models.dart';
import '../constants.dart';

class RestaurantSection extends StatelessWidget {
  final List<Restaurant> restaurants;
  final CartManager cartManager;
  final OrderManager orderManager;

  const RestaurantSection(
      {super.key,
      required this.restaurants,
      required this.cartManager,
      required this.orderManager});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: Text(
              'Planned Trips',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            // Увеличили высоту с 230 до 260, чтобы новый дизайн поместился
            height: 260,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: restaurants.length,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemBuilder: (context, index) {
                return SizedBox(
                    width: 300,
                    child: RestaurantLandscapeCard(
                      restaurant: restaurants[index],
                      onTap: () {
                        context.go('/${FinanceTripTab.dashboard.value}/trip/${restaurants[index].id}');
                      },
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
