import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager extends ChangeNotifier {
  static const String _keyTabIndex = 'tab_index';
  static const String _keySearchHistory = 'search_history';
  static const String _keyCurrency = 'default_currency';

  final SharedPreferences _prefs;

  // Фиксированные курсы валют относительно USD
  final Map<String, double> _rates = {
    'USD': 1.0,
    'EUR': 0.92,
    'KZT': 450.0,
    'GBP': 0.79,
  };

  // Символы валют (экранируем $)
  final Map<String, String> _symbols = {
    'USD': '\$',
    'EUR': '€',
    'KZT': '₸',
    'GBP': '£',
  };

  SettingsManager(this._prefs) {
    _tabIndex = _prefs.getInt(_keyTabIndex) ?? 0;
    _searchHistory = _prefs.getStringList(_keySearchHistory) ?? [];
    _defaultCurrency = _prefs.getString(_keyCurrency) ?? 'USD';
  }

  // --- Конвертация ---
  double convert(double usdAmount) {
    final rate = _rates[_defaultCurrency] ?? 1.0;
    return usdAmount * rate;
  }

  String get currencySymbol => _symbols[_defaultCurrency] ?? '\$';

  // --- Tab Index ---
  int _tabIndex = 0;
  int get tabIndex => _tabIndex;

  void setTabIndex(int index) {
    if (_tabIndex == index) return;
    _tabIndex = index;
    _prefs.setInt(_keyTabIndex, index);
    notifyListeners();
  }

  // --- Search History ---
  List<String> _searchHistory = [];
  List<String> get searchHistory => List.unmodifiable(_searchHistory);

  void addSearchTerm(String term) {
    final cleanTerm = term.trim();
    if (cleanTerm.isEmpty) return;
    _searchHistory.removeWhere((t) => t.toLowerCase() == cleanTerm.toLowerCase());
    _searchHistory.insert(0, cleanTerm);
    if (_searchHistory.length > 10) _searchHistory = _searchHistory.sublist(0, 10);
    _prefs.setStringList(_keySearchHistory, _searchHistory);
    notifyListeners();
  }

  // --- Default Currency ---
  String _defaultCurrency = 'USD';
  String get defaultCurrency => _defaultCurrency;

  void setDefaultCurrency(String currency) {
    if (_defaultCurrency == currency) return;
    _defaultCurrency = currency;
    _prefs.setString(_keyCurrency, currency);
    notifyListeners();
  }
}
