import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api.dart';

const kCartKey = 'gkm_cart';

class CartProvider extends ChangeNotifier {
  final Map<int, Map<String, dynamic>> _cart = {};

  CartProvider() { _hydrate(); }

  int    get count => _cart.values.fold(0, (s, e) => s + asInt(e['qty']));
  double get total => _cart.values.fold(0.0, (s, e) => s + asDouble(asMap(e['product'])['price']) * asInt(e['qty']));
  List<Map<String, dynamic>> get items => _cart.values.toList();
  Map<int, Map<String, dynamic>> get rawCart => Map.unmodifiable(_cart);

  int qty(int id) => asInt(_cart[id]?['qty']);

  // Restore the cart persisted by _persist(). Corrupt/absent JSON fails
  // silently to an empty cart.
  Future<void> _hydrate() async {
    try {
      final raw = (await SharedPreferences.getInstance()).getString(kCartKey);
      if (raw == null || raw.isEmpty) return;
      final decoded = jsonDecode(raw);
      if (decoded is! List) return;
      for (final e in decoded) {
        final entry = asMap(e);
        final product = asMap(entry['product']);
        final id = asInt(product['id']);
        final q = asInt(entry['qty']);
        if (id == 0 || q <= 0) continue;
        _cart[id] = {...entry, 'product': product, 'qty': q};
      }
      if (_cart.isNotEmpty) notifyListeners();
    } catch (_) {/* corrupt stored cart → start empty */}
  }

  // Persist the full line items (whole product map + qty) as JSON on every
  // mutation, so the cart survives an app restart. Fire-and-forget: failures
  // never surface to the UI.
  void _persist() {
    SharedPreferences.getInstance().then((p) async {
      if (_cart.isEmpty) {
        await p.remove(kCartKey);
      } else {
        await p.setString(kCartKey, jsonEncode(_cart.values.toList()));
      }
    }).catchError((_) {});
  }

  void add(Map<String, dynamic> product) {
    final id = asInt(product['id']);
    if (_cart.containsKey(id)) {
      _cart[id]!['qty'] = asInt(_cart[id]!['qty']) + 1;
    } else {
      _cart[id] = {'product': product, 'qty': 1};
    }
    _persist();
    notifyListeners();
  }

  void remove(int id) {
    if (!_cart.containsKey(id)) return;
    final q = asInt(_cart[id]!['qty']) - 1;
    if (q <= 0) { _cart.remove(id); } else { _cart[id]!['qty'] = q; }
    _persist();
    notifyListeners();
  }

  // Delete a whole line regardless of its quantity.
  void removeLine(int id) {
    if (_cart.remove(id) == null) return;
    _persist();
    notifyListeners();
  }

  // Set an exact quantity for a line (<= 0 removes it).
  void setQty(int id, int q) {
    if (!_cart.containsKey(id)) return;
    if (q <= 0) { _cart.remove(id); } else { _cart[id]!['qty'] = q; }
    _persist();
    notifyListeners();
  }

  void clear() { _cart.clear(); _persist(); notifyListeners(); }
}
