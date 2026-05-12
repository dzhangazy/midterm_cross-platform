import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'constants.dart';
import 'models/models.dart';
import 'models/settings_manager.dart';
import 'screens/screens.dart';
import 'screens/chat_inbox_page.dart';
import 'repositories/trip_repository.dart';

class Home extends ConsumerStatefulWidget {
  const Home({
    super.key,
    required this.auth,
    required this.cartManager,
    required this.ordersManager,
    required this.settingsManager,
    required this.changeTheme,
    required this.changeColor,
    required this.colorSelected,
    required this.tab,
  });

  final YummyAuth auth;
  final int tab;
  final CartManager cartManager;
  final OrderManager ordersManager;
  final SettingsManager settingsManager;
  final ColorSelection colorSelected;
  final void Function(bool useLightMode) changeTheme;
  final void Function(int value) changeColor;

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
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
      icon: Icon(Icons.chat_outlined),
      label: 'Chat',
      selectedIcon: Icon(Icons.chat_rounded),
    ),
    NavigationDestination(
      icon: Icon(Icons.account_circle_outlined),
      label: 'Profile',
      selectedIcon: Icon(Icons.account_circle_rounded),
    )
  ];

  @override
  Widget build(BuildContext context) {
    // 1. Наблюдаем за состоянием
    // ignore: unused_local_variable
    final trackerState = ref.watch(tripRepositoryProvider);

    // 2. Страницы
    final pages = [
      ExplorePage(
        cartManager: widget.cartManager,
        orderManager: widget.ordersManager,
        settingsManager: widget.settingsManager,
      ),
      MyOrdersPage(
        orderManager: widget.ordersManager,
        settingsManager: widget.settingsManager,
      ),
      const ChatInboxPage(), // Сменили на список контактов
      AccountPage(
        settingsManager: widget.settingsManager,
        onLogOut: (logout) async {
          await widget.auth.signOut();
          if (mounted) {
            context.go('/login');
          }
        },
        user: User(
          firstName: widget.auth.currentUser?.email?.split('@')[0] ?? 'User',
          lastName: '',
          role: 'Finance Planner',
          profileImageUrl: '',
          points: 100,
          darkMode: Theme.of(context).brightness == Brightness.dark,
        ),
      ),
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
