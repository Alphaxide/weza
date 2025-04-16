// lib/screens/budget_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:weza/main.dart';
import 'package:weza/models/mpesa_message.dart';
import 'package:provider/provider.dart';
import 'package:weza/storage/mpesa_storage.dart';
import 'package:weza/storage/storage_provider.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({Key? key}) : super(key: key);

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  bool _isLoading = true;
  List<BudgetCategory> _budgetCategories = [];
  double _totalBudget = 0;
  double _totalSpent = 0;
  double _totalRemaining = 0;
  String _currentMonth = '';
  int _daysLeft = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    // Get current month name and year
    final now = DateTime.now();
    _currentMonth = DateFormat('MMMM yyyy').format(now);
    
    // Calculate days left in month
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    _daysLeft = lastDayOfMonth.day - now.day;

    final budgetProvider = Provider.of<BudgetProvider>(context, listen: false);
    final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
    
    await budgetProvider.loadBudgets();
    await transactionProvider.loadCurrentMonthTransactions();
    
    _budgetCategories = budgetProvider.budgets;
    
    // Calculate totals
    _totalBudget = _budgetCategories.fold(0, (sum, item) => sum + item.amount);
    _calculateSpendingTotals();

    setState(() {
      _isLoading = false;
    });
  }

  void _calculateSpendingTotals() {
    final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
    _totalSpent = 0;
    
    // Calculate spending for each category
    for (var category in _budgetCategories) {
      category.spent = transactionProvider.getCategorySpending(category.name);
      _totalSpent += category.spent;
    }
    
    _totalRemaining = _totalBudget - _totalSpent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Budget',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 22,
            fontFamily: 'Poppins',
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () async {
           
            },
          ),
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gradient header with monthly budget overview
                  Container(
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 36.0, top: 24.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withOpacity(0.85),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _currentMonth,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '$_daysLeft days left',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _BudgetSummaryItem(
                              label: 'Total Budget',
                              amount: _totalBudget,
                              icon: Icons.account_balance_wallet_rounded,
                              color: Colors.white,
                            ),
                            _BudgetSummaryItem(
                              label: 'Spent',
                              amount: _totalSpent,
                              icon: Icons.shopping_bag_rounded,
                              color: Colors.red.shade300,
                            ),
                            _BudgetSummaryItem(
                              label: 'Remaining',
                              amount: _totalRemaining,
                              icon: Icons.savings_rounded,
                              color: Colors.green.shade300,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Progress bar with rounded corners
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: _totalBudget > 0 ? (_totalSpent / _totalBudget).clamp(0.0, 1.0) : 0.0,
                            backgroundColor: Colors.white30,
                            color: Colors.white,
                            minHeight: 8,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _totalBudget > 0 
                                ? '${(_totalSpent / _totalBudget * 100).toInt()}% of budget used'
                                : '0% of budget used',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.info_outline,
                                  color: Colors.white70,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _getBudgetStatus(),
                                  style: TextStyle(
                                    color: _getBudgetStatusColor(),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Category budgets section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Category Budgets',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3142),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () async {
                            
                          },
                          icon: const Icon(Icons.add_circle_outline, size: 16),
                          label: const Text('Add New'),
                          style: TextButton.styleFrom(
                            foregroundColor: Theme.of(context).primaryColor,
                            minimumSize: Size.zero,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Category budget cards
                  if (_budgetCategories.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'No budget categories added yet. Tap "Add New" to create your first budget.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _budgetCategories.length,
                      itemBuilder: (context, index) {
                        final category = _budgetCategories[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16, left: 20, right: 20),
                          child: _CategoryBudgetCard(
                            category: category.name,
                            budgeted: category.amount,
                            spent: category.spent,
                            color: category.color ?? getCategoryColor(category.name),
                            icon: getCategoryIcon(category.name),
                            onTap: () async {
                             
                              
                            },
                          ),
                        );
                      },
                    ),
                  
                  const SizedBox(height: 80), // Bottom padding for FAB
                ],
              ),
            ),
          ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
         
          
        },
        icon: const Icon(Icons.add),
        label: const Text(
          'Create Budget',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        elevation: 4,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
  
  String _getBudgetStatus() {
    if (_totalBudget == 0) return 'No budget set';
    
    final percentUsed = _totalSpent / _totalBudget;
    final percentOfMonthPassed = (DateTime.now().day / DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day);
    
    if (percentUsed > percentOfMonthPassed + 0.1) {
      return 'Overspending';
    } else if (percentUsed < percentOfMonthPassed - 0.1) {
      return 'Under budget';
    } else {
      return 'On track';
    }
  }
  
  Color _getBudgetStatusColor() {
    final status = _getBudgetStatus();
    if (status == 'Overspending') {
      return Colors.red.shade300;
    } else if (status == 'Under budget' || status == 'On track') {
      return Colors.green.shade300;
    } else {
      return Colors.yellow.shade300;
    }
  }
  
  IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Food':
        return Icons.restaurant;
      case 'Transport':
        return Icons.directions_car;
      case 'Shopping':
        return Icons.shopping_bag;
      case 'Utilities':
        return Icons.bolt;
      case 'Entertainment':
        return Icons.movie;
      case 'Rent':
        return Icons.home;
      case 'Education':
        return Icons.school;
      case 'Health':
        return Icons.medical_services;
      case 'Business':
        return Icons.business;
      default:
        return Icons.category;
    }
  }
  
  Color getCategoryColor(String category) {
    switch (category) {
      case 'Food':
        return const Color(0xFFF5A623);
      case 'Transport':
        return Colors.green[700]!;
      case 'Shopping':
        return Colors.blue[700]!;
      case 'Utilities':
        return const Color(0xFF4E6AF3);
      case 'Entertainment':
        return const Color(0xFF9C5DE0);
      case 'Rent':
        return Colors.brown[700]!;
      case 'Education':
        return Colors.orange[700]!;
      case 'Health':
        return Colors.redAccent[700]!;
      case 'Business':
        return Colors.teal[700]!;
      default:
        return Colors.grey[700]!;
    }
  }
}

class AddBudgetScreen {
  const AddBudgetScreen();
}

class _BudgetSummaryItem extends StatelessWidget {
  final String label;
  final double amount;
  final IconData icon;
  final Color color;

  const _BudgetSummaryItem({
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: color,
            size: 22,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'KSh ${NumberFormat('#,###').format(amount)}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class _CategoryBudgetCard extends StatelessWidget {
  final String category;
  final double budgeted;
  final double spent;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _CategoryBudgetCard({
    required this.category,
    required this.budgeted,
    required this.spent,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (spent / budgeted * 100).clamp(0, 100).toInt();
    final remaining = budgeted - spent;
    
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          icon,
                          color: color,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        category,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getPercentageColor(percentage).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$percentage%',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: _getPercentageColor(percentage),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Budget',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'KSh ${NumberFormat('#,###').format(budgeted)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Spent',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'KSh ${NumberFormat('#,###').format(spent)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Remaining',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'KSh ${NumberFormat('#,###').format(remaining)}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: remaining > 0 ? Colors.green[700] : Colors.red[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: LinearProgressIndicator(
                  value: spent / budgeted,
                  backgroundColor: color.withOpacity(0.15),
                  color: color,
                  minHeight: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Color _getPercentageColor(int percentage) {
    if (percentage < 50) {
      return Colors.green[700]!;
    } else if (percentage < 80) {
      return const Color(0xFFF5A623); // Warm orange
    } else {
      return Colors.red[700]!;
    }
  }
}

// lib/models/budget_category.dart

class BudgetCategory {
  final int? id;
  final String name;
  final double amount;
  final Color? color;
  final DateTime month;
  double spent; // This will be calculated based on transactions

  BudgetCategory({
    this.id,
    required this.name,
    required this.amount,
    this.color,
    required this.month,
    this.spent = 0.0,
  });

  // Convert to map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'colorValue': color?.value,
      'month': month.millisecondsSinceEpoch,
      // spent is not stored as it's calculated from transactions
    };
  }

  // Create from map (database)
  factory BudgetCategory.fromMap(Map<String, dynamic> map) {
    return BudgetCategory(
      id: map['id'],
      name: map['name'],
      amount: map['amount'],
      color: map['colorValue'] != null ? Color(map['colorValue']) : null,
      month: DateTime.fromMillisecondsSinceEpoch(map['month']),
      spent: 0.0, // Will be calculated later
    );
  }

  // Copy with method for updates
  BudgetCategory copyWith({
    int? id,
    String? name,
    double? amount,
    Color? color,
    DateTime? month,
    double? spent,
  }) {
    return BudgetCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      color: color ?? this.color,
      month: month ?? this.month,
      spent: spent ?? this.spent,
    );
  }
}

// lib/storage/budget_storage.dart
class BudgetStorage {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'budget_categories.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE budget_categories(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      amount REAL,
      colorValue INTEGER,
      month INTEGER
    )
    ''');
  }

  Future<int> insertBudget(BudgetCategory budget) async {
    final db = await database;
    
    // Check if a budget for this category and month already exists
    final List<Map<String, dynamic>> existing = await db.query(
      'budget_categories',
      where: 'name = ? AND month = ?',
      whereArgs: [
        budget.name,
        _getMonthStart(budget.month).millisecondsSinceEpoch,
      ],
    );
    
    if (existing.isNotEmpty) {
      // Update existing budget
      final existingId = existing.first['id'];
      await db.update(
        'budget_categories',
        budget.copyWith(id: existingId).toMap(),
        where: 'id = ?',
        whereArgs: [existingId],
      );
      return existingId;
    } else {
      // Insert new budget
      return await db.insert('budget_categories', budget.toMap());
    }
  }

  Future<List<BudgetCategory>> getBudgetsForMonth(DateTime month) async {
    final db = await database;
    final monthStart = _getMonthStart(month);
    final monthEnd = _getMonthEnd(month);
    
    final List<Map<String, dynamic>> maps = await db.query(
      'budget_categories',
      where: 'month >= ? AND month <= ?',
      whereArgs: [
        monthStart.millisecondsSinceEpoch,
        monthEnd.millisecondsSinceEpoch,
      ],
    );
    
    return List.generate(maps.length, (i) {
      return BudgetCategory.fromMap(maps[i]);
    });
  }

  Future<BudgetCategory?> getBudget(int id) async {
    final db = await database;
    final maps = await db.query(
      'budget_categories',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return BudgetCategory.fromMap(maps.first);
    }
    return null;
  }

  Future<void> updateBudget(BudgetCategory budget) async {
    final db = await database;
    await db.update(
      'budget_categories',
      budget.toMap(),
      where: 'id = ?',
      whereArgs: [budget.id],
    );
  }

  Future<void> deleteBudget(int id) async {
    final db = await database;
    await db.delete(
      'budget_categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Helper to get start of month
  DateTime _getMonthStart(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  // Helper to get end of month
  DateTime _getMonthEnd(DateTime date) {
    return DateTime(date.year, date.month + 1, 0, 23, 59, 59);
  }
  
  join(String path, String s) {}
}

// lib/providers/budget_provider.dart
class BudgetProvider extends ChangeNotifier {
  final BudgetStorage _storage = BudgetStorage();
  List<BudgetCategory> _budgets = [];
  
  List<BudgetCategory> get budgets => _budgets;
  
  // Load budgets for current month
  Future<void> loadBudgets() async {
    final currentMonth = DateTime.now();
    _budgets = await _storage.getBudgetsForMonth(currentMonth);
    notifyListeners();
  }
  
  // Add or update a budget
  Future<void> addOrUpdateBudget(BudgetCategory budget) async {
    // Ensure month is set to the current month
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month, 1);
    
    final budgetForCurrentMonth = budget.copyWith(month: currentMonth);
    
    if (budget.id != null) {
      await _storage.updateBudget(budgetForCurrentMonth);
    } else {
      await _storage.insertBudget(budgetForCurrentMonth);
    }
    
    await loadBudgets();
  }
  
  // Delete a budget
  Future<void> deleteBudget(int id) async {
    await _storage.deleteBudget(id);
    await loadBudgets();
  }
  
  // Get a specific budget by ID
  Future<BudgetCategory?> getBudget(int id) async {
    return await _storage.getBudget(id);
  }
  
  // Get a budget by category name (for current month)
  BudgetCategory? getBudgetByCategory(String categoryName) {
    try {
      return _budgets.firstWhere((b) => b.name == categoryName);
    } catch (e) {
      return null;
    }
  }
  
  // Check if a category already has a budget for the current month
  bool categoryHasBudget(String categoryName) {
    return _budgets.any((b) => b.name == categoryName);
  }
}

// lib/providers/transaction_provider.dart

class TransactionProvider extends ChangeNotifier {
  final MessageStorage _storage = getStorageImplementation();
  List<MpesaMessage> _currentMonthTransactions = [];
  
  List<MpesaMessage> get currentMonthTransactions => _currentMonthTransactions;
  
  Future<void> initialize() async {
    await _storage.initialize();
  }
  
  // Load transactions for current month
  // Load transactions for current month
  Future<void> loadCurrentMonthTransactions() async {
    await initialize();
    
    final allTransactions = await _storage.getAllMessages();
    
    // Filter for current month transactions
    final now = DateTime.now();
    final currentMonthStart = DateTime(now.year, now.month, 1);
    final currentMonthEnd = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    
    _currentMonthTransactions = allTransactions.where((transaction) {
      return transaction.date.isAfter(currentMonthStart) && 
             transaction.date.isBefore(currentMonthEnd);
    }).toList();
    
    notifyListeners();
  }
  
  // Get total spending for a specific category in the current month
  double getCategorySpending(String category, dynamic TransactionType) {
    double total = 0;
    
    for (var transaction in _currentMonthTransactions) {
      if (transaction.category == category && transaction.type == TransactionType.debit) {
        total += transaction.amount;
      }
    }
    
    return total;
  }
  
  // Get transactions for a specific category
  List<MpesaMessage> getTransactionsByCategory(String category) {
    return _currentMonthTransactions
        .where((transaction) => 
            transaction.category == category && 
            transaction.type == TransactionType.debit)
        .toList();
  }
  
  // Refresh transactions (call this after categorizing messages)
  Future<void> refreshTransactions() async {
    await loadCurrentMonthTransactions();
  }
}


