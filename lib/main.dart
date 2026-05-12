import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'constants.dart';
import 'screens/screens.dart';
import 'models/models.dart';
import 'models/settings_manager.dart';
import 'repositories/trip_repository.dart';
import 'repositories/db_repository.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final prefs = await SharedPreferences.getInstance();
  usePathUrlStrategy();
  
  runApp(
    ProviderScope(
      overrides: [
        tripRepositoryProvider.overrideWith(() => DBRepository() as TripRepository),
      ],
      child: FinanceTripApp(prefs: prefs),
    ),
  );
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad
      };
}

class FinanceTripApp extends ConsumerStatefulWidget {
  final SharedPreferences prefs;
  const FinanceTripApp({super.key, required this.prefs});

  @override
  ConsumerState<FinanceTripApp> createState() => _FinanceTripAppState();
}

class _FinanceTripAppState extends ConsumerState<FinanceTripApp> {
  ThemeMode themeMode = ThemeMode.light;
  ColorSelection colorSelected = ColorSelection.indigo;

  final YummyAuth _auth = YummyAuth();
  final CartManager _cartManager = CartManager();
  final OrderManager _orderManager = OrderManager();
  late final SettingsManager _settingsManager;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _settingsManager = SettingsManager(widget.prefs);

    _router = GoRouter(
      initialLocation: '/0',
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => LoginPage(
            onLogIn: (credentials) async {
              final errorMessage = await _auth.signIn(credentials.username, credentials.password);
              if (errorMessage == null) {
                if (mounted) context.go('/${_settingsManager.tabIndex}');
              } else {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
                  );
                }
              }
            },
            onRegister: (credentials) async {
              final errorMessage = await _auth.register(credentials.username, credentials.password);
              if (errorMessage == null) {
                if (mounted) context.go('/${_settingsManager.tabIndex}');
              } else {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
                  );
                }
              }
            },
          ),
        ),
        GoRoute(
          path: '/trip/:id',
          builder: (context, state) {
            final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
            return RestaurantPage(
              restaurant: restaurants[id],
              cartManager: _cartManager,
              ordersManager: _orderManager,
            );
          },
        ),
        GoRoute(
          path: '/my-trip/:id',
          builder: (context, state) {
            final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
            return TripDetailPage(tripId: id);
          },
        ),
        GoRoute(
          path: '/expense/:id',
          builder: (context, state) {
            final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
            return ExpenseDetailPage(expenseId: id);
          },
        ),
        GoRoute(
          path: '/order/:id',
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
        GoRoute(
          path: '/add-trip',
          builder: (context, state) => const AddTripPage(),
        ),
        GoRoute(
          path: '/:tab',
          builder: (context, state) {
            final tabStr = state.pathParameters['tab'] ?? '0';
            final tab = int.tryParse(tabStr) ?? 0;
            Future.microtask(() => _settingsManager.setTabIndex(tab));
            return Home(
              auth: _auth,
              cartManager: _cartManager,
              ordersManager: _orderManager,
              settingsManager: _settingsManager,
              changeTheme: (val) => setState(() => themeMode = val ? ThemeMode.light : ThemeMode.dark),
              changeColor: (val) => setState(() => colorSelected = ColorSelection.values[val]),
              colorSelected: colorSelected,
              tab: tab,
            );
          },
        ),
      ],
      redirect: (context, state) async {
        final loggedIn = await _auth.loggedIn;
        if (!loggedIn && state.matchedLocation != '/login') return '/login';
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _settingsManager,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: _router,
          scrollBehavior: CustomScrollBehavior(),
          theme: ThemeData(colorSchemeSeed: colorSelected.color, useMaterial3: true),
          darkTheme: ThemeData(colorSchemeSeed: colorSelected.color, useMaterial3: true, brightness: Brightness.dark),
          themeMode: themeMode,
        );
      },
    );
  }
}
