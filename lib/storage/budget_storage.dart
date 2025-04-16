// lib/storage/budget_storage.dart
import '../models/budget.dart';

abstract class BudgetStorage {
  Future<void> initialize();
  Future<int> insertBudget(Budget budget);
  Future<List<Budget>> getAllBudgets();
  Future<Budget?> getBudget(int id);
  Future<void> deleteBudget(int id);
  Future<void> updateBudget(Budget budget);
  Future<List<Budget>> getBudgetsByCategory(String category);
  Future<List<Budget>> getBudgetsByMonth(int year, int month);
  Future<double> getTotalBudgetForMonth(int year, int month);
  Future<void> close();
}