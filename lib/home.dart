import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'constants.dart';
import '../components/components.dart';
import '../models/models.dart';
import '../models/settings_manager.dart';
import '../screens/screens.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.auth,
    required this.cartManager,
    required this.ordersManager,
    required this.settingsManager, // Добавили
    required this.changeTheme,
    required this.changeColor,
    required this.colorSelected,
    required this.tab,
  });

  final YummyAuth auth;
  final int tab;
  final CartManager cartManager;
  final OrderManager ordersManager;
  final SettingsManager settingsManager; // Добавили
  final ColorSelection colorSelected;
  final void Function(bool useLightMode) changeTheme;
  final void Function(int value) changeColor;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<NavigationDestination> appBarDestinations = const [
    NavigationDestination(
      icon: Icon(Icons.grid_view_outlined),
      label: 'Explore',
      selectedIcon: Icon(Icons.grid_view_rounded),
    ),
    NavigationDestination(
      icon: Icon(Icons.receipt_long_outlined),
      label: 'History',
      selectedIcon: Icon(Icons.receipt_long_rounded),
    ),
    NavigationDestination(
      icon: Icon(Icons.account_circle_outlined),
      label: 'Profile',
      selectedIcon: Icon(Icons.account_circle_rounded),
    )
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      ExplorePage(
        cartManager: widget.cartManager,
        orderManager: widget.ordersManager,
        settingsManager: widget.settingsManager, // Пробросили
      ),
      MyOrdersPage(orderManager: widget.ordersManager),
      AccountPage(
          settingsManager: widget.settingsManager, // Пробросили
          onLogOut: (logout) async {
            widget.auth.signOut().then((value) => context.go('/login'));
          },
          user: User(
              firstName: 'Stef',
              lastName: 'P',
              role: 'Finance Planner',
              profileImageUrl: '',
              points: 100,
              darkMode: true))
    ];

    return Scaffold(
      body: IndexedStack(index: widget.tab, children: pages),
      bottomNavigationBar: NavigationBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        indicatorColor: Theme.of(context).colorScheme.primaryContainer,
        selectedIndex: widget.tab,
        onDestinationSelected: (index) {
          context.go('/$index');
        },
        destinations: appBarDestinations,
      ),
    );
  }
}
