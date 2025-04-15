
class CategoryHelper {
  static const Map<String, List<String>> categoryKeywords = {
    'Food': ['restaurant', 'food', 'cafe', 'eatery', 'takeaway', 'dinner', 'lunch', 'breakfast', 'pizza', 'burger', 'coffee'],
    'Transport': ['uber', 'bolt', 'taxi', 'fare', 'matatu', 'bus', 'transport', 'ride', 'car'],
    'Shopping': ['supermarket', 'mall', 'shop', 'store', 'market', 'purchase', 'buy'],
    'Utilities': ['water', 'electricity', 'power', 'wifi', 'internet', 'gas', 'utility', 'bill'],
    'Entertainment': ['movie', 'cinema', 'theatre', 'ticket', 'show', 'concert', 'game', 'netflix', 'spotify'],
    'Rent': ['rent', 'house', 'apartment', 'landlord', 'tenant', 'lease'],
    'Education': ['school', 'fee', 'tuition', 'college', 'university', 'course', 'class', 'training'],
    'Health': ['hospital', 'doctor', 'clinic', 'pharmacy', 'medicine', 'medical', 'health'],
    'Income': ['salary', 'payment', 'deposit', 'income', 'revenue', 'commission', 'wage'],
    'Business': ['business', 'investment', 'capital', 'profit', 'stock', 'share'],
  };

  static String suggestCategory(String message, String transactionType, String counterpartyName, String account) {
    // First, check if it's income
    if (transactionType == 'Receive Money') {
      return 'Income';
    }
    
    // Convert message to lowercase for easier matching
    message = message.toLowerCase();
    counterpartyName = counterpartyName.toLowerCase();
    account = account.toLowerCase();
    
    // Search for keywords in the message
    for (final category in categoryKeywords.keys) {
      for (final keyword in categoryKeywords[category]!) {
        if (message.contains(keyword) || counterpartyName.contains(keyword) || account.contains(keyword)) {
          return category;
        }
      }
    }
    
    // Default categories based on transaction type
    switch (transactionType) {
      case 'Buy Goods':
        return 'Shopping';
      case 'PayBill':
        return 'Utilities';
      case 'Send Money':
        return 'Personal';
      default:
        return 'Uncategorized';
    }
  }
}
