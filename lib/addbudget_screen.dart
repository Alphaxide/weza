// lib/screens/add_budget_category_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/budget.dart';
import '../service/budget_service.dart';
import '../utils/category_helper.dart';

class AddBudgetCategoryScreen extends StatefulWidget {
  final Budget? existingBudget;
  
  const AddBudgetCategoryScreen({
    Key? key,
    this.existingBudget,
  }) : super(key: key);

  @override
  _AddBudgetCategoryScreenState createState() => _AddBudgetCategoryScreenState();
}

class _AddBudgetCategoryScreenState extends State<AddBudgetCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _budgetService = BudgetService();
  
  late TextEditingController _amountController;
  String _selectedCategory = '';
  List<String> _availableCategories = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.existingBudget?.amount.toString() ?? '',
    );
    _loadCategories();
  }
  
  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
    });
    
    await _budgetService.initialize();
    
    // Get all categories from CategoryHelper and from transactions
    final predefinedCategories = CategoryHelper.categoryKeywords.keys.toList();
    final transactionCategories = await _budgetService.getAllTransactionCategories();
    
    // Combine and remove duplicates
    final allCategories = {...predefinedCategories, ...transactionCategories}.toList();
    allCategories.sort();
    
    setState(() {
      _availableCategories = allCategories;
      _selectedCategory = widget.existingBudget?.category ?? 
                         (allCategories.isNotEmpty ? allCategories.first : '');
      _isLoading = false;
    });
  }
  
  @override
  void dispose() {
    _amountController.dispose();
    _budgetService.close();
    super.dispose();
  }
  
  Future<void> _saveBudget() async {
    if (!_formKey.currentState!.validate()) return;
    
    final amount = double.parse(_amountController.text.replaceAll(',', ''));
    
    try {
      if (widget.existingBudget != null) {
        // Update existing budget
        final updatedBudget = widget.existingBudget!.copyWith(
          category: _selectedCategory,
          amount: amount,
          updatedAt: DateTime.now(),
        );
        await _budgetService.updateBudget(updatedBudget);
      } else {
        // Create new budget
        await _budgetService.createBudget(_selectedCategory, amount);
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Budget ${widget.existingBudget != null ? 'updated' : 'created'} successfully')),
      );
      
      Navigator.pop(context, true); // Return success
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          widget.existingBudget != null ? 'Edit Budget' : 'Add Budget Category',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Card for form inputs
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Category selection
                              const Text(
                                'Category',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Color(0xFF2D3142),
                                ),
                              ),
                              const SizedBox(height: 12),
                              DropdownButtonFormField<String>(
                                value: _selectedCategory,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                items: _availableCategories.map((category) {
                                  return DropdownMenuItem<String>(
                                    value: category,
                                    child: Row(
                                      children: [
                                        Icon(
                                          _getCategoryIcon(category),
                                          color: Theme.of(context).primaryColor,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(category),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCategory = value!;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a category';
                                  }
                                  return null;
                                },
                              ),
                              
                              const SizedBox(height: 24),
                              
                              // Amount input
                              const Text(
                                'Monthly Budget Amount',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Color(0xFF2D3142),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'How much do you want to spend on this category per month?',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _amountController,
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                                ],
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  prefixIcon: const Icon(Icons.currency_exchange),
                                  prefixText: 'KSh ',
                                  hintText: '0.00',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter an amount';
                                  }
                                  final amount = double.tryParse(value.replaceAll(',', ''));
                                  if (amount == null || amount <= 0) {
                                    return 'Please enter a valid amount';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Save button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveBudget,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Theme.of(context).primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            widget.existingBudget != null ? 'Update Budget' : 'Create Budget',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      
                      if (widget.existingBudget != null) ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Budget'),
                                  content: const Text('Are you sure you want to delete this budget?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                              
                              if (confirm == true && widget.existingBudget?.id != null) {
                                await _budgetService.deleteBudget(widget.existingBudget!.id!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Budget deleted')),
                                );
                                Navigator.pop(context, true);
                              }
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Delete Budget',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
    );
  }
  
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Food':
      case 'Food & Dining':
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
      case 'Income':
        return Icons.monetization_on;
      case 'Business':
        return Icons.business;
      default:
        return Icons.category;
    }
  }
}