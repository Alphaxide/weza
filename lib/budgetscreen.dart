import 'package:flutter/material.dart';

class AddBudgetCategoryScreen extends StatefulWidget {
  const AddBudgetCategoryScreen({Key? key}) : super(key: key);

  @override
  State<AddBudgetCategoryScreen> createState() => _AddBudgetCategoryScreenState();
}

class _AddBudgetCategoryScreenState extends State<AddBudgetCategoryScreen> {
  final TextEditingController _categoryNameController = TextEditingController();
  final TextEditingController _budgetAmountController = TextEditingController();
  
  IconData _selectedIcon = Icons.shopping_bag;
  Color _selectedColor = const Color(0xFF4E6AF3); // Default color
  
  final List<IconData> _availableIcons = [
    Icons.shopping_bag,
    Icons.restaurant,
    Icons.directions_car,
    Icons.movie,
    Icons.bolt,
    Icons.home,
    Icons.school,
    Icons.credit_card,
    Icons.shopping_cart,
    Icons.fitness_center,
    Icons.local_hospital,
    Icons.pets,
  ];
  
  final List<Color> _availableColors = [
    const Color(0xFF4E6AF3), // Blue
    const Color(0xFFF5A623), // Orange
    Colors.green[700]!,
    const Color(0xFF9C5DE0), // Purple
    Colors.red[600]!,
    Colors.teal[600]!,
    Colors.pink[400]!,
    Colors.amber[700]!,
  ];

  @override
  void dispose() {
    _categoryNameController.dispose();
    _budgetAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Match dashboard background
      appBar: AppBar(
        title: const Text(
          'Add Budget Category',
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gradient header
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
                    const Text(
                      'Create a New Budget Category',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Set up a new category to better track your monthly spending',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Form Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Category Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Category Name Field
                    TextField(
                      controller: _categoryNameController,
                      decoration: InputDecoration(
                        labelText: 'Category Name',
                        hintText: 'e.g., Groceries, Rent, Subscriptions',
                        prefixIcon: const Icon(Icons.category),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Budget Amount Field
                    TextField(
                      controller: _budgetAmountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Monthly Budget Amount',
                        hintText: 'e.g., 10000',
                        prefixIcon: const Icon(Icons.currency_rupee),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Icon Selection
                    const Text(
                      'Choose an Icon',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: _availableIcons.map((icon) {
                          final isSelected = _selectedIcon == icon;
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _selectedIcon = icon;
                              });
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isSelected ? _selectedColor.withOpacity(0.1) : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                border: isSelected ? Border.all(color: _selectedColor) : null,
                              ),
                              child: Icon(
                                icon,
                                size: 28,
                                color: isSelected ? _selectedColor : Colors.grey.shade600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Color Selection
                    const Text(
                      'Choose a Color',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: _availableColors.map((color) {
                          final isSelected = _selectedColor == color;
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _selectedColor = color;
                              });
                            },
                            borderRadius: BorderRadius.circular(18),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: isSelected 
                                    ? Border.all(color: Colors.white, width: 2)
                                    : null,
                                boxShadow: isSelected 
                                    ? [BoxShadow(
                                        color: color.withOpacity(0.5),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      )]
                                    : null,
                              ),
                              child: isSelected 
                                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                                  : null,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Preview of the category
                    const Text(
                      'Preview',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _selectedColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _selectedIcon,
                              size: 28,
                              color: _selectedColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _categoryNameController.text.isEmpty 
                                      ? 'Category Name' 
                                      : _categoryNameController.text,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2D3142),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Budget: ₹${_budgetAmountController.text.isEmpty ? '0' : _budgetAmountController.text}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 100), // Bottom padding for FAB
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Validation could be added here
          if (_categoryNameController.text.isNotEmpty && _budgetAmountController.text.isNotEmpty) {
            // Save budget category logic
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Budget category "${_categoryNameController.text}" created successfully!'),
                backgroundColor: Colors.green[600],
              ),
            );
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Please fill in all required fields'),
                backgroundColor: Colors.red[600],
              ),
            );
          }
        },
        icon: const Icon(Icons.check),
        label: const Text(
          'Save Budget',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        elevation: 4,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}