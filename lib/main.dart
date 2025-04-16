import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:weza/addbudget_screen.dart";
import "package:weza/budgetscreenui.dart";
import "package:weza/models/mpesa_message.dart";
import "package:weza/storage/mpesa_storage.dart";
import "package:weza/storage/storage_provider.dart";
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

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<MpesaMessage>> _messagesFuture;
  late MessageStorage _storage;
  
  @override
  void initState() {
    super.initState();
    _storage = getStorageImplementation();
    _messagesFuture = _loadMessages();
  }
  
  Future<List<MpesaMessage>> _loadMessages() async {
    await _storage.initialize();
    return await _storage.getAllMessages();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MpesaMessage>>(
      future: _messagesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }
        
        final messages = snapshot.data ?? [];
        return _buildDashboard(context, messages);
      },
    );
  }
  
  Widget _buildDashboard(BuildContext context, List<MpesaMessage> messages) {
    // Get current month data
    final now = DateTime.now();
    final currentMonthMessages = messages.where((msg) => 
      msg.transactionDate.month == now.month && 
      msg.transactionDate.year == now.year
    ).toList();
    
    // Calculate total expenses for current month
    final monthlyExpenses = currentMonthMessages
      .where((msg) => msg.direction == 'Outgoing')
      .fold(0.0, (total, msg) => total + msg.amount);
    
    // Calculate money in for the month
    final monthlyIncome = currentMonthMessages
      .where((msg) => msg.direction == 'Incoming')
      .fold(0.0, (total, msg) => total + msg.amount);
    
    // Get top 3 categories by spending
    final categorySpending = <String, double>{};
    for (final msg in currentMonthMessages) {
      if (msg.direction == 'Outgoing') {
        categorySpending[msg.category] = (categorySpending[msg.category] ?? 0) + msg.amount;
      }
    }
    
    final topCategories = categorySpending.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    final top3Categories = topCategories.take(3).toList();
    
    // Get recent transactions
    final recentTransactions = currentMonthMessages
      .take(4)
      .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Weza',
          style: TextStyle(
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
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () {
              // Month selector functionality would go here
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Monthly Expenses Header
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Month Expenses',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          DateFormat('MMMM yyyy').format(now),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'KSh ${NumberFormat('#,###.00').format(monthlyExpenses)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 36,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          monthlyExpenses > 0 ? '+4.2%' : '-2.1%',
                          style: TextStyle(
                            fontSize: 14,
                            color: monthlyExpenses > 0 ? Colors.red.shade300 : Colors.green.shade300,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Money In/Out Cards
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
                                'KSh ${NumberFormat('#,###.00').format(monthlyIncome)}',
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
                                'KSh ${NumberFormat('#,###.00').format(monthlyExpenses)}',
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
              
              // Recent Transactions
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
                            builder: (context) => const TransactionsScreen(),
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
              
              // Recent Transaction List
              if (recentTransactions.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                    child: Text(
                      'No transactions found for this month',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              else
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
                                color: _getTransactionColor(transaction.transactionType).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                _getTransactionIcon(transaction.transactionType),
                                color: _getTransactionColor(transaction.transactionType),
                                size: 24,
                              ),
                            ),
                            title: Text(
                              transaction.senderOrReceiverName.isNotEmpty ? 
                                transaction.senderOrReceiverName : transaction.transactionType,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text(
                                DateFormat('dd MMM, HH:mm').format(transaction.transactionDate),
                                style: TextStyle(
                                  fontSize: 13, 
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            trailing: Text(
                              '${transaction.direction == 'Incoming' ? '+' : '-'} KSh ${NumberFormat('#,###.00').format(transaction.amount)}',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: transaction.direction == 'Incoming' ? Colors.green[700] : Colors.red[700],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              
              const SizedBox(height: 32),
              
              // Top Categories
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: const Text(
                  'Top Spending Categories',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Top Categories visualization
              if (top3Categories.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                    child: Text(
                      'No spending categories found for this month',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              else
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
                          ...top3Categories.asMap().entries.map((entry) {
                            final index = entry.key;
                            final category = entry.value.key;
                            final amount = entry.value.value;
                            final percentage = (amount / monthlyExpenses * 100).round();
                            
                            // Assign different colors to each category
                            final colors = [
                              const Color(0xFF4E6AF3),
                              const Color(0xFF9C5DE0),
                              const Color(0xFFF5A623),
                            ];
                            
                            final icons = [
                              Icons.shopping_cart,
                              Icons.receipt_long,
                              Icons.account_balance_wallet,
                            ];
                            
                            return Column(
                              children: [
                                _CategoryProgressBar(
                                  category: category,
                                  amount: amount,
                                  percentage: percentage,
                                  color: colors[index % colors.length],
                                  icon: _getCategoryIcon(category) ?? icons[index % icons.length],
                                ),
                                if (index < top3Categories.length - 1)
                                  const SizedBox(height: 20),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                ),
              
              const SizedBox(height: 90), // Extra padding for bottom navigation
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
  
  Color _getTransactionColor(String transactionType) {
    switch (transactionType) {
      case 'Receive Money':
      case 'Deposit':
        return Colors.green;
      case 'Send Money':
      case 'Buy Goods':
      case 'PayBill':
      case 'Withdraw Cash':
      case 'ATM Withdrawal':
        return Colors.red;
      case 'Buy Airtime':
        return Colors.blue;
      case 'Loan Disbursement':
        return Colors.purple;
      case 'Loan Repayment':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
  
  IconData _getTransactionIcon(String transactionType) {
    switch (transactionType) {
      case 'Receive Money':
        return Icons.arrow_downward_rounded;
      case 'Send Money':
        return Icons.arrow_upward_rounded;
      case 'Buy Goods':
        return Icons.shopping_cart;
      case 'PayBill':
        return Icons.receipt;
      case 'Withdraw Cash':
        return Icons.account_balance;
      case 'ATM Withdrawal':
        return Icons.atm;
      case 'Buy Airtime':
        return Icons.phone_android;
      case 'Deposit':
        return Icons.payments;
      case 'Loan Disbursement':
        return Icons.monetization_on;
      case 'Loan Repayment':
        return Icons.money_off;
      default:
        return Icons.swap_horiz;
    }
  }
  
  IconData? _getCategoryIcon(String category) {
    switch (category) {
      case 'Food':
        return Icons.restaurant;
      case 'Transport':
        return Icons.directions_car;
      case 'Shopping':
        return Icons.shopping_cart;
      case 'Utilities':
        return Icons.bolt;
      case 'Entertainment':
        return Icons.movie;
      case 'Rent':
        return Icons.home;
      case 'Education':
        return Icons.school;
      case 'Health':
        return Icons.local_hospital;
      case 'Income':
        return Icons.account_balance_wallet;
      case 'Business':
        return Icons.business;
      default:
        return null;
    }
  }
  
  @override
  void dispose() {
    _storage.close();
    super.dispose();
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
            const Spacer(),
            Text(
              'KSh ${NumberFormat('#,###').format(amount)}',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: Colors.grey.withOpacity(0.1),
                  color: color,
                  minHeight: 10,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '$percentage%',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  late Future<List<MpesaMessage>> _messagesFuture;
  late MessageStorage _storage;
  String _selectedFilter = 'All';
  
  @override
  void initState() {
    super.initState();
    _storage = getStorageImplementation();
    _messagesFuture = _loadMessages();
  }
  
  Future<List<MpesaMessage>> _loadMessages() async {
    await _storage.initialize();
    final messages = await _storage.getAllMessages();
    
    // Sort by transaction date (most recent first)
    messages.sort((a, b) => b.transactionDate.compareTo(a.transactionDate));
    
    return messages;
  }
  
  List<MpesaMessage> _filterMessages(List<MpesaMessage> messages) {
    if (_selectedFilter == 'All') {
      return messages;
    } else if (_selectedFilter == 'Incoming') {
      return messages.where((msg) => msg.direction == 'Incoming').toList();
    } else if (_selectedFilter == 'Outgoing') {
      return messages.where((msg) => msg.direction == 'Outgoing').toList();
    } else {
      // Filter by transaction type if not a direction filter
      return messages.where((msg) => msg.transactionType == _selectedFilter).toList();
    }
  }

  // Helper method to get monthly summaries
  Map<String, double> _getMonthSummaries(List<MpesaMessage> messages) {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);
    
    // Filter transactions for current month
    final thisMonthMessages = messages.where((msg) {
      final msgDate = DateTime(msg.transactionDate.year, msg.transactionDate.month);
      return msgDate.isAtSameMomentAs(currentMonth);
    }).toList();
    
    // Calculate totals
    double totalAmount = 0;
    double incomingAmount = 0;
    double outgoingAmount = 0;
    
    for (final msg in thisMonthMessages) {
      if (msg.direction == 'Incoming') {
        incomingAmount += msg.amount;
      } else {
        outgoingAmount += msg.amount;
      }
      totalAmount += msg.amount;
    }
    
    return {
      'total': totalAmount,
      'in': incomingAmount,
      'out': outgoingAmount,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
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
      body: FutureBuilder<List<MpesaMessage>>(
        future: _messagesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          final messages = snapshot.data ?? [];
          
          if (messages.isEmpty) {
            return const Center(
              child: Text('No transactions found', style: TextStyle(color: Colors.grey)),
            );
          }
          
          // Calculate month summaries
          final monthlySummaries = _getMonthSummaries(messages);
          
          // Get unique transaction types for filter
          final transactionTypes = ['All', 'Incoming', 'Outgoing'];
          final uniqueTypes = messages
              .map((msg) => msg.transactionType)
              .toSet()
              .toList();
          transactionTypes.addAll(uniqueTypes);
          
          final filteredMessages = _filterMessages(messages);
          
          return SafeArea(
            child: Column(
              children: [
                // Gradient header extension with transaction summaries
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
                        label: 'This Month',
                        amount: monthlySummaries['total'] ?? 0.0,
                        icon: Icons.swap_horiz_rounded,
                        color: Colors.white,
                      ),
                      _TransactionSummaryItem(
                        label: 'In',
                        amount: monthlySummaries['in'] ?? 0.0,
                        icon: Icons.arrow_downward_rounded,
                        color: Colors.green.shade300,
                      ),
                      _TransactionSummaryItem(
                        label: 'Out',
                        amount: monthlySummaries['out'] ?? 0.0,
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
                      children: transactionTypes.map((type) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FilterChip(
                            selected: _selectedFilter == type,
                            label: Text(type),
                            onSelected: (selected) {
                              setState(() {
                                _selectedFilter = type;
                              });
                            },
                            selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                            checkmarkColor: Theme.of(context).primaryColor,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: _selectedFilter == type
                                    ? Theme.of(context).primaryColor.withOpacity(0.5)
                                    : Colors.grey.withOpacity(0.3),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
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
                        child: filteredMessages.isEmpty
                            ? const Center(
                                child: Text(
                                  'No transactions match the selected filter',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            : ListView.separated(
                                padding: EdgeInsets.zero,
                                itemCount: filteredMessages.length,
                                separatorBuilder: (context, index) => const Divider(
                                  height: 1,
                                  indent: 76,
                                  endIndent: 20,
                                  thickness: 0.5,
                                ),
                                itemBuilder: (context, index) {
                                  final transaction = filteredMessages[index];
                                  return ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    leading: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: _getTransactionColor(transaction.transactionType).withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Icon(
                                        _getTransactionIcon(transaction.transactionType),
                                        color: _getTransactionColor(transaction.transactionType),
                                        size: 24,
                                      ),
                                    ),
                                    title: Text(
                                      transaction.senderOrReceiverName.isNotEmpty ? 
                                        transaction.senderOrReceiverName : transaction.transactionType,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 4),
                                        if (transaction.account.isNotEmpty)
                                          Text(
                                            'Acc: ${transaction.account}',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 13,
                                            ),
                                          ),
                                        if (transaction.account.isNotEmpty)
                                          const SizedBox(height: 2),
                                        Text(
                                          DateFormat('dd MMM yyyy, HH:mm').format(transaction.transactionDate),
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: Text(
                                      '${transaction.direction == 'Incoming' ? '+' : '-'} KSh ${NumberFormat('#,###.00').format(transaction.amount)}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        color: transaction.direction == 'Incoming' ? Colors.green[700] : Colors.red[700],
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
          );
        },
      ),
    );
  }

  Color _getTransactionColor(String type) {
    switch (type) {
      case 'Receive Money':
      case 'Deposit':
        return Colors.green[700]!;
      case 'Send Money':
        return Colors.red[700]!;
      case 'PayBill':
        return const Color(0xFFF5A623); // Warmer orange
      case 'Withdraw Cash':
      case 'ATM Withdrawal':
        return const Color(0xFF9C5DE0); // Refined purple
      case 'Buy Goods':
        return Colors.blue[700]!;
      case 'Buy Airtime':
        return Colors.teal[700]!;
      case 'Loan Disbursement':
        return Colors.green[800]!;
      case 'Loan Repayment':
        return Colors.orange[800]!;
      case 'Reversal':
        return Colors.indigo[700]!;
      default:
        return const Color(0xFF4E6AF3); // More appealing blue
    }
  }

  IconData _getTransactionIcon(String type) {
    switch (type) {
      case 'Receive Money':
        return Icons.arrow_downward_rounded;
      case 'Send Money':
        return Icons.arrow_upward_rounded;
      case 'PayBill':
        return Icons.receipt_long_rounded;
      case 'Withdraw Cash':
      case 'ATM Withdrawal':
        return Icons.account_balance_wallet_rounded;
      case 'Buy Goods':
        return Icons.shopping_cart_rounded;
      case 'Buy Airtime':
        return Icons.phone_android_rounded;
      case 'Deposit':
        return Icons.payments_rounded;
      case 'Loan Disbursement':
        return Icons.monetization_on_rounded;
      case 'Loan Repayment':
        return Icons.money_off_csred_rounded;
      case 'Reversal':
        return Icons.restore_rounded;
      default:
        return Icons.swap_horiz_rounded;
    }
  }
  
  @override
  void dispose() {
    _storage.close();
    super.dispose();
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
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon, 
            color: color, 
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'KSh ${NumberFormat('#,###.00').format(amount)}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
// Transaction Details Screen
class TransactionDetailsScreen extends StatelessWidget {
  final MpesaMessage transaction;

  const TransactionDetailsScreen({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Transaction Details',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              
              // Transaction amount with icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _getStatusColor(transaction.direction).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  transaction.direction == 'Incoming' 
                      ? Icons.arrow_downward_rounded 
                      : Icons.arrow_upward_rounded,
                  color: _getStatusColor(transaction.direction),
                  size: 36,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Amount
              Text(
                '${transaction.direction == 'Incoming' ? '+' : '-'} KSh ${NumberFormat('#,###.00').format(transaction.amount)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: _getStatusColor(transaction.direction),
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Transaction type
              Text(
                transaction.transactionType,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              
              const SizedBox(height: 6),
              
              // Date
              Text(
                DateFormat('dd MMM yyyy, HH:mm').format(transaction.transactionDate),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Details card
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.white,
                child: Container(
                  padding: const EdgeInsets.all(20),
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
                      // Status row
                      _detailRow(
                        'Status',
                        'Completed',
                        Icons.check_circle_outline,
                        Colors.green,
                      ),
                      const SizedBox(height: 20),
                      
                      // Transaction code row
                      _detailRow(
                        'Transaction ID',
                        transaction.transactionCode,
                        Icons.confirmation_number_outlined,
                        Colors.blue,
                      ),
                      const SizedBox(height: 20),
                      
                      // Sender/Receiver row
                      _detailRow(
                        transaction.direction == 'Incoming' ? 'From' : 'To',
                        transaction.senderOrReceiverName.isNotEmpty 
                            ? transaction.senderOrReceiverName 
                            : 'Not specified',
                        Icons.person_outline,
                        Colors.indigo,
                      ),
                      
                      if (transaction.phoneNumber.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        // Phone number
                        _detailRow(
                          'Phone',
                          transaction.phoneNumber,
                          Icons.phone,
                          Colors.teal,
                        ),
                      ],
                      
                      if (transaction.account.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        // Account number
                        _detailRow(
                          'Account',
                          transaction.account,
                          Icons.account_balance_outlined,
                          Colors.amber[800]!,
                        ),
                      ],
                      
                      if (transaction.transactionCost > 0) ...[
                        const SizedBox(height: 20),
                        // Transaction cost
                        _detailRow(
                          'Transaction Fee',
                          'KSh ${NumberFormat('#,###.00').format(transaction.transactionCost)}',
                          Icons.attach_money,
                          Colors.orange,
                        ),
                      ],
                      
                      if (transaction.usedFuliza) ...[
                        const SizedBox(height: 20),
                        // Fuliza amount
                        _detailRow(
                          'Fuliza Used',
                          'KSh ${NumberFormat('#,###.00').format(transaction.fulizaAmount)}',
                          Icons.account_balance_wallet_outlined,
                          Colors.purple,
                        ),
                      ],
                      

                      const SizedBox(height: 20),
                      // Category
                      _detailRow(
                        'Category',
                        transaction.category,
                        Icons.category_outlined,
                        Colors.blue[800]!,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Original message card
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.white,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
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
                      const Text(
                        'Original Message',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        transaction.message,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[800],
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value, IconData icon, Color iconColor) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String direction) {
    return direction == 'Incoming' ? Colors.green[700]! : Colors.red[700]!;
  }
}

