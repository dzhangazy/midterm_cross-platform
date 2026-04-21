import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'constants.dart';
import 'screens/screens.dart';
import 'models/models.dart';
import 'home.dart';

void main() {
  usePathUrlStrategy();
  runApp(const FinanceTripApp());
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad
      };
}

class FinanceTripApp extends StatefulWidget {
  const FinanceTripApp({super.key});

  @override
  State<FinanceTripApp> createState() => _FinanceTripAppState();
}

class _FinanceTripAppState extends State<FinanceTripApp> {
  ThemeMode themeMode = ThemeMode.light;
  ColorSelection colorSelected = ColorSelection.indigo;

  final YummyAuth _auth = YummyAuth();
  final CartManager _cartManager = CartManager();
  final OrderManager _orderManager = OrderManager();

  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(
          path: '/login',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: LoginPage(
              onLogIn: (credentials) {
                _auth.signIn(credentials.username, credentials.password);
                context.go('/0');
              },
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: '/:tab',
          pageBuilder: (context, state) {
            final tabStr = state.pathParameters['tab'] ?? '0';
            final tab = int.tryParse(tabStr) ?? 0;
            return CustomTransitionPage(
              key: state.pageKey,
              child: Home(
                auth: _auth,
                cartManager: _cartManager,
                ordersManager: _orderManager,
                changeTheme: (bool val) {
                  setState(() => themeMode = val ? ThemeMode.light : ThemeMode.dark);
                },
                changeColor: (int val) {
                  setState(() => colorSelected = ColorSelection.values[val]);
                },
                colorSelected: colorSelected,
                tab: tab,
              ),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: animation.drive(
                    Tween<Offset>(
                      begin: const Offset(0, 0.1),
                      end: Offset.zero,
                    ).chain(CurveTween(curve: Curves.easeOutCubic)),
                  ),
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
            );
          },
          routes: [
            GoRoute(
              path: 'trip/:id',
              builder: (context, state) {
                final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
                return RestaurantPage(
                  restaurant: restaurants[id],
                  cartManager: _cartManager,
                  ordersManager: _orderManager,
                );
              },
            ),
            // НОВЫЙ МАРШРУТ ДЛЯ ДЕТАЛЕЙ ТРАНЗАКЦИИ
            GoRoute(
              path: 'order/:id',
              builder: (context, state) {
                final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
                final order = _orderManager.orders[id];
                return Scaffold(
                  appBar: AppBar(title: const Text('Transaction Details')),
                  body: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: order.items.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final item = order.items[index];
                      return ListTile(
                        leading: const Icon(Icons.check_circle_outline, color: Colors.green),
                        title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Quantity: ${item.quantity}'),
                        trailing: Text('\$${(item.price * item.quantity).toStringAsFixed(0)}', 
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      scrollBehavior: CustomScrollBehavior(),
      theme: ThemeData(
        colorSchemeSeed: colorSelected.color,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: colorSelected.color,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: themeMode,
    );
  }
}
