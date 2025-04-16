// lib/storage/budget_storage_provider.dart
import 'package:flutter/foundation.dart' show kIsWeb;
import 'budget_storage.dart';
import 'budget_hive_storage.dart';
import 'budget_sqlite_storage.dart';

BudgetStorage getBudgetStorageImplementation() {
  if (kIsWeb) {
    return BudgetHiveStorage();
  } else {
    return BudgetSqliteStorage();
  }
}