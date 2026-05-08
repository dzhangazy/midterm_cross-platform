import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../models/settings_manager.dart';
import '../repositories/trip_repository.dart';

class MyOrdersPage extends ConsumerWidget {
  final OrderManager orderManager;
  final SettingsManager settingsManager; // Добавлен менеджер настроек

  const MyOrdersPage({
    super.key, 
    required this.orderManager,
    required this.settingsManager,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackerState = ref.watch(tripRepositoryProvider);
    
    // 1. Расходы из SQLite
    final sqliteExpenses = trackerState.currentExpenses.map((e) {
      final trip = trackerState.trips.firstWhere(
        (t) => t.id == e.tripId,
        orElse: () => Trip(title: 'General', destination: '', budget: 0),
      );
      return _UnifiedTransaction(
        id: 'exp_${e.id}',
        title: e.title,
        subtitle: trip.title,
        amount: e.amount,
        date: e.date ?? DateTime.now(),
        type: TransactionType.expense,
        originalId: e.id ?? 0,
      );
    }).toList();

    // 2. Заказы из приложения
    final foodOrders = <_UnifiedTransaction>[];
    for (int i = 0; i < orderManager.orders.length; i++) {
      final order = orderManager.orders[i];
      foodOrders.add(_UnifiedTransaction(
        id: 'order_$i',
        title: order.getFormattedSegment(),
        subtitle: 'Activity Purchase',
        amount: order.totalCost,
        date: order.selectedDate ?? DateTime.now(), 
        type: TransactionType.order,
        originalId: i,
      ));
    }

    final allTransactions = [...sqliteExpenses, ...foodOrders];
    allTransactions.sort((a, b) => b.date.compareTo(a.date));

    final colorScheme = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: settingsManager,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            title: const Text('Transaction History', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          body: allTransactions.isEmpty
            ? _buildEmptyState(context)
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: allTransactions.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final tx = allTransactions[index];
                  return _buildTransactionTile(context, tx);
                },
              ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_outlined, size: 80, color: Theme.of(context).colorScheme.outlineVariant),
          const SizedBox(height: 16),
          const Text('No transactions found', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildTransactionTile(BuildContext context, _UnifiedTransaction tx) {
    final colorScheme = Theme.of(context).colorScheme;
    final isOrder = tx.type == TransactionType.order;
    
    // Конвертация суммы
    final convertedAmount = settingsManager.convert(tx.amount);
    final symbol = settingsManager.currencySymbol;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      child: ListTile(
        onTap: () {
          if (isOrder) {
            context.push('/order-details/${tx.originalId}');
          } else {
            context.push('/expense-details/${tx.originalId}');
          }
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: isOrder ? Colors.teal.withOpacity(0.1) : colorScheme.primaryContainer,
          child: Icon(
            isOrder ? Icons.confirmation_number_outlined : Icons.receipt_long, 
            color: isOrder ? Colors.teal : colorScheme.primary, 
            size: 20
          ),
        ),
        title: Text(tx.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tx.subtitle, style: TextStyle(fontSize: 12, color: colorScheme.primary)),
            Text(DateFormat('MMM dd, hh:mm a').format(tx.date), 
                style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '-$symbol${convertedAmount.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 16,
                color: isOrder ? Colors.teal : Colors.redAccent,
              ),
            ),
            const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

enum TransactionType { expense, order }

class _UnifiedTransaction {
  final String id;
  final String title;
  final String subtitle;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final int originalId;

  _UnifiedTransaction({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.type,
    required this.originalId,
  });
}
