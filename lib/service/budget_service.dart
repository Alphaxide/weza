// lib/services/budget_service.dart
import 'package:intl/intl.dart';
import '../models/budget.dart';
import '../models/mpesa_message.dart';
import '../storage/budget_storage.dart';
import '../storage/budget_storage_provider.dart';
import '../storage/mpesa_storage.dart';
import '../storage/storage_provider.dart';

class BudgetService {
  late BudgetStorage _budgetStorage;
  late MessageStorage _messageStorage;
  
  BudgetService() {
    _budgetStorage = getBudgetStorageImplementation();
    _messageStorage = getStorageImplementation();
  }
  
  Future<void> initialize() async {
    await _budgetStorage.initialize();
    await _messageStorage.initialize();
  }
  
  // Get all budgets for current month
  Future<List<Budget>> getCurrentMonthBudgets() async {
    final now = DateTime.now();
    return await _budgetStorage.getBudgetsByMonth(now.year, now.month);
  }
  
  // Create a new budget for a category
  Future<int> createBudget(String category, double amount) async {
    final now = DateTime.now();
    final budget = Budget(
      category: category,
      amount: amount,
      year: now.year,
      month: now.month,
    );
    return await _budgetStorage.insertBudget(budget);
  }
  
  // Update an existing budget
  Future<void> updateBudget(Budget budget) async {
    await _budgetStorage.updateBudget(budget);
  }
  
  // Delete a budget
  Future<void> deleteBudget(int id) async {
    await _budgetStorage.deleteBudget(id);
  }
  
  // Get the total budget for the current month
  Future<double> getCurrentMonthTotalBudget() async {
    final now = DateTime.now();
    return await _budgetStorage.getTotalBudgetForMonth(now.year, now.month);
  }
  
  // Get spending for a specific category in the current month
  Future<double> getSpendingForCategory(String category) async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = (now.month < 12) 
        ? DateTime(now.year, now.month + 1, 1).subtract(Duration(days: 1))
        : DateTime(now.year + 1, 1, 1).subtract(Duration(days: 1));
    
    // Get all transactions for this month
    final transactions = await _messageStorage.getAllMessages();
    
    // Filter by date and category, and sum up outgoing transactions
    double total = 0.0;
    for (var transaction in transactions) {
      if (transaction.transactionDate.isAfter(startOfMonth) && 
          transaction.transactionDate.isBefore(endOfMonth.add(Duration(days: 1))) &&
          transaction.category == category &&
          transaction.direction == 'Outgoing') {
        total += transaction.amount;
      }
    }
    
    return total;
  }
  
  // Get total spending for the current month
  Future<double> getCurrentMonthTotalSpending() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = (now.month < 12) 
        ? DateTime(now.year, now.month + 1, 1).subtract(Duration(days: 1))
        : DateTime(now.year + 1, 1, 1).subtract(Duration(days: 1));
    
    // Get all transactions for this month
    final transactions = await _messageStorage.getAllMessages();
    
    // Sum up all outgoing transactions
    double total = 0.0;
    for (var transaction in transactions) {
      if (transaction.transactionDate.isAfter(startOfMonth) && 
          transaction.transactionDate.isBefore(endOfMonth.add(Duration(days: 1))) &&
          transaction.direction == 'Outgoing') {
        total += transaction.amount;
      }
    }
    
    return total;
  }
  
  // Get remaining days in current month
  int getRemainingDaysInMonth() {
    final now = DateTime.now();
    final lastDayOfMonth = (now.month < 12)
        ? DateTime(now.year, now.month + 1, 0).day
        : DateTime(now.year + 1, 1, 0).day;
    return lastDayOfMonth - now.day + 1;
  }
  
  // Get current month name
  String getCurrentMonthName() {
    return DateFormat('MMMM yyyy').format(DateTime.now());
  }
  
  // Get a list of all categories that have transactions
  Future<List<String>> getAllTransactionCategories() async {
    final transactions = await _messageStorage.getAllMessages();
    final categories = transactions.map((t) => t.category).toSet().toList();
    categories.sort();
    return categories;
  }
  
  // Get budget progress for a category (percentage spent)
  Future<double> getBudgetProgress(String category) async {
    final budgets = await getCurrentMonthBudgets();
    final categoryBudget = budgets.where((b) => b.category == category).toList();
    
    if (categoryBudget.isEmpty) return 0.0;
    
    final budgetAmount = categoryBudget.first.amount;
    final spent = await getSpendingForCategory(category);
    
    if (budgetAmount == 0) return 0.0;
    return (spent / budgetAmount).clamp(0.0, 1.0);
  }
  
  // Get overall budget progress
  Future<double> getOverallBudgetProgress() async {
    final totalBudget = await getCurrentMonthTotalBudget();
    final totalSpent = await getCurrentMonthTotalSpending();
    
    if (totalBudget == 0) return 0.0;
    return (totalSpent / totalBudget).clamp(0.0, 1.0);
  }
  
  // Close resources
  Future<void> close() async {
    await _budgetStorage.close();
    await _messageStorage.close();
  }
}