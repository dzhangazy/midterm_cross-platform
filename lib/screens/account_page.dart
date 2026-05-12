import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/models.dart';
import '../models/settings_manager.dart';
import '../repositories/trip_repository.dart';

typedef LogoutCallback = void Function(bool didLogout);

class AccountPage extends ConsumerStatefulWidget {
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
  ConsumerState<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends ConsumerState<AccountPage> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final trackerState = ref.watch(tripRepositoryProvider);
    
    final totalTrips = trackerState.trips.length;
    final totalPlannedUsd = trackerState.trips.fold(0.0, (sum, t) => sum + t.budget);
    final totalSpentUsd = trackerState.currentSpending;

    return ListenableBuilder(
      listenable: widget.settingsManager,
      builder: (context, child) {
        final symbol = widget.settingsManager.currencySymbol;
        final totalPlanned = widget.settingsManager.convert(totalPlannedUsd);
        final totalSpent = widget.settingsManager.convert(totalSpentUsd);
        final breakdown = trackerState.categorySpending;

        return Scaffold(
          backgroundColor: colorScheme.surface,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 180,
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
                      _buildSectionTitle('Financial Overview'),
                      _buildStatsGrid(totalTrips, totalPlanned, totalSpent, symbol),
                      
                      if (breakdown.isNotEmpty) ...[
                        const SizedBox(height: 32),
                        _buildSectionTitle('Spending by Category'),
                        _buildCategoryChart(context, breakdown, totalSpentUsd),
                      ],
                      
                      const SizedBox(height: 32),
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
                          onTap: () async {
                            await launchUrl(Uri.parse('https://flutter.dev'));
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.logout_rounded, color: colorScheme.error),
                          title: Text('Log out', style: TextStyle(color: colorScheme.error)),
                          onTap: () => widget.onLogOut(true),
                        ),
                      ]),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryChart(BuildContext context, Map<String, double> breakdown, double totalUsd) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: breakdown.entries.map((entry) {
          final percentage = totalUsd > 0 ? entry.value / totalUsd : 0.0;
          final convertedAmount = widget.settingsManager.convert(entry.value);
          final symbol = widget.settingsManager.currencySymbol;
          
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w500)),
                    Text('$symbol${convertedAmount.toInt()} (${(percentage * 100).toInt()}%)', 
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: percentage,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                  backgroundColor: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatsGrid(int trips, double budget, double spent, String symbol) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildStatCard('Trips', trips.toString(), Icons.explore_outlined, Colors.blue)),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard('Spent', '$symbol${spent.toInt()}', Icons.payments_outlined, Colors.orange)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildStatCard('Planned', '$symbol${budget.toInt()}', Icons.account_balance_wallet_outlined, Colors.green)),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard('Remaining', '$symbol${(budget - spent).toInt()}', Icons.savings_outlined, Colors.purple)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
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
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 11)),
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
    final symbol = widget.settingsManager.currencySymbol;
    final convertedLimit = widget.settingsManager.convert(widget.settingsManager.budgetLimit);

    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.speed_rounded),
          title: const Text('Monthly Limit', style: TextStyle(fontWeight: FontWeight.w500)),
          trailing: Text('$symbol${convertedLimit.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Slider(
          value: widget.settingsManager.budgetLimit,
          min: 1000,
          max: 10000,
          divisions: 18,
          onChanged: (val) => widget.settingsManager.setBudgetLimit(val),
        ),
      ],
    );
  }

  Widget buildProfile() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          const CircleAvatar(
            radius: 35.0,
            backgroundColor: Colors.white,
            child: Icon(Icons.person_rounded, size: 40, color: Colors.blueGrey),
          ),
          const SizedBox(height: 8.0),
          Text(
            widget.user.firstName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(widget.user.role, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        ],
      ),
    );
  }
}
