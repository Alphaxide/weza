import 'package:weza/utils/category_helper.dart';

import '../models/mpesa_message.dart';

class MpesaParser {
  static MpesaMessage parseSms(String message) {
    String transactionCode = '';
    String transactionType = '';
    String senderOrReceiverName = '';
    String phoneNumber = '';
    double amount = 0.0;
    double balance = 0.0;
    String account = '';
    DateTime transactionDate = DateTime.now();
    String direction = '';
    String category = 'Uncategorized';
    double transactionCost = 0.0;
    String agentDetails = '';
    bool isReversal = false;
    double fulizaAmount = 0.0;
    bool usedFuliza = false;
    bool isLoan = false;
    String loanType = '';

    // Check if the message contains transaction cost
    if (message.contains("Transaction cost, Ksh")) {
      final costRegex = RegExp(r'Transaction cost, Ksh[^0-9]*([0-9,.]+)');
      final costMatch = costRegex.firstMatch(message);
      if (costMatch != null) {
        final costStr = costMatch.group(1)!.replaceAll(',', '');
        transactionCost = double.tryParse(costStr) ?? 0.0;
      }
    }
    
    // Check for withdrawal fee pattern often used in ATM withdrawals
    else if (message.contains("withdrawal fee")) {
      final costRegex = RegExp(r'withdrawal fee Ksh[^0-9]*([0-9,.]+)');
      final costMatch = costRegex.firstMatch(message);
      if (costMatch != null) {
        final costStr = costMatch.group(1)!.replaceAll(',', '');
        transactionCost = double.tryParse(costStr) ?? 0.0;
      }
    }
    
    // For ATM withdrawals, if no explicit cost is found but it's an ATM transaction
    // Apply standard charges based on withdrawal amount
    // This is a fallback for ATM transactions with truncated messages
    else if (message.contains("withdrawn") && 
             (message.contains("ATM") || message.contains("QNM"))) {
      // We'll set the transaction cost after parsing the amount below
    }

    // Check if Fuliza was used
    if (message.contains("used Fuliza M-PESA")) {
      usedFuliza = true;
      final fulizaRegex = RegExp(r'used Fuliza M-PESA Ksh[^0-9]*([0-9,.]+)');
      final fulizaMatch = fulizaRegex.firstMatch(message);
      if (fulizaMatch != null) {
        final fulizaStr = fulizaMatch.group(1)!.replaceAll(',', '');
        fulizaAmount = double.tryParse(fulizaStr) ?? 0.0;
      }
    }

    // Check if this is a reversal message
    if (message.contains('successfully reversed')) {
      isReversal = true;
      
      // Extract the original transaction code
      final reversalCodeRegex = RegExp(r'transaction ([A-Z0-9]{10,12})');
      final reversalCodeMatch = reversalCodeRegex.firstMatch(message);
      if (reversalCodeMatch != null) {
        transactionCode = reversalCodeMatch.group(1)!;
      } else {
        // Try alternative pattern
        final altCodeRegex = RegExp(r'Your transaction ([A-Z0-9]{10,12})');
        final altCodeMatch = altCodeRegex.firstMatch(message);
        if (altCodeMatch != null) {
          transactionCode = altCodeMatch.group(1)!;
        }
      }
      
      transactionType = 'Reversal';
      direction = 'Incoming';
    } else {
      // Parse transaction code (typically starts with letters followed by numbers)
      final codeRegex = RegExp(r'([A-Z0-9]{10})');
      final codeMatch = codeRegex.firstMatch(message);
      if (codeMatch != null) {
        transactionCode = codeMatch.group(1)!;
      }
    }

    // Parse amount - handle multiple amount patterns
    RegExp amountRegex;
    RegExpMatch? amountMatch;
    
    if (message.startsWith("You have received")) {
      amountRegex = RegExp(r'received Ksh[^0-9]*([0-9,.]+)');
      amountMatch = amountRegex.firstMatch(message);
    } else if (message.contains("withdrawn")) {
      amountRegex = RegExp(r'Ksh[^0-9]*([0-9,.]+)(?:\s+withdrawn)');
      amountMatch = amountRegex.firstMatch(message);
    } else {
      amountRegex = RegExp(r'Ksh[^0-9]*([0-9,.]+)');
      amountMatch = amountRegex.firstMatch(message);
    }
    
    if (amountMatch != null) {
      final amountStr = amountMatch.group(1)!.replaceAll(',', '');
      amount = double.tryParse(amountStr) ?? 0.0;
    }
    
    // Now set ATM withdrawal fee if it's an ATM transaction and we haven't set the fee yet
    if (message.contains("withdrawn") && 
        (message.contains("ATM") || message.contains("QNM")) && 
        transactionCost == 0.0) {
      if (amount <= 1000) {
        transactionCost = 30.0;
      } else if (amount <= 2500) {
        transactionCost = 33.0;
      } else {
        transactionCost = 35.0;  // Standard fee for larger amounts
      }
    }

    // Parse balance


    final balanceRegex = RegExp(r'[Nn]ew [M-]*PESA balance is Ksh[^0-9]*([0-9,.]+)');
    final balanceMatch = balanceRegex.firstMatch(message);
    if (balanceMatch != null) {
      final balanceStr = balanceMatch.group(1)!.replaceAll(',', '');
      balance = double.tryParse(balanceStr) ?? 0.0;
    }

    // Parse date and time
    final dateRegex = RegExp(r'on (\d{1,2}/\d{1,2}/\d{2,4}) at (\d{1,2}:\d{2} [APM]{2})');
    final dateMatch = dateRegex.firstMatch(message);
    if (dateMatch != null) {
      final dateStr = dateMatch.group(1)!;
      final timeStr = dateMatch.group(2)!;
      
      final dateParts = dateStr.split('/');
      final day = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      final year = int.parse(dateParts[2].length == 2 ? '20${dateParts[2]}' : dateParts[2]);
      
      final timeParts = timeStr.split(':');
      var hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1].split(' ')[0]);
      final amPm = timeParts[1].split(' ')[1];
      
      if (amPm == 'PM' && hour < 12) {
        hour += 12;
      } else if (amPm == 'AM' && hour == 12) {
        hour = 0;
      }
      
      transactionDate = DateTime(year, month, day, hour, minute);
    }

    // Determine transaction type and direction based on message patterns
    if (isReversal) {
      // Already handled above
    } else if (message.startsWith("You have received") && message.contains("from") && 
               (message.contains('-Shwari') || message.contains('Loan'))) {
      transactionType = 'Loan Disbursement';
      direction = 'Incoming';
      isLoan = true;
      
      if (message.contains('M-Shwari')) {
        loanType = 'M-Shwari';
        senderOrReceiverName = 'M-Shwari';
      } else if (message.contains('KCB')) {
        loanType = 'KCB M-PESA';
        senderOrReceiverName = 'KCB M-PESA';
      }
    } else if (message.contains('received from Fuliza repayment')) {
      transactionType = 'Fuliza Repayment';
      direction = 'Incoming';
      senderOrReceiverName = 'Fuliza M-PESA';
    } else if (message.startsWith("You have received") || (message.contains("Confirmed") && message.contains("You have received"))) {
      transactionType = 'Receive Money';
      direction = 'Incoming';
      
      // Extract sender name
      final senderRegex = RegExp(r'from ([A-Za-z0-9\s-]+)(?:[\s]+\d{10,12})?');
      final senderMatch = senderRegex.firstMatch(message);
      if (senderMatch != null) {
        // Check if name contains phone number or date reference
        String name = senderMatch.group(1)!.trim();
        
        // Remove "on date" part if present
        if (name.contains(" on ")) {
          name = name.split(" on ")[0].trim();
        }
        
        // FIX: Extract only first two names
        final nameParts = name.split(' ');
        if (nameParts.length > 2) {
          senderOrReceiverName = '${nameParts[0]} ${nameParts[1]}';
        } else {
          senderOrReceiverName = name;
        }
      }
      
      // Extract phone number separately
      final phoneRegex = RegExp(r'from [A-Za-z0-9\s-]+\s+(\d{10,12})');
      final phoneMatch = phoneRegex.firstMatch(message);
      if (phoneMatch != null) {
        phoneNumber = phoneMatch.group(1)!;
      }
    } else if (message.contains('sent to') && message.contains('POCHI')) {
      transactionType = 'Pochi La Biashara';
      direction = 'Outgoing';
      
      // Extract business name
      final pochiRegex = RegExp(r'sent to ([A-Za-z\s]+ POCHI)');
      final pochiMatch = pochiRegex.firstMatch(message);
      if (pochiMatch != null) {
        senderOrReceiverName = pochiMatch.group(1)!.trim();
      }
    } else if (message.contains('sent to') && !message.contains('for account')) {
      transactionType = 'Send Money';
      direction = 'Outgoing';
      
      // Extract receiver name and phone if present
      final receiverRegex = RegExp(r'sent to ([A-Za-z0-9\s-]+)(?:[\s]+(\d{10,12}))?');
      final receiverMatch = receiverRegex.firstMatch(message);
      if (receiverMatch != null) {
        // Extract name without date reference
        String name = receiverMatch.group(1)!.trim();
        if (name.contains(" on ")) {
          name = name.split(" on ")[0].trim();
        }
        
        // FIX: Extract only first two names
        final nameParts = name.split(' ');
        if (nameParts.length > 2) {
          senderOrReceiverName = '${nameParts[0]} ${nameParts[1]}';
        } else {
          senderOrReceiverName = name;
        }
        
        // Extract phone number if available in the match
        if (receiverMatch.groupCount >= 2 && receiverMatch.group(2) != null) {
          phoneNumber = receiverMatch.group(2)!;
        }
      }
      
      // If we didn't get a phone number from the name, look for it separately
      if (phoneNumber.isEmpty) {
        final phoneRegex = RegExp(r'sent to [A-Za-z0-9\s-]+\s+(\d{10,12})');
        final phoneMatch = phoneRegex.firstMatch(message);
        if (phoneMatch != null) {
          phoneNumber = phoneMatch.group(1)!;
        }
      }
    } else if (message.contains('sent to') && message.contains('for account')) {
      transactionType = 'PayBill';
      direction = 'Outgoing';
      
      // Extract business name
      final businessRegex = RegExp(r'sent to ([A-Za-z0-9\s-]+) for account');
      final businessMatch = businessRegex.firstMatch(message);
      if (businessMatch != null) {
        senderOrReceiverName = businessMatch.group(1)!.trim();
      }
      
      // Extract account number - FIX: capture only the first string
      final accountRegex = RegExp(r'for account ([A-Za-z0-9-]+)(?:\s+|\s+via|\s+on)');
      final accountMatch = accountRegex.firstMatch(message);
      if (accountMatch != null) {
        account = accountMatch.group(1)!.trim();
      }
    } else if (message.contains('paid to') && message.contains('Till Number')) {
      transactionType = 'Buy Goods';
      direction = 'Outgoing';
      
      // Extract merchant name
      final merchantRegex = RegExp(r'paid to ([A-Za-z0-9\s-]+)');
      final merchantMatch = merchantRegex.firstMatch(message);
      if (merchantMatch != null) {
        // Extract name without date reference
        String name = merchantMatch.group(1)!.trim();
        if (name.contains(" on ")) {
          name = name.split(" on ")[0].trim();
        }
        senderOrReceiverName = name;
      }
      
      // Extract till number
      final tillRegex = RegExp(r'Till Number (\d+)');
      final tillMatch = tillRegex.firstMatch(message);
      if (tillMatch != null) {
        account = tillMatch.group(1)!;
      }
    } else if (message.contains('paid to')) {
      // Check for loan repayment first
      if (message.contains('-Shwari Loan') || message.contains('Loan')) {
        transactionType = 'Loan Repayment';
        direction = 'Outgoing';
        isLoan = true;
        
        // Determine loan type
        if (message.contains('M-Shwari')) {
          loanType = 'M-Shwari';
          senderOrReceiverName = 'M-Shwari';
        } else if (message.contains('KCB')) {
          loanType = 'KCB M-PESA';
          senderOrReceiverName = 'KCB M-PESA';
        } else {
          loanType = 'Other Loan';
        }
      } else {
        // General Buy Goods
        transactionType = 'Buy Goods';
        direction = 'Outgoing';
        
        // Extract merchant name
        final merchantRegex = RegExp(r'paid to ([A-Za-z0-9\s-]+)');
        final merchantMatch = merchantRegex.firstMatch(message);
        if (merchantMatch != null) {
          // Extract name without date reference
          String name = merchantMatch.group(1)!.trim();
          if (name.contains(" on ")) {
            name = name.split(" on ")[0].trim();
          }
          senderOrReceiverName = name;
        }
      }
    } else if (message.contains('bought') && message.contains('airtime')) {
      transactionType = 'Buy Airtime';
      direction = 'Outgoing';
    } else if (message.contains('withdrawn') && message.contains('Agent')) {
      transactionType = 'Withdraw Cash';
      direction = 'Outgoing';
      
      // Extract agent details
      final agentRegex = RegExp(r'Agent (\d+)(?:\s*-\s*([A-Za-z0-9\s-]+))?');
      final agentMatch = agentRegex.firstMatch(message);
      if (agentMatch != null) {
        account = agentMatch.group(1)!.trim();
        if (agentMatch.groupCount >= 2 && agentMatch.group(2) != null) {
          // Extract name without date reference
          String name = agentMatch.group(2)!.trim();
          if (name.contains(" on ")) {
            name = name.split(" on ")[0].trim();
          }
          agentDetails = name;
          senderOrReceiverName = name;
        }
      }
    } else if (message.contains('withdrawn') && (message.contains('ATM') || transactionCode.startsWith("QNM"))) {
      transactionType = 'ATM Withdrawal';
      direction = 'Outgoing';
      
      // Extract bank name
      final bankRegex = RegExp(r'from ([A-Za-z\s-]+) ATM');
      final bankMatch = bankRegex.firstMatch(message);
      if (bankMatch != null) {
        senderOrReceiverName = bankMatch.group(1)!.trim();
      } else if (message.contains("Co-op")) {
        senderOrReceiverName = "Co-op Bank";
      } else if (message.contains("KCB")) {
        senderOrReceiverName = "KCB Bank";
      } else if (message.contains("Equity")) {
        senderOrReceiverName = "Equity Bank"; 
      } else {
        senderOrReceiverName = "Bank ATM";  // Default if no specific bank is mentioned
      }
    } else if (message.contains('deposited') && (message.contains('Agent') || message.contains('by Agent'))) {
      transactionType = 'Deposit';
      direction = 'Incoming';
      
      // Extract agent details - handle different formats
      final agentRegex = RegExp(r'(?:Agent|by Agent) (\d+)(?:\s*-\s*([A-Za-z0-9\s-]+))?');
      final agentMatch = agentRegex.firstMatch(message);
      if (agentMatch != null) {
        account = agentMatch.group(1)!.trim();
        if (agentMatch.groupCount >= 2 && agentMatch.group(2) != null) {
          agentDetails = agentMatch.group(2)!.trim();
          senderOrReceiverName = agentDetails;
        }
      }
    }

    // Apply category based on transaction type and keywords
    category = CategoryHelper.suggestCategory(message, transactionType, senderOrReceiverName, account);

    return MpesaMessage(
      transactionCode: transactionCode,
      transactionType: transactionType,
      senderOrReceiverName: senderOrReceiverName,
      phoneNumber: phoneNumber,
      amount: amount,
      balance: balance,
      account: account,
      message: message,
      transactionDate: transactionDate,
      category: category,
      direction: direction,
      transactionCost: transactionCost,
      agentDetails: agentDetails,
      isReversal: isReversal,
      fulizaAmount: fulizaAmount,
      usedFuliza: usedFuliza,
      isLoan: isLoan,
      loanType: loanType,
    );
  }
}