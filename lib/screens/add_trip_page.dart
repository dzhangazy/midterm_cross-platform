import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../repositories/trip_repository.dart';

class AddTripPage extends ConsumerStatefulWidget {
  final Trip? tripToEdit;

  const AddTripPage({super.key, this.tripToEdit});

  @override
  ConsumerState<AddTripPage> createState() => _AddTripPageState();
}

class _AddTripPageState extends ConsumerState<AddTripPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _destController;
  late TextEditingController _budgetController;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.tripToEdit?.title ?? '');
    _destController = TextEditingController(text: widget.tripToEdit?.destination ?? '');
    _budgetController = TextEditingController(text: widget.tripToEdit?.budget.toString() ?? '');
    _startDate = widget.tripToEdit?.startDate;
    _endDate = widget.tripToEdit?.endDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _destController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  void _saveTrip() {
    if (_formKey.currentState!.validate()) {
      final trip = (widget.tripToEdit ?? Trip(title: '', destination: '', budget: 0)).copyWith(
        title: _titleController.text,
        destination: _destController.text,
        budget: double.tryParse(_budgetController.text) ?? 0,
        startDate: _startDate,
        endDate: _endDate,
      );

      // Сохраняем в SQLite через наш репозиторий
      ref.read(tripRepositoryProvider.notifier).insertTrip(trip);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.tripToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Trip' : 'Plan New Trip'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Trip Title',
                  hintText: 'e.g. Summer Vacation 2024',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _destController,
                decoration: const InputDecoration(
                  labelText: 'Destination',
                  hintText: 'Where are you going?',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.map_outlined),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Please enter a destination' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _budgetController,
                decoration: const InputDecoration(
                  labelText: 'Total Budget',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (val) => double.tryParse(val ?? '') == null ? 'Enter a valid number' : null,
              ),
              const SizedBox(height: 24),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today_outlined),
                title: Text(_startDate == null 
                    ? 'Select Dates' 
                    : '${DateFormat('MMM d').format(_startDate!)} - ${DateFormat('MMM d, y').format(_endDate!)}'),
                subtitle: const Text('Trip duration'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _selectDateRange(context),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _saveTrip,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(isEditing ? 'Update Trip' : 'Create Trip', style: const TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
