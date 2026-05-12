import 'package:flutter/material.dart';
import '../models/models.dart';

class TripCard extends StatelessWidget {
  final Trip trip;
  final double totalSpent;

  const TripCard({
    super.key,
    required this.trip,
    this.totalSpent = 0,
  });

  @override
  Widget build(BuildContext context) {
    final progress = trip.budget > 0 ? (totalSpent / trip.budget).clamp(0.0, 1.0) : 0.0;
    
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    trip.title, 
                    style: Theme.of(context).textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (trip.isCompleted)
                  const Icon(Icons.check_circle, color: Colors.green, size: 20),
              ],
            ),
            Text(
              trip.destination, 
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('\$${totalSpent.toStringAsFixed(0)} spent', style: const TextStyle(fontSize: 12)),
                Text('Budget: \$${trip.budget.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
