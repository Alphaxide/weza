import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:weza/budgetscreen.dart";
import "package:weza/utilitychart.dart";

void main() {
  runApp(const MPesaTrackerApp());
}

class CategoryDetailsScreen extends StatelessWidget {
  final String category;
  final Color categoryColor;
  final IconData categoryIcon;

  const CategoryDetailsScreen({
    Key? key,
    required this.category,
    required this.categoryColor,
    required this.categoryIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter transactions for this category
    final categoryTransactions = seedTransactions
        .where((transaction) => transaction.category == category)
        .toList();
    
    // Calculate total amount for this category
    final totalAmount = categoryTransactions.fold(
        0.0, (sum, transaction) => sum + transaction.amount);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Match dashboard background
      appBar: AppBar(
        title: Text(
          '$category',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 22,
            fontFamily: 'Poppins',
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gradient header section with shadow for depth (similar to dashboard)
            Container(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 30.0, top: 8.0),
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
                  // Category icon and title
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          categoryIcon,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${categoryTransactions.length} transactions',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Total Spent',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'KSh ${NumberFormat('#,###.00').format(totalAmount)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 32,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Time period filter - styled like dashboard elements
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.white,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Time Period: ',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: 'All Time',
                            isDense: true,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            onChanged: (String? newValue) {},
                            items: <String>['All Time', 'This Month', 'Last Month', 'This Year']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Transactions Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Transactions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),
            ),
            
            const SizedBox(height: 12),

            // Transactions list
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.white,
                  child: Container(
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
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: categoryTransactions.length,
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        indent: 76,
                        endIndent: 20,
                        thickness: 0.5,
                      ),
                      itemBuilder: (context, index) {
                        final transaction = categoryTransactions[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          leading: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _getTransactionColor(transaction.type).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              _getTransactionIcon(transaction.type),
                              color: _getTransactionColor(transaction.type),
                              size: 24,
                            ),
                          ),
                          title: Text(
                            transaction.recipient,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Text(
                                    'Ref: ${transaction.reference}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.circle,
                                    size: 4,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    DateFormat('dd MMM, HH:mm').format(transaction.date),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Text(
                            'KSh ${NumberFormat('#,###.00').format(transaction.amount)}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: transaction.type == 'receive' ? Colors.green[700] : Colors.red[700],
                            ),
                          ),
                          onTap: () {
                            // Navigate to transaction details
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TransactionDetailsScreen(
                                  transaction: transaction,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Color _getTransactionColor(String type) {
    switch (type) {
      case 'receive':
        return Colors.green[700]!;
      case 'send':
        return Colors.red[700]!;
      case 'paybill':
        return const Color(0xFFF5A623); // Warmer orange
      case 'withdraw':
        return const Color(0xFF9C5DE0); // Refined purple
      default:
        return const Color(0xFF4E6AF3); // More appealing blue
    }
  }
  
  IconData _getTransactionIcon(String type) {
    switch (type) {
      case 'receive':
        return Icons.arrow_downward_rounded;
      case 'send':
        return Icons.arrow_upward_rounded;
      case 'paybill':
        return Icons.receipt_long_rounded;
      case 'withdraw':
        return Icons.account_balance_wallet_rounded;
      default:
        return Icons.swap_horiz_rounded;
    }
  }
}

// Transaction Labeling System
class TransactionLabeler {
  // Store transaction labeling rules
  static final Map<String, String> _recipientCategoryMap = {
    // Common recipients to categories
    'KPLC': 'Utilities',
    'SAFARICOM': 'Bills',
    'DSTV': 'Entertainment',
    'NAIROBI WATER': 'Utilities',
    'ZUKU': 'Bills',
    'UBER': 'Transport',
    'BOLT': 'Transport',
    'JUMIA': 'Shopping',
    'CARREFOUR': 'Shopping',
    'NAIVAS': 'Shopping',
    'KCB': 'Banking',
    'EQUITY': 'Banking',
    'ABSA': 'Banking',
    'MPESA AGENT': 'Cash',
    'ATM': 'Cash',
    // Add more common Kenya-specific recipients
  };
  
  // Store transaction keyword rules
  static final Map<String, String> _keywordCategoryMap = {
    'electricity': 'Utilities',
    'water': 'Utilities',
    'bill': 'Bills',
    'subscription': 'Entertainment',
    'taxi': 'Transport',
    'matatu': 'Transport',
    'fare': 'Transport',
    'food': 'Food & Dining',
    'restaurant': 'Food & Dining',
    'groceries': 'Shopping',
    'supermarket': 'Shopping',
    'salary': 'Income',
    'payment': 'Income',
    'withdraw': 'Cash',
    'school': 'Education',
    'fees': 'Education',
    'medical': 'Healthcare',
    'hospital': 'Healthcare',
    'pharmacy': 'Healthcare',
    // Add more keywords for Kenya-specific transactions
  };
  
  // Auto-assign category based on recipient and SMS content
  static String suggestCategory(String recipient, String smsContent, String transactionType) {
    // First check if recipient is directly in our map
    String recipientUpper = recipient.toUpperCase();
    
    // Direct recipient match
    for (var entry in _recipientCategoryMap.entries) {
      if (recipientUpper.contains(entry.key)) {
        return entry.value;
      }
    }
    
    // Check for keywords in SMS content
    String smsLower = smsContent.toLowerCase();
    for (var entry in _keywordCategoryMap.entries) {
      if (smsLower.contains(entry.key)) {
        return entry.value;
      }
    }
    
    // Default categories based on transaction type
    switch (transactionType) {
      case 'receive':
        return 'Income';
      case 'send':
        return 'Friends & Family';
      case 'paybill':
        return 'Bills';
      case 'withdraw':
        return 'Cash';
      default:
        return 'Other';
    }
  }
  
  // Method to learn from user categorizations
  static void learnFromUserCategorization(String recipient, String category) {
    // Add this categorization to our map for future suggestions
    _recipientCategoryMap[recipient.toUpperCase()] = category;
  }
  
  // Parse M-Pesa SMS to extract transaction details
  static Map<String, dynamic>? parseMpesaSms(String smsContent) {
    try {
      // Common patterns in M-Pesa SMS messages
      smsContent = smsContent.toUpperCase();
      
      // Determine transaction type
      String transactionType;
      if (smsContent.contains('YOU HAVE RECEIVED')) {
        transactionType = 'receive';
      } else if (smsContent.contains('YOU HAVE SENT')) {
        transactionType = 'send';
      } else if (smsContent.contains('PAID TO')) {
        transactionType = 'paybill';
      } else if (smsContent.contains('WITHDRAW') || smsContent.contains('DEBITED')) {
        transactionType = 'withdraw';
      } else {
        transactionType = 'other';
      }
      
      // Extract amount 
      final amountRegex = RegExp(r'KSH([\d,]+)');
      final amountMatch = amountRegex.firstMatch(smsContent);
      String? amountStr = amountMatch?.group(1)?.replaceAll(',', '');
      double amount = amountStr != null ? double.parse(amountStr) : 0;
      
      // Extract recipient/sender based on transaction type
      String recipient = '';
      if (transactionType == 'receive') {
        final fromRegex = RegExp(r'FROM\s+([A-Z0-9\s]+)\s+ON');
        final fromMatch = fromRegex.firstMatch(smsContent);
        recipient = fromMatch?.group(1)?.trim() ?? 'Unknown';
      } else if (transactionType == 'send') {
        final toRegex = RegExp(r'TO\s+([A-Z0-9\s]+)\s+ON');
        final toMatch = toRegex.firstMatch(smsContent);
        recipient = toMatch?.group(1)?.trim() ?? 'Unknown';
      } else if (transactionType == 'paybill') {
        final toRegex = RegExp(r'TO\s+([A-Z0-9\s]+)\.');
        final toMatch = toRegex.firstMatch(smsContent);
        recipient = toMatch?.group(1)?.trim() ?? 'Unknown';
      }
      
      // Extract reference if any (usually for paybill)
      String reference = '';
      final refRegex = RegExp(r'REF.\s+([A-Z0-9]+)');
      final refMatch = refRegex.firstMatch(smsContent);
      if (refMatch != null) {
        reference = refMatch.group(1) ?? '';  
      }
      
      // Try to extract date and time
      DateTime date = DateTime.now();
      
      // Determine category based on extracted info
      String category = suggestCategory(recipient, smsContent, transactionType);
      
      return {
        'type': transactionType,
        'amount': amount,
        'recipient': recipient,
        'reference': reference,
        'date': date,
        'category': category,
        'description': _generateDescription(transactionType, recipient),
      };
    } catch (e) {
      print('Error parsing SMS: $e');
      return null;
    }
  }
  
  static String _generateDescription(String transactionType, String recipient) {
    switch (transactionType) {
      case 'receive':
        return 'Received from $recipient';
      case 'send':
        return 'Sent to $recipient';
      case 'paybill':
        return 'Paid to $recipient';
      case 'withdraw':
        return 'Withdrawal';
      default:
        return 'Transaction with $recipient';
    }
  }
}

// SMS Labeling Screen
class TransactionLabelingScreen extends StatefulWidget {
  final String smsContent;
  final Map<String, dynamic>? parsedData;

  const TransactionLabelingScreen({
    Key? key, 
    required this.smsContent,
    this.parsedData,
  }) : super(key: key);

  @override
  State<TransactionLabelingScreen> createState() => _TransactionLabelingScreenState();
}

class _TransactionLabelingScreenState extends State<TransactionLabelingScreen> {
  late TextEditingController _amountController;
  late TextEditingController _recipientController;
  late TextEditingController _referenceController;
  late TextEditingController _descriptionController;
  String _selectedCategory = 'Other';
  String _transactionType = 'other';
  DateTime _transactionDate = DateTime.now();
  bool _isAutoLabeled = false;
  
  final List<String> _categories = [
    'Income',
    'Food & Dining',
    'Transport',
    'Utilities',
    'Entertainment',
    'Shopping',
    'Bills',
    'Education',
    'Healthcare',
    'Family',
    'Friends',
    'Cash',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    
    // Initialize with parsed data if available or default values
    if (widget.parsedData != null) {
      _amountController = TextEditingController(text: widget.parsedData!['amount'].toString());
      _recipientController = TextEditingController(text: widget.parsedData!['recipient']);
      _referenceController = TextEditingController(text: widget.parsedData!['reference']);
      _descriptionController = TextEditingController(text: widget.parsedData!['description']);
      _selectedCategory = widget.parsedData!['category'];
      _transactionType = widget.parsedData!['type'];
      _transactionDate = widget.parsedData!['date'];
      _isAutoLabeled = true;
    } else {
      _amountController = TextEditingController();
      _recipientController = TextEditingController();
      _referenceController = TextEditingController();
      _descriptionController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _recipientController.dispose();
    _referenceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Label Transaction'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Original SMS
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.message, color: Colors.grey),
                        const SizedBox(width: 8),
                        const Text(
                          'Original SMS',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        if (_isAutoLabeled)
                          Chip(
                            label: const Text('Auto-labeled'),
                            backgroundColor: Colors.green.withOpacity(0.2),
                            avatar: const Icon(Icons.auto_awesome, color: Colors.green, size: 16),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(widget.smsContent),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Transaction type
            const Text(
              'Transaction Type',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _TransactionTypeChip(
                    label: 'Money In',
                    type: 'receive',
                    selected: _transactionType == 'receive',
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _transactionType = 'receive';
                        });
                      }
                    },
                  ),
                  _TransactionTypeChip(
                    label: 'Money Out',
                    type: 'send',
                    selected: _transactionType == 'send',
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _transactionType = 'send';
                        });
                      }
                    },
                  ),
                  _TransactionTypeChip(
                    label: 'Bill Payment',
                    type: 'paybill',
                    selected: _transactionType == 'paybill',
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _transactionType = 'paybill';
                        });
                      }
                    },
                  ),
                  _TransactionTypeChip(
                    label: 'Withdrawal',
                    type: 'withdraw',
                    selected: _transactionType == 'withdraw',
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _transactionType = 'withdraw';
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Transaction details
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Transaction Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                        labelText: 'Amount (KSh)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.monetization_on),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _recipientController,
                      decoration: const InputDecoration(
                        labelText: 'Recipient/Sender',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _referenceController,
                      decoration: const InputDecoration(
                        labelText: 'Reference Number',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.confirmation_number),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Category selection
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Category',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: _categories.map((category) {
                        return ChoiceChip(
                          label: Text(category),
                          selected: _selectedCategory == category,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedCategory = category;
                              });
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Date and time selection
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Date & Time',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text(
                        DateFormat('dd MMM yyyy, HH:mm').format(_transactionDate),
                      ),
                      trailing: const Icon(Icons.edit),
                      onTap: () async {
                        // Show date-time picker
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _transactionDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        
                        if (pickedDate != null) {
                          // Show time picker
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(_transactionDate),
                          );
                          
                          if (pickedTime != null) {
                            setState(() {
                              _transactionDate = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                            });
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Create transaction with current data
                  final newTransaction = Transaction(
                    id: 'TX${DateTime.now().millisecondsSinceEpoch}',
                    type: _transactionType,
                    recipient: _recipientController.text,
                    amount: double.tryParse(_amountController.text) ?? 0,
                    date: _transactionDate,
                    description: _descriptionController.text,
                    category: _selectedCategory,
                    reference: _referenceController.text,
                  );
                  
                  // Learn from this categorization for future auto-labeling
                  TransactionLabeler.learnFromUserCategorization(
                    _recipientController.text, 
                    _selectedCategory
                  );
                  
                  // Return the new transaction to the caller
                  Navigator.pop(context, newTransaction);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Save Transaction'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionTypeChip extends StatelessWidget {
  final String label;
  final String type;
  final bool selected;
  final Function(bool)? onSelected;

  const _TransactionTypeChip({
    required this.label,
    required this.type,
    this.selected = false,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getColorForType(type);
    
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: onSelected,
        selectedColor: color.withOpacity(0.2),
        checkmarkColor: color,
        avatar: Icon(
          _getIconForType(type),
          color: selected ? color : Colors.grey,
          size: 18,
        ),
      ),
    );
  }
  
  Color _getColorForType(String type) {
    switch (type) {
      case 'receive':
        return Colors.green;
      case 'send':
        return Colors.red;
      case 'paybill':
        return Colors.orange;
      case 'withdraw':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }
  
  IconData _getIconForType(String type) {
    switch (type) {
      case 'receive':
        return Icons.arrow_downward;
      case 'send':
        return Icons.arrow_upward;
      case 'paybill':
        return Icons.receipt;
      case 'withdraw':
        return Icons.money;
      default:
        return Icons.swap_horiz;
    }
  }
}

class MPesaTrackerApp extends StatelessWidget {
  const MPesaTrackerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weza',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00A86B), // M-Pesa green
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class Transaction {
  final String id;
  final String type; // send, receive, paybill, etc.
  final String recipient;
  final double amount;
  final DateTime date;
  final String description;
  final String category;
  final String reference;

  Transaction({
    required this.id,
    required this.type,
    required this.recipient,
    required this.amount,
    required this.date,
    required this.description,
    required this.category,
    required this.reference,
  });
}


String autoLabelCategory(String recipient, String description, String type) {
  recipient = recipient.toLowerCase();
  description = description.toLowerCase();
  
  // Utility companies
  if (recipient.contains('kplc') || 
      recipient.contains('kenya power') || 
      description.contains('electricity')) {
    return 'Utilities';
  }
  
  if (recipient.contains('safaricom') || 
      recipient.contains('airtel') || 
      recipient.contains('telkom') ||
      description.contains('airtime') ||
      description.contains('data bundle')) {
    return 'Telecommunications';
  }
  
  if (recipient.contains('water') || 
      description.contains('water bill')) {
    return 'Utilities';
  }
  
  // Transportation
  if (recipient.contains('uber') || 
      recipient.contains('bolt') || 
      recipient.contains('little') ||
      description.contains('taxi') ||
      description.contains('fare') ||
      description.contains('transport')) {
    return 'Transport';
  }
  
  // Food and shopping
  if (recipient.contains('supermarket') || 
      recipient.contains('market') || 
      recipient.contains('shop') ||
      recipient.contains('store')) {
    return 'Shopping';
  }
  
  if (recipient.contains('restaurant') || 
      recipient.contains('cafe') || 
      recipient.contains('food') ||
      description.contains('lunch') ||
      description.contains('dinner')) {
    return 'Food & Dining';
  }
  
  // Default categories based on transaction type
  if (type == 'receive') {
    return 'Income';
  }
  
  if (type == 'withdraw') {
    return 'Cash';
  }
  
  // Default
  return 'Other';
}


// Seed data
final List<Transaction> seedTransactions = [
  Transaction(
    id: 'QJL7HPIHX2',
    type: 'send',
    recipient: 'John Doe',
    amount: 1500,
    date: DateTime.now().subtract(const Duration(hours: 2)),
    description: 'Sent to John Doe',
    category: 'Friends',
    reference: 'Lunch payment',
  ),
  Transaction(
    id: 'QJL7HPIHX3',
    type: 'receive',
    recipient: 'Mary Smith',
    amount: 2000,
    date: DateTime.now().subtract(const Duration(days: 1)),
    description: 'Received from Mary Smith',
    category: 'Income',
    reference: 'Project payment',
  ),
  Transaction(
    id: 'QJL7HPIHX4',
    type: 'paybill',
    recipient: 'KPLC',
    amount: 1200,
    date: DateTime.now().subtract(const Duration(days: 2)),
    description: 'Paid to KPLC',
    category: 'Utilities',
    reference: 'Electricity bill',
  ),

  Transaction(
    id: 'QJL7HPIHX6',
    type: 'paybill',
    recipient: 'KPLC',
    amount: 1200,
    date: DateTime.now().subtract(const Duration(days: 2)),
    description: 'Paid to KPLC',
    category: 'Utilities',
    reference: 'Electricity bill',
  ),
  Transaction(
    id: 'QJL7HPIHX5',
    type: 'withdraw',
    recipient: 'ATM',
    amount: 3000,
    date: DateTime.now().subtract(const Duration(days: 3)),
    description: 'Withdrawal',
    category: 'Cash',
    reference: 'Weekend expenses',
  ),
  Transaction(
    id: 'QJL7HPIHX6',
    type: 'paybill',
    recipient: 'Safaricom',
    amount: 1000,
    date: DateTime.now().subtract(const Duration(days: 5)),
    description: 'Paid to Safaricom',
    category: 'Bills',
    reference: 'Phone bill',
  ),
  Transaction(
    id: 'QJL7HPIHX7',
    type: 'send',
    recipient: 'James Kamau',
    amount: 500,
    date: DateTime.now().subtract(const Duration(days: 7)),
    description: 'Sent to James Kamau',
    category: 'Family',
    reference: 'Transport',
  ),
  Transaction(
    id: 'QJL7HPIHX8',
    type: 'receive',
    recipient: 'Employer',
    amount: 35000,
    date: DateTime.now().subtract(const Duration(days: 15)),
    description: 'Received from Employer',
    category: 'Salary',
    reference: 'April Salary',
  ),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = [
    const DashboardScreen(),
    const TransactionsScreen(),
    const BudgetScreen(),
    const TransactionAnalysisScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            backgroundColor: Colors.white,
            elevation: 0,
            height: 68,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            animationDuration: const Duration(milliseconds: 400),
            destinations: [
              NavigationDestination(
                icon: Icon(
                  Icons.dashboard_outlined, 
                  color: Colors.grey[600],
                ),
                selectedIcon: Icon(
                  Icons.dashboard_rounded,
                  color: primaryColor,
                ),
                label: 'Dashboard',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.receipt_long_outlined, 
                  color: Colors.grey[600],
                ),
                selectedIcon: Icon(
                  Icons.receipt_long_rounded,
                  color: primaryColor,
                ),
                label: 'Transactions',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.pie_chart_outline_rounded, 
                  color: Colors.grey[600],
                ),
                selectedIcon: Icon(
                  Icons.pie_chart_rounded,
                  color: primaryColor,
                ),
                label: 'Budget',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.analytics_outlined, 
                  color: Colors.grey[600],
                ),
                selectedIcon: Icon(
                  Icons.analytics_rounded,
                  color: primaryColor,
                ),
                label: 'Analysis',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate total money in and out
    double totalIn = seedTransactions
        .where((t) => t.type == 'receive')
        .fold(0, (total, t) => total + t.amount);
    
    double totalOut = seedTransactions
        .where((t) => t.type != 'receive')
        .fold(0, (total, t) => total + t.amount);
    
    double currentBalance = totalIn - totalOut;
    
    // Get recent transactions
    final recentTransactions = seedTransactions.take(3).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Lighter, softer background
      appBar: AppBar(
        title: const Text(
  'Weza',
  style: TextStyle(
    fontWeight: FontWeight.w500,      // Less bold for a casual feel
    fontSize: 22,
    fontFamily: 'Poppins',            // A more friendly font option
    color: Colors.white,            // Slightly softer than pure black
  ),
  textAlign: TextAlign.center,
),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gradient header section with shadow for depth
              Container(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 36.0, top: 8.0),
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
                      'Current Balance',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'KSh ${NumberFormat('#,###.00').format(currentBalance)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 36,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          currentBalance > 0 ? '+4.2%' : '-2.1%',
                          style: TextStyle(
                            fontSize: 14,
                            color: currentBalance > 0 ? Colors.green.shade300 : Colors.red.shade300,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Money In/Out Cards - redesigned with soft shadows and more spacing
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Expanded(
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
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.arrow_downward_rounded,
                                  color: Colors.green,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(height: 14),
                              const Text(
                                'Money In',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'KSh ${NumberFormat('#,###.00').format(totalIn)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
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
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.arrow_upward_rounded,
                                  color: Colors.red,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(height: 14),
                              const Text(
                                'Money Out',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'KSh ${NumberFormat('#,###.00').format(totalOut)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Recent Transactions - improved section styling
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Transactions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransactionsScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.arrow_forward, size: 16),
                      label: const Text('See All'),
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
              
              const SizedBox(height: 12),
              
              // Recent Transaction List with improved styling
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.white,
                  child: Container(
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
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recentTransactions.length,
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        indent: 76,
                        endIndent: 20,
                        thickness: 0.5,
                      ),
                      itemBuilder: (context, index) {
                        final transaction = recentTransactions[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          leading: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _getTransactionColor(transaction.type).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              _getTransactionIcon(transaction.type),
                              color: _getTransactionColor(transaction.type),
                              size: 24,
                            ),
                          ),
                          title: Text(
                            transaction.recipient,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              DateFormat('dd MMM, HH:mm').format(transaction.date),
                              style: TextStyle(
                                fontSize: 13, 
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          trailing: Text(
                            '${transaction.type == 'receive' ? '+' : '-'} KSh ${NumberFormat('#,###.00').format(transaction.amount)}',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: transaction.type == 'receive' ? Colors.green[700] : Colors.red[700],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Spending by Category - improved styling
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Spending by Category',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Details'),
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
              
              const SizedBox(height: 12),
              
              // Category visualization with improved styling
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                      children: [
                        // Sample category bars
                        _CategoryProgressBar(
                          category: 'Utilities',
                          amount: 1200,
                          percentage: 30,
                          color: const Color(0xFF4E6AF3), // More appealing blue shade
                          icon: Icons.bolt,
                        ),
                        const SizedBox(height: 20),
                        _CategoryProgressBar(
                          category: 'Bills',
                          amount: 1000,
                          percentage: 25,
                          color: const Color(0xFF9C5DE0), // Refined purple shade
                          icon: Icons.receipt_long,
                        ),
                        const SizedBox(height: 20),
                        _CategoryProgressBar(
                          category: 'Cash',
                          amount: 3000,
                          percentage: 45,
                          color: const Color(0xFFF5A623), // Warm orange
                          icon: Icons.account_balance_wallet,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 90), // Extra padding for FAB
            ],
          ),
        ),
      ),
    
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // Removed bottom navigation bar as it's now handled by HomeScreen
    );
  }
  
  Color _getTransactionColor(String type) {
    switch (type) {
      case 'receive':
        return Colors.green[700]!;
      case 'send':
        return Colors.red[700]!;
      case 'paybill':
        return const Color(0xFFF5A623); // Warmer orange
      case 'withdraw':
        return const Color(0xFF9C5DE0); // Refined purple
      default:
        return const Color(0xFF4E6AF3); // More appealing blue
    }
  }
  
  IconData _getTransactionIcon(String type) {
    switch (type) {
      case 'receive':
        return Icons.arrow_downward_rounded;
      case 'send':
        return Icons.arrow_upward_rounded;
      case 'paybill':
        return Icons.receipt_long_rounded;
      case 'withdraw':
        return Icons.account_balance_wallet_rounded;
      default:
        return Icons.swap_horiz_rounded;
    }
  }
}

class _CategoryProgressBar extends StatelessWidget {
  final String category;
  final double amount;
  final int percentage;
  final Color color;
  final IconData icon;

  const _CategoryProgressBar({
    required this.category,
    required this.amount,
    required this.percentage,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              category,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: color.withOpacity(0.15),
                  color: color,
                  minHeight: 10,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'KSh ${NumberFormat('#,###').format(amount)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$percentage%',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Match dashboard background
      appBar: AppBar(
        title: const Text(
          'Transactions',
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
      
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Gradient header extension
            Container(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0, top: 8.0),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _TransactionSummaryItem(
                    label: 'All',
                    amount: 53200.00,
                    icon: Icons.swap_horiz_rounded,
                    color: Colors.white,
                  ),
                  _TransactionSummaryItem(
                    label: 'In',
                    amount: 35000.00,
                    icon: Icons.arrow_downward_rounded,
                    color: Colors.green.shade300,
                  ),
                  _TransactionSummaryItem(
                    label: 'Out',
                    amount: 18200.00,
                    icon: Icons.arrow_upward_rounded,
                    color: Colors.red.shade300,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Transaction filter tabs with improved styling
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _FilterChip(label: 'All', selected: true),
                    _FilterChip(label: 'Sent'),
                    _FilterChip(label: 'Received'),
                    _FilterChip(label: 'Bills'),
                    _FilterChip(label: 'Withdrawals'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Section header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Activity',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.calendar_today, size: 16),
                    label: const Text('This Month'),
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
            
            const SizedBox(height: 12),
            
            // Transactions list with improved UI
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.white,
                  child: Container(
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
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: seedTransactions.length,
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        indent: 76,
                        endIndent: 20,
                        thickness: 0.5,
                      ),
                      itemBuilder: (context, index) {
                        final transaction = seedTransactions[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          leading: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _getTransactionColor(transaction.type).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              _getTransactionIcon(transaction.type),
                              color: _getTransactionColor(transaction.type),
                              size: 24,
                            ),
                          ),
                          title: Text(
                            transaction.recipient,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                'Ref: ${transaction.reference}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                DateFormat('dd MMM yyyy, HH:mm').format(transaction.date),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          trailing: Text(
                            '${transaction.type == 'receive' ? '+' : '-'} KSh ${NumberFormat('#,###.00').format(transaction.amount)}',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: transaction.type == 'receive' ? Colors.green[700] : Colors.red[700],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TransactionDetailsScreen(
                                  transaction: transaction,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTransactionColor(String type) {
    switch (type) {
      case 'receive':
        return Colors.green[700]!;
      case 'send':
        return Colors.red[700]!;
      case 'paybill':
        return const Color(0xFFF5A623); // Warmer orange
      case 'withdraw':
        return const Color(0xFF9C5DE0); // Refined purple
      default:
        return const Color(0xFF4E6AF3); // More appealing blue
    }
  }

  IconData _getTransactionIcon(String type) {
    switch (type) {
      case 'receive':
        return Icons.arrow_downward_rounded;
      case 'send':
        return Icons.arrow_upward_rounded;
      case 'paybill':
        return Icons.receipt_long_rounded;
      case 'withdraw':
        return Icons.account_balance_wallet_rounded;
      default:
        return Icons.swap_horiz_rounded;
    }
  }

  void _showSmsInputDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String smsText = '';
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Add Transaction from SMS'),
          content: TextField(
            maxLines: 4,
            onChanged: (value) => smsText = value,
            decoration: const InputDecoration(
              hintText: 'Paste your transaction SMS here...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: Color(0xFF4E6AF3), width: 2),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[700],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Parse and save the transaction from smsText
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _FilterChip({
    required this.label,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: FilterChip(
        selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
        checkmarkColor: Theme.of(context).primaryColor,
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: selected 
                ? Theme.of(context).primaryColor.withOpacity(0.5) 
                : Colors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
        label: Text(
          label,
          style: TextStyle(
            color: selected ? Theme.of(context).primaryColor : Colors.grey[700],
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        selected: selected,
        onSelected: (bool value) {},
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}

class _TransactionSummaryItem extends StatelessWidget {
  final String label;
  final double amount;
  final IconData icon;
  final Color color;

  const _TransactionSummaryItem({
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

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Match dashboard background
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
            onPressed: () {

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddBudgetCategoryScreen(
                                 
                                ),
                              ),
                            );
            },
            // AddBudgetCategoryScreen
          ),
        ],
      ),
      body: SafeArea(
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
                        const Text(
                          'April 2025',
                          style: TextStyle(
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
                          child: const Text(
                            '20 days left',
                            style: TextStyle(
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
                          amount: 45000.00,
                          icon: Icons.account_balance_wallet_rounded,
                          color: Colors.white,
                        ),
                        _BudgetSummaryItem(
                          label: 'Spent',
                          amount: 27200.00,
                          icon: Icons.shopping_bag_rounded,
                          color: Colors.red.shade300,
                        ),
                        _BudgetSummaryItem(
                          label: 'Remaining',
                          amount: 17800.00,
                          icon: Icons.savings_rounded,
                          color: Colors.green.shade300,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Progress bar with rounded corners
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: const LinearProgressIndicator(
                        value: 0.6,
                        backgroundColor: Colors.white30,
                        color: Colors.white,
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '60% of budget used',
                          style: TextStyle(
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
                              'On track',
                              style: TextStyle(
                                color: Colors.green.shade300,
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
                      onPressed: () {},
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _CategoryBudgetCard(
                  category: 'Food & Dining',
                  budgeted: 15000,
                  spent: 12300,
                  color: const Color(0xFFF5A623), // Warm orange
                  icon: Icons.restaurant,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryDetailsScreen(
                          category: 'Food & Dining',
                          categoryColor: const Color(0xFFF5A623),
                          categoryIcon: Icons.restaurant,
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 16),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _CategoryBudgetCard(
                  category: 'Utilities',
                  budgeted: 8000,
                  spent: 6500,
                  color: const Color(0xFF4E6AF3), // More appealing blue
                  icon: Icons.bolt,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryDetailsScreen(
                          category: 'Utilities',
                          categoryColor: const Color(0xFF4E6AF3),
                          categoryIcon: Icons.bolt,
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 16),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _CategoryBudgetCard(
                  category: 'Transport',
                  budgeted: 12000,
                  spent: 5400,
                  color: Colors.green[700]!,
                  icon: Icons.directions_car,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryDetailsScreen(
                          category: 'Transport',
                          categoryColor: Colors.green[700]!,
                          categoryIcon: Icons.directions_car,
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 16),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _CategoryBudgetCard(
                  category: 'Entertainment',
                  budgeted: 5000,
                  spent: 3000,
                  color: const Color(0xFF9C5DE0), // Refined purple
                  icon: Icons.movie,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryDetailsScreen(
                          category: 'Entertainment',
                          categoryColor: const Color(0xFF9C5DE0),
                          categoryIcon: Icons.movie,
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 24),
              
              Center(
                child: TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.expand_more),
                  label: const Text('View All Categories'),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ),
              
              const SizedBox(height: 80), // Bottom padding for FAB
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddBudgetCategoryScreen(
                                 
                                ),
                              ),
                            );
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
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Food & Dining':
        return Icons.restaurant;
      case 'Utilities':
        return Icons.bolt;
      case 'Transport':
        return Icons.directions_car;
      case 'Entertainment':
        return Icons.movie;
      default:
        return Icons.category;
    }
  }
  
  
  Color _getPercentageColor(int percentage) {
    if (percentage < 50) {
      return Colors.green;
    } else if (percentage < 75) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }


// New SMS Message Parsing Screen
class SmsParseScreen extends StatelessWidget {
  const SmsParseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMS Sync'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'M-Pesa SMS Messages',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // SMS permission status card
            Card(
              elevation: 2,
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SMS Permission Granted',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'App will automatically sync M-Pesa messages',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // SMS sync settings
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sync Settings',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Auto-sync new messages'),
                      subtitle: const Text('Sync messages as they arrive'),
                      value: true,
                      onChanged: (value) {},
                    ),
                    SwitchListTile(
                      title: const Text('Parse transaction details'),
                      subtitle: const Text('Extract amount, reference, and category'),
                      value: true,
                      onChanged: (value) {},
                    ),
                    SwitchListTile(
                      title: const Text('Sync historical messages'),
                      subtitle: const Text('Fetch past M-Pesa messages'),
                      value: false,
                      onChanged: (value) {},
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Recent SMS messages
            const Text(
              'Recent Messages',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Expanded(
              child: Card(
                elevation: 2,
                child: ListView(
                  children: [
                    _SmsMessageTile(
                      message: 'MPESA confirmation. KCB5XXXX confirmed. You have received Ksh2,000 from MARY SMITH on 11/4/25 at 10:23 AM. New M-PESA balance is Ksh15,320.00.',
                      parsed: true,
                      date: DateTime.now().subtract(const Duration(hours: 1)),
                    ),
                    const Divider(height: 1),
                    _SmsMessageTile(
                      message: 'MPESA confirmation. KCB5XXXX confirmed. You have sent Ksh1,500 to JOHN DOE on 11/4/25 at 8:45 AM. New M-PESA balance is Ksh13,320.00.',
                      parsed: true,
                      date: DateTime.now().subtract(const Duration(hours: 3)),
                    ),
                    const Divider(height: 1),
                    _SmsMessageTile(
                      message: 'MPESA confirmation. KCB5XXXX confirmed. Ksh1,200 paid to KPLC PREPAID. on 9/4/25 at 5:13 PM. Ref. AB123456. New M-PESA balance is Ksh14,820.00.',
                      parsed: true,
                      date: DateTime.now().subtract(const Duration(days: 2)),
                    ),
                    const Divider(height: 1),
                    _SmsMessageTile(
                      message: 'Your M-PESA account was debited with Ksh3,000 on 8/4/25 at 2:30 PM. Use PIN at ATM to withdraw. New M-PESA balance is Ksh16,020.00.',
                      parsed: true,
                      date: DateTime.now().subtract(const Duration(days: 3)),
                    ),
                    const Divider(height: 1),
                    _SmsMessageTile(
                      message: 'MPESA confirmation. KCB5XXXX confirmed. Ksh1,000 paid to SAFARICOM. on 6/4/25 at 9:05 AM. Ref. XY987654. New M-PESA balance is Ksh19,020.00.',
                      parsed: true,
                      date: DateTime.now().subtract(const Duration(days: 5)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Manual Sync',
        child: const Icon(Icons.sync),
      ),
    );
  }
}

class _SmsMessageTile extends StatelessWidget {
  final String message;
  final bool parsed;
  final DateTime date;

  const _SmsMessageTile({
    required this.message,
    required this.parsed,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(16.0),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: parsed ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          parsed ? Icons.check_circle : Icons.warning,
          color: parsed ? Colors.green : Colors.orange,
        ),
      ),
      title: Text(
        message,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          DateFormat('dd MMM yyyy, HH:mm').format(date),
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ),
      trailing: parsed
          ? const Icon(Icons.check, color: Colors.green)
          : TextButton(
              onPressed: () {},
              child: const Text('Parse'),
            ),
      onTap: () {},
    );
  }
}

// Add Transaction Screen
class AddTransactionScreen extends StatelessWidget {
  const AddTransactionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Transaction type selector
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Transaction Type',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _TransactionTypeButton(
                            title: 'Send',
                            icon: Icons.arrow_upward,
                            color: Colors.red,
                            selected: false,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _TransactionTypeButton(
                            title: 'Receive',
                            icon: Icons.arrow_downward,
                            color: Colors.green,
                            selected: true,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _TransactionTypeButton(
                            title: 'Paybill',
                            icon: Icons.receipt,
                            color: Colors.orange,
                            selected: false,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Transaction details form
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Transaction Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Amount (KSh)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Recipient/Sender',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Reference/Description',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.category),
                      ),
                      value: 'Income',
                      items: [
                        'Income',
                        'Food & Dining',
                        'Transport',
                        'Utilities',
                        'Entertainment',
                        'Shopping',
                        'Family',
                        'Friends',
                        'Other',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {},
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () {
                        // Show date picker
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Date & Time',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now()),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // SMS message (optional)
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'SMS Message (Optional)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.add),
                          label: const Text('Add SMS'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const TextField(
                      decoration: InputDecoration(
                        hintText: 'Paste M-Pesa SMS message here for automatic parsing...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Save Transaction'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionTypeButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final bool selected;

  const _TransactionTypeButton({
    required this.title,
    required this.icon,
    required this.color,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.2) : Colors.transparent,
          border: Border.all(
            color: selected ? color : Colors.grey,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: selected ? color : Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: selected ? color : Colors.grey,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Transaction Details Screen
  Color _getTransactionColor(String type) {
    switch (type) {
      case 'receive':
        return Colors.green;
      case 'send':
        return Colors.red;
      case 'paybill':
        return Colors.orange;
      case 'withdraw':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }
  
  IconData _getTransactionIcon(String type) {
    switch (type) {
      case 'receive':
        return Icons.arrow_downward;
      case 'send':
        return Icons.arrow_upward;
      case 'paybill':
        return Icons.receipt;
      case 'withdraw':
        return Icons.money;
      default:
        return Icons.swap_horiz;
    }
  }
  
  String _getTransactionTypeTitle(String type) {
    switch (type) {
      case 'receive':
        return 'Money Received';
      case 'send':
        return 'Money Sent';
      case 'paybill':
        return 'Bill Payment';
      case 'withdraw':
        return 'Withdrawal';
      default:
        return 'Transaction';
    }
  }
  
  String _getSampleSmsText(Transaction transaction) {
    switch (transaction.type) {
      case 'receive':
        return 'MPESA confirmation. KCB5XXXX confirmed. You have received Ksh${transaction.amount} from ${transaction.recipient} on ${DateFormat('dd/MM/yy').format(transaction.date)} at ${DateFormat('hh:mm a').format(transaction.date)}. New M-PESA balance is Ksh15,320.00.';
      case 'send':
        return 'MPESA confirmation. KCB5XXXX confirmed. You have sent Ksh${transaction.amount} to ${transaction.recipient} on ${DateFormat('dd/MM/yy').format(transaction.date)} at ${DateFormat('hh:mm a').format(transaction.date)}. New M-PESA balance is Ksh13,820.00.';
      case 'paybill':
        return 'MPESA confirmation. KCB5XXXX confirmed. Ksh${transaction.amount} paid to ${transaction.recipient}. on ${DateFormat('dd/MM/yy').format(transaction.date)} at ${DateFormat('hh:mm a').format(transaction.date)}. Ref. ${transaction.reference}. New M-PESA balance is Ksh14,820.00.';
      case 'withdraw':
        return 'Your M-PESA account was debited with Ksh${transaction.amount} on ${DateFormat('dd/MM/yy').format(transaction.date)} at ${DateFormat('hh:mm a').format(transaction.date)}. Use PIN at ATM to withdraw. New M-PESA balance is Ksh12,820.00.';
      default:
        return 'MPESA transaction of Ksh${transaction.amount} on ${DateFormat('dd/MM/yy').format(transaction.date)} at ${DateFormat('hh:mm a').format(transaction.date)}. Ref: ${transaction.reference}.';
    }
  }


class _DetailRow extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _DetailRow({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}