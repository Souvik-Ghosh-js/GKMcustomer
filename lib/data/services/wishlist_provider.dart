import 'package:flutter/foundation.dart';
import 'api.dart';

// Holds the set of wishlisted product ids (for the ♥ toggles) plus the full
// wishlist rows (for the wishlist screen). Loaded once after login/app start;
// silently skips when logged out. Toggles are optimistic and revert on API
// failure — nothing here ever throws to the UI.
class WishlistProvider extends ChangeNotifier {
  final _api = Api();
  final Set<int> _ids = {};
  List<Map<String, dynamic>> _items = [];
  bool _loading = false;
  bool _loaded = false;

  Set<int> get ids => Set.unmodifiable(_ids);
  List<Map<String, dynamic>> get items => List.unmodifiable(_items);
  bool get loading => _loading;
  bool get loaded => _loaded;
  bool contains(int productId) => _ids.contains(productId);

  Future<void> load() async {
    final t = await _api.token();
    if (t == null || t.isEmpty) return; // logged out — skip silently
    _loading = true;
    notifyListeners();
    try {
      final res = await _api.getWishlist();
      final rows = asList(res).map((e) => asMap(e)).toList();
      _ids
        ..clear()
        ..addAll(rows.map((e) => asInt(e['product_id'])).where((id) => id != 0));
      _items = rows;
      _loaded = true;
    } catch (_) {/* keep whatever we had */}
    _loading = false;
    notifyListeners();
  }

  // Optimistic toggle. Returns whether the product is wishlisted afterwards.
  // Pass the product map (when available) so the wishlist screen can show the
  // row without a refetch.
  Future<bool> toggle(int productId, {Map<String, dynamic>? product}) async {
    if (productId == 0) return false;
    final wasIn = _ids.contains(productId);
    Map<String, dynamic>? removedRow;

    if (wasIn) {
      _ids.remove(productId);
      final idx = _items.indexWhere((e) => asInt(e['product_id']) == productId);
      if (idx != -1) removedRow = _items.removeAt(idx);
    } else {
      _ids.add(productId);
      if (product != null) _items.insert(0, {'product_id': productId, 'product': product});
    }
    notifyListeners();

    try {
      final res = await _api.toggleWishlist(productId);
      // Trust the server's 'added' flag if it disagrees with our optimism.
      final added = (res is Map && res['added'] != null) ? asBool(res['added']) : !wasIn;
      if (added != _ids.contains(productId)) {
        if (added) {
          _ids.add(productId);
          if (removedRow != null) _items.insert(0, removedRow);
        } else {
          _ids.remove(productId);
          _items.removeWhere((e) => asInt(e['product_id']) == productId);
        }
        notifyListeners();
      }
      return added;
    } catch (_) {
      // API failed — revert the optimistic change.
      if (wasIn) {
        _ids.add(productId);
        if (removedRow != null) _items.insert(0, removedRow);
      } else {
        _ids.remove(productId);
        _items.removeWhere((e) => asInt(e['product_id']) == productId);
      }
      notifyListeners();
      return wasIn;
    }
  }

  // Wipe local state (e.g. on logout).
  void reset() {
    _ids.clear();
    _items = [];
    _loaded = false;
    notifyListeners();
  }
}
