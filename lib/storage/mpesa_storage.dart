
import 'package:weza/models/mpesa_message.dart';

abstract class MessageStorage {
  Future<void> initialize();
  Future<int> insertMessage(MpesaMessage message);
  Future<List<MpesaMessage>> getAllMessages();
  Future<MpesaMessage?> getMessage(int id);
  Future<void> deleteMessage(int id);
  Future<void> updateMessage(MpesaMessage message);
  Future<List<MpesaMessage>> getMessagesByCategory(String category);
  Future<List<MpesaMessage>> getMessagesByTransactionType(String transactionType);
  Future<void> close();
}