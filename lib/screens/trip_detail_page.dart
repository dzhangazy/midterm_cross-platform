import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../repositories/trip_repository.dart';
import 'add_trip_page.dart';

class TripDetailPage extends ConsumerWidget {
  final int tripId;

  const TripDetailPage({super.key, required this.tripId});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackerState = ref.watch(tripRepositoryProvider);
    
    final trip = trackerState.trips.firstWhere(
      (t) => t.id == tripId,
      orElse: () => Trip(title: 'Not Found', destination: '', budget: 0),
    );

    final expenses = trackerState.currentExpenses.where((e) => e.tripId == tripId).toList();
    expenses.sort((a, b) => (b.date ?? DateTime.now()).compareTo(a.date ?? DateTime.now()));

    return Scaffold(
      appBar: AppBar(
        title: Text(trip.title),
        actions: [
          IconButton(
            icon: Icon(
              trip.isCompleted ? Icons.check_circle : Icons.check_circle_outline,
              color: trip.isCompleted ? Colors.green : null,
            ),
            onPressed: () => ref.read(tripRepositoryProvider.notifier).toggleTripCompletion(trip),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddTripPage(tripToEdit: trip))),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => _showDeleteConfirm(context, ref, trip),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTripHeader(context, trip, expenses),
          const Divider(height: 1),
          Expanded(
            child: expenses.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemCount: expenses.length,
                    separatorBuilder: (context, index) => const Divider(indent: 70),
                    itemBuilder: (context, index) {
                      final expense = expenses[index];
                      return Dismissible(
                        key: ValueKey(expense.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) => ref.read(tripRepositoryProvider.notifier).deleteExpense(expense),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                            child: Icon(_getCategoryIcon(expense.category), color: Theme.of(context).colorScheme.primary, size: 20),
                          ),
                          title: Text(expense.title, style: const TextStyle(fontWeight: FontWeight.w500)),
                          subtitle: Text(
                            '${expense.category}${expense.date != null ? " • " + DateFormat('MMM d').format(expense.date!) : ""}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: Text('\$${expense.amount.toStringAsFixed(2)}', 
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: trip.isCompleted ? null : FloatingActionButton.extended(
        onPressed: () => _showAddExpenseDialog(context, ref, tripId),
        label: const Text('Add Expense'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.money_off, size: 64, color: Colors.grey.withOpacity(0.5)),
          const SizedBox(height: 16),
          const Text('No expenses recorded for this trip.', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildTripHeader(BuildContext context, Trip trip, List<Expense> expenses) {
    final totalSpent = expenses.fold(0.0, (sum, e) => sum + e.amount);
    final remaining = trip.budget - totalSpent;
    final progress = trip.budget > 0 ? (totalSpent / trip.budget).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(24.0),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(trip.destination, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    if (trip.startDate != null)
                      Text('${DateFormat('MMM d').format(trip.startDate!)} - ${trip.endDate != null ? DateFormat('MMM d, y').format(trip.endDate!) : ""}', 
                        style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('\$${totalSpent.toStringAsFixed(0)}', 
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: remaining < 0 ? Colors.red : null)),
                  Text('Spent of \$${trip.budget.toInt()}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context, WidgetRef ref, Trip trip) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Trip?'),
        content: Text('Are you sure you want to delete "${trip.title}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              ref.read(tripRepositoryProvider.notifier).deleteTrip(trip);
              Navigator.pop(context); 
              context.pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAddExpenseDialog(BuildContext context, WidgetRef ref, int tripId) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    String selectedCategory = 'Other';
    final categories = ['Food', 'Transport', 'Housing', 'Entertainment', 'Shopping', 'Other'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('New Expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Expense name')),
              TextField(controller: amountController, decoration: const InputDecoration(labelText: 'Amount'), keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) => setState(() => selectedCategory = val!),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text) ?? 0;
                if (titleController.text.isNotEmpty && amount > 0) {
                  ref.read(tripRepositoryProvider.notifier).insertExpense(
                    Expense(
                      tripId: tripId,
                      title: titleController.text,
                      amount: amount,
                      category: selectedCategory,
                      date: DateTime.now(),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
