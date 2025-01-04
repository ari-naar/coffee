import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/coffee_shop.dart';

class CoffeeShopsProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<CoffeeShop> _shops = [];
  bool _isLoading = false;
  String? _error;

  List<CoffeeShop> get shops => _shops;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchCoffeeShops() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final snapshot = await _firestore.collection('coffee_shops').get();
      _shops = snapshot.docs
          .map((doc) => CoffeeShop.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCoffeeShop(CoffeeShop shop) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final docRef =
          await _firestore.collection('coffee_shops').add(shop.toMap());
      final newShop = shop.copyWith(id: docRef.id);
      _shops.add(newShop);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateCoffeeShop(CoffeeShop shop) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _firestore
          .collection('coffee_shops')
          .doc(shop.id)
          .update(shop.toMap());

      final index = _shops.indexWhere((s) => s.id == shop.id);
      if (index != -1) {
        _shops[index] = shop;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteCoffeeShop(String id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _firestore.collection('coffee_shops').doc(id).delete();
      _shops.removeWhere((shop) => shop.id == id);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
