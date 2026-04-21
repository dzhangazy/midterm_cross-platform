import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';

class CheckoutPage extends StatefulWidget {
  final CartManager cartManager;
  final Function() didUpdate;
  final Function(Order) onSubmit;

  const CheckoutPage(
      {super.key,
      required this.cartManager,
      required this.didUpdate,
      required this.onSubmit});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  Set<int> selectedSegment = {0};
  TimeOfDay? selectedTime;
  DateTime? selectedDate;
  final DateTime _firstDate = DateTime(DateTime.now().year - 2);
  final DateTime _lastDate = DateTime(DateTime.now().year + 1);
  final TextEditingController _nameController = TextEditingController();

  String formatDate(DateTime? dateTime) {
    if (dateTime == null) {
      return 'Select Date';
    }
    final formatter = DateFormat('MMM dd, yyyy');
    return formatter.format(dateTime);
  }

  String formatTimeOfDay(TimeOfDay? timeOfDay) {
    if (timeOfDay == null) {
      return 'Select Time';
    }
    final hour = timeOfDay.hour.toString().padLeft(2, '0');
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void onSegmentSelected(Set<int> segmentIndex) {
    setState(() {
      selectedSegment = segmentIndex;
    });
  }

  Widget _buildOrderSegmentedType() {
    return SizedBox(
      width: double.infinity,
      child: SegmentedButton(
        showSelectedIcon: false,
        segments: const [
          ButtonSegment(
              value: 0, label: Text('Business'), icon: Icon(Icons.business_center_rounded)),
          ButtonSegment(
              value: 1, label: Text('Personal'), icon: Icon(Icons.person_rounded)),
        ],
        selected: selectedSegment,
        onSelectionChanged: onSegmentSelected,
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Trip Reference Name',
        hintText: 'e.g., Summer Vacation 2024',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: const Icon(Icons.edit_note_rounded),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: _firstDate,
      lastDate: _lastDate,
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Widget _buildOrderSummary(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.cartManager.items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = widget.cartManager.itemAt(index);
        
        return Dismissible(
          key: Key(item.id),
          direction: DismissDirection.horizontal,
          background: _buildDismissBackground(Alignment.centerLeft, Icons.delete_sweep_rounded, colorScheme),
          secondaryBackground: _buildDismissBackground(Alignment.centerRight, Icons.delete_forever_rounded, colorScheme),
          onDismissed: (direction) {
            setState(() {
              widget.cartManager.removeItem(item.id);
            });
            widget.didUpdate();
            // SNACKBAR УБРАН
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: colorScheme.primary,
                  radius: 14,
                  child: Text(
                    '${item.quantity}',
                    style: TextStyle(color: colorScheme.onPrimary, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      Text('\$${item.price.toStringAsFixed(0)} / activity', style: textTheme.bodySmall),
                    ],
                  ),
                ),
                Text(
                  '\$${(item.price * item.quantity).toStringAsFixed(0)}',
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDismissBackground(Alignment alignment, IconData icon, ColorScheme colorScheme) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: colorScheme.error.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: Colors.white, size: 28),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: FilledButton(
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
        ),
        onPressed: widget.cartManager.isEmpty
            ? null
            : () {
                final order = Order(
                    selectedSegment: selectedSegment,
                    selectedTime: selectedTime,
                    selectedDate: selectedDate,
                    name: _nameController.text,
                    items: widget.cartManager.items);
                widget.cartManager.resetCart();
                widget.onSubmit(order);
              },
        child: Text(
          'Confirm Plan - \$${widget.cartManager.totalCost.toStringAsFixed(0)}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Review', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Planning Details', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20.0),
            _buildOrderSegmentedType(),
            const SizedBox(height: 20.0),
            _buildTextField(),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.calendar_today_rounded, size: 18),
                    label: Text(formatDate(selectedDate)),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.access_time_rounded, size: 18),
                    label: Text(formatTimeOfDay(selectedTime)),
                    onPressed: () => _selectTime(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Current Activities', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                Text('${widget.cartManager.items.length} items', style: textTheme.bodyMedium?.copyWith(color: colorScheme.outline)),
              ],
            ),
            const SizedBox(height: 16),
            _buildOrderSummary(context),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Estimated Cost', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                Text(
                  '\$${widget.cartManager.totalCost.toStringAsFixed(0)}',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }
}
