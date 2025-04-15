class MpesaMessage {
  final int? id; // nullable for new messages
  final String transactionCode;
  final String transactionType;
  final String senderOrReceiverName;
  final String phoneNumber;
  final double amount;
  final double balance;
  final String account;
  final String message;
  final DateTime transactionDate;
  final String category;
  final String direction;
  final double transactionCost;
  final String agentDetails;
  final bool isReversal;
  final double fulizaAmount;
  final bool usedFuliza;
  final bool isLoan;
  final String loanType;

  MpesaMessage({
    this.id,
    required this.transactionCode,
    required this.transactionType,
    required this.senderOrReceiverName,
    required this.phoneNumber,
    required this.amount,
    required this.balance,
    required this.account,
    required this.message,
    required this.transactionDate,
    required this.category,
    required this.direction,
    this.transactionCost = 0.0,
    this.agentDetails = '',
    this.isReversal = false,
    this.fulizaAmount = 0.0,
    this.usedFuliza = false,
    this.isLoan = false,
    this.loanType = '',
  });

  // Convert MpesaMessage to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'transactionCode': transactionCode,
      'transactionType': transactionType,
      'senderOrReceiverName': senderOrReceiverName,
      'phoneNumber': phoneNumber,
      'amount': amount,
      'balance': balance,
      'account': account,
      'message': message,
      'transactionDate': transactionDate.millisecondsSinceEpoch,
      'category': category,
      'direction': direction,
      'transactionCost': transactionCost,
      'agentDetails': agentDetails,
      'isReversal': isReversal ? 1 : 0, // SQLite doesn't have boolean type
      'fulizaAmount': fulizaAmount,
      'usedFuliza': usedFuliza ? 1 : 0,
      'isLoan': isLoan ? 1 : 0,
      'loanType': loanType,
    };
  }

  // Create MpesaMessage from Map (from database)
  factory MpesaMessage.fromMap(Map<String, dynamic> map) {
    return MpesaMessage(
      id: map['id'],
      transactionCode: map['transactionCode'],
      transactionType: map['transactionType'],
      senderOrReceiverName: map['senderOrReceiverName'],
      phoneNumber: map['phoneNumber'],
      amount: map['amount'],
      balance: map['balance'],
      account: map['account'],
      message: map['message'],
      transactionDate: DateTime.fromMillisecondsSinceEpoch(map['transactionDate']),
      category: map['category'],
      direction: map['direction'],
      transactionCost: map['transactionCost'] ?? 0.0,
      agentDetails: map['agentDetails'] ?? '',
      isReversal: map['isReversal'] == 1,
      fulizaAmount: map['fulizaAmount'] ?? 0.0,
      usedFuliza: map['usedFuliza'] == 1,
      isLoan: map['isLoan'] == 1,
      loanType: map['loanType'] ?? '',
    );
  }

  // Copy with method for updates
  MpesaMessage copyWith({
    int? id,
    String? transactionCode,
    String? transactionType,
    String? senderOrReceiverName,
    String? phoneNumber,
    double? amount,
    double? balance,
    String? account,
    String? message,
    DateTime? transactionDate,
    String? category,
    String? direction,
    double? transactionCost,
    String? agentDetails,
    bool? isReversal,
    double? fulizaAmount,
    bool? usedFuliza,
    bool? isLoan,
    String? loanType,
  }) {
    return MpesaMessage(
      id: id ?? this.id,
      transactionCode: transactionCode ?? this.transactionCode,
      transactionType: transactionType ?? this.transactionType,
      senderOrReceiverName: senderOrReceiverName ?? this.senderOrReceiverName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      amount: amount ?? this.amount,
      balance: balance ?? this.balance,
      account: account ?? this.account,
      message: message ?? this.message,
      transactionDate: transactionDate ?? this.transactionDate,
      category: category ?? this.category,
      direction: direction ?? this.direction,
      transactionCost: transactionCost ?? this.transactionCost,
      agentDetails: agentDetails ?? this.agentDetails,
      isReversal: isReversal ?? this.isReversal,
      fulizaAmount: fulizaAmount ?? this.fulizaAmount,
      usedFuliza: usedFuliza ?? this.usedFuliza,
      isLoan: isLoan ?? this.isLoan,
      loanType: loanType ?? this.loanType,
    );
  }
}