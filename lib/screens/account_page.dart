import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/models.dart';
import '../models/settings_manager.dart';
import '../models/trip.dart'; // Импортируем модель Trip

typedef LogoutCallback = void Function(bool didLogout);

class AccountPage extends StatefulWidget {
  final User user;
  final LogoutCallback onLogOut;
  final SettingsManager settingsManager;

  const AccountPage({
    super.key,
    required this.onLogOut,
    required this.user,
    required this.settingsManager,
  });

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  bool _notificationsEnabled = true;
  double _budgetLimit = 5000;

  // Функция для демонстрации JSON сериализации
  void _testJsonSerialization() {
    // 1. Представим, что мы получили это от сервера
    const rawJson = '''
    {
      "id": "trip_777",
      "destination": "Almaty, Kazakhstan",
      "startDate": "2025-05-20T10:00:00Z",
      "endDate": "2025-05-30T18:00:00Z",
      "totalBudget": 2500.0,
      "baseCurrency": "KZT"
    }
    ''';

    // 2. Декодируем строку в Map
    final Map<String, dynamic> data = jsonDecode(rawJson);

    // 3. ПРЕВРАЩАЕМ В ОБЪЕКТ (fromJson) - ЭТО ДОКАЗАТЕЛЬСТВО
    final testTrip = Trip.fromJson(data);

    // 4. ПРЕВРАЩАЕМ ОБРАТНО В JSON (toJson)
    final backToJson = jsonEncode(testTrip.toJson());

    // Показываем результат в диалоге
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('JSON Serialization Test'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Object created successfully:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('ID: ${testTrip.id}'),
            Text('Destination: ${testTrip.destination}'),
            Text('Date: ${testTrip.startDate.day}.${testTrip.startDate.month}.${testTrip.startDate.year}'),
            const Divider(),
            const Text('Back to JSON string:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(backToJson, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cool!'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorScheme.primary, colorScheme.primaryContainer],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: buildProfile(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Developer Tools (Proof)'),
                  _buildSettingCard([
                    ListTile(
                      leading: const Icon(Icons.code_rounded, color: Colors.blue),
                      title: const Text('Test JSON Serialization'),
                      subtitle: const Text('Proof of auto-generated models'),
                      onTap: _testJsonSerialization,
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Finance Settings'),
                  _buildSettingCard([
                    _buildSwitchTile(
                      'Budget Notifications', 
                      'Get alerts when near limit', 
                      Icons.notifications_active_outlined, 
                      _notificationsEnabled,
                      (val) => setState(() => _notificationsEnabled = val),
                    ),
                    _buildCurrencyTile(),
                    _buildBudgetLimitTile(),
                  ]),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Support & Account'),
                  _buildSettingCard([
                    ListTile(
                      leading: const Icon(Icons.help_outline_rounded),
                      title: const Text('Travel Support'),
                      trailing: const Icon(Icons.open_in_new_rounded, size: 18),
                      onTap: () async {
                        await launchUrl(Uri.parse('https://jangazy-portfolio.netlify.app/'));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.logout_rounded, color: colorScheme.error),
                      title: Text('Log out', style: TextStyle(color: colorScheme.error)),
                      onTap: () => widget.onLogOut(true),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildSettingCard(List<Widget> children) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, IconData icon, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      secondary: Icon(icon),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildCurrencyTile() {
    return ListTile(
      leading: const Icon(Icons.payments_outlined),
      title: const Text('Primary Currency', style: TextStyle(fontWeight: FontWeight.w500)),
      trailing: DropdownButton<String>(
        value: widget.settingsManager.defaultCurrency,
        underline: const SizedBox(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            widget.settingsManager.setDefaultCurrency(newValue);
            setState(() {});
          }
        },
        items: <String>['USD', 'EUR', 'KZT', 'GBP']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBudgetLimitTile() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.speed_rounded),
          title: const Text('Monthly Limit', style: TextStyle(fontWeight: FontWeight.w500)),
          trailing: Text('\$${_budgetLimit.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Slider(
          value: _budgetLimit,
          min: 1000,
          max: 10000,
          divisions: 18,
          onChanged: (val) => setState(() => _budgetLimit = val),
        ),
      ],
    );
  }

  Widget buildProfile() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
            ),
            child: const CircleAvatar(
              radius: 45.0,
              backgroundColor: Colors.white,
              child: Icon(Icons.person_rounded, size: 50, color: Colors.blueGrey),
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            '${widget.user.firstName} ${widget.user.lastName}',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(widget.user.role, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
