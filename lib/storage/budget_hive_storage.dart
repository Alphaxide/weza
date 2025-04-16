// lib/storage/budget_hive_storage.dart
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/budget.dart';
import 'budget_storage.dart';

class BudgetHiveStorage implements BudgetStorage {
  static const String _boxName = 'budgets';
  late Box<Map<dynamic, dynamic>> _box;
  int _idCounter = 0;

  @override
  Future<void> initialize() async {
    await Hive.initFlutter();
    _box = await Hive.openBox<Map<dynamic, dynamic>>(_boxName);
    
    // Get the next ID
    if (_box.isNotEmpty) {
      final maxId = _box.keys.cast<int>().reduce((curr, next) => curr > next ? curr : next);
      _idCounter = maxId + 1;
    }
  }

  @override
  Future<int> insertBudget(Budget budget) async {
    final id = budget.id ?? _idCounter++;
    final budgetWithId = budget.copyWith(id: id);
    await _box.put(id, budgetWithId.toMap());
    return id;
  }

  @override
  Future<List<Budget>> getAllBudgets() async {
    return _box.values.map((map) => Budget.fromMap(Map<String, dynamic>.from(map))).toList();
  }

  @override
  Future<Budget?> getBudget(int id) async {
    final map = _box.get(id);
    if (map != null) {
      return Budget.fromMap(Map<String, dynamic>.from(map));
    }
    return null;
  }

  @override
  Future<void> deleteBudget(int id) async {
    await _box.delete(id);
  }

  @override
  Future<void> updateBudget(Budget budget) async {
    if (budget.id != null) {
      await _box.put(budget.id, budget.toMap());
    }
  }

  @override
  Future<List<Budget>> getBudgetsByCategory(String category) async {
    return _box.values
        .where((map) => map['category'] == category)
        .map((map) => Budget.fromMap(Map<String, dynamic>.from(map)))
        .toList();
  }

  @override
  Future<List<Budget>> getBudgetsByMonth(int year, int month) async {
    return _box.values
        .where((map) => map['year'] == year && map['month'] == month)
        .map((map) => Budget.fromMap(Map<String, dynamic>.from(map)))
        .toList();
  }
  
  @override
  Future<double> getTotalBudgetForMonth(int year, int month) async {
    double total = 0.0;
    final budgets = await getBudgetsByMonth(year, month);
    for (var budget in budgets) {
      total += budget.amount;
    }
    return total;
  }

  @override
  Future<void> close() async {
    await _box.close();
  }
}