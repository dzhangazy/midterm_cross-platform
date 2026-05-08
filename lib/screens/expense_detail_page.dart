import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../repositories/trip_repository.dart';

class ExpenseDetailPage extends ConsumerWidget {
  final int expenseId;

  const ExpenseDetailPage({super.key, required this.expenseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackerState = ref.watch(tripRepositoryProvider);
    
    // Находим расход в общем списке состояния
    final expense = trackerState.currentExpenses.firstWhere(
      (e) => e.id == expenseId,
      orElse: () => Expense(title: 'Not Found', amount: 0),
    );

    // Находим связанную поездку
    final trip = trackerState.trips.firstWhere(
      (t) => t.id == expense.tripId,
      orElse: () => Trip(title: 'Unknown Trip', destination: '', budget: 0),
    );

    final colorScheme = Theme.of(context).colorScheme;

    if (expense.title == 'Not Found') {
      return Scaffold(appBar: AppBar(), body: const Center(child: Text('Transaction not found')));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => _confirmDelete(context, ref, expense),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAmountHeader(context, expense),
            const SizedBox(height: 32),
            _buildInfoSection(context, 'Description', expense.title, Icons.description_outlined),
            _buildInfoSection(context, 'Category', expense.category, _getCategoryIcon(expense.category)),
            _buildInfoSection(context, 'Date', 
                expense.date != null ? DateFormat('MMMM dd, yyyy').format(expense.date!) : 'N/A', 
                Icons.calendar_today_outlined),
            _buildInfoSection(context, 'Related Trip', trip.title, Icons.map_outlined, isLink: true, onTap: () {
              Navigator.pop(context); // Назад к истории или поездке
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountHeader(BuildContext context, Expense expense) {
    return Center(
      child: Column(
        children: [
          const Text('Total Amount', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          Text(
            '-\$${expense.amount.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.redAccent),
          ),
          const SizedBox(height: 12),
          Chip(
            label: Text(expense.category),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, String label, String value, IconData icon, {bool isLink = false, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(value, style: TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.bold,
                  color: isLink ? Theme.of(context).colorScheme.primary : null,
                  decoration: isLink ? TextDecoration.underline : null,
                )),
              ],
            ),
          ],
        ),
      ),
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

  void _confirmDelete(BuildContext context, WidgetRef ref, Expense expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transaction?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              ref.read(tripRepositoryProvider.notifier).deleteExpense(expense);
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // go back
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
