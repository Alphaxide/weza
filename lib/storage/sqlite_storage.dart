
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weza/storage/mpesa_storage.dart';
import '../models/mpesa_message.dart';

class SqliteStorage implements MessageStorage {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'mpesa_messages.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE mpesa_messages(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  transactionCode TEXT,
  transactionType TEXT,
  senderOrReceiverName TEXT,
  phoneNumber TEXT,
  amount REAL,
  balance REAL,
  account TEXT,
  message TEXT,
  transactionDate INTEGER,
  category TEXT,
  direction TEXT,
  transactionCost REAL DEFAULT 0.0,
  agentDetails TEXT DEFAULT '',
  isReversal INTEGER DEFAULT 0,
  fulizaAmount REAL DEFAULT 0.0,
  usedFuliza INTEGER DEFAULT 0,
  isLoan INTEGER DEFAULT 0,
  loanType TEXT DEFAULT ''
)
    ''');
  }

  @override
  Future<void> initialize() async {
    await database;
  }

  @override
  Future<int> insertMessage(MpesaMessage message) async {
    final db = await database;
    return await db.insert('mpesa_messages', message.toMap());
  }

  @override
  Future<List<MpesaMessage>> getAllMessages() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('mpesa_messages');
    return List.generate(maps.length, (i) {
      return MpesaMessage.fromMap(maps[i]);
    });
  }

  @override
  Future<MpesaMessage?> getMessage(int id) async {
    final db = await database;
    final maps = await db.query(
      'mpesa_messages',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return MpesaMessage.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<void> deleteMessage(int id) async {
    final db = await database;
    await db.delete(
      'mpesa_messages',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> updateMessage(MpesaMessage message) async {
    final db = await database;
    await db.update(
      'mpesa_messages',
      message.toMap(),
      where: 'id = ?',
      whereArgs: [message.id],
    );
  }

  @override
  Future<List<MpesaMessage>> getMessagesByCategory(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'mpesa_messages',
      where: 'category = ?',
      whereArgs: [category],
    );
    return List.generate(maps.length, (i) {
      return MpesaMessage.fromMap(maps[i]);
    });
  }

  @override
  Future<List<MpesaMessage>> getMessagesByTransactionType(String transactionType) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'mpesa_messages',
      where: 'transactionType = ?',
      whereArgs: [transactionType],
    );
    return List.generate(maps.length, (i) {
      return MpesaMessage.fromMap(maps[i]);
    });
  }

  @override
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
