import 'package:flutter/material.dart';

class ExpenseTile extends StatelessWidget {
  final String title;
  final double amount;
  final bool isPaid;
  final ValueChanged<bool?>? onChanged;

  const ExpenseTile({
    super.key,
    required this.title,
    required this.amount,
    this.isPaid = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = isPaid 
        ? const TextStyle(decoration: TextDecoration.lineThrough)
        : null;

    return ListTile(
      title: Text(title, style: textStyle),
      subtitle: Text('\$${amount.toStringAsFixed(2)}', style: textStyle),
      trailing: Checkbox(
        value: isPaid,
        onChanged: onChanged,
      ),
    );
  }
}
