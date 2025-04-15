import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:weza/storage/mpesa_storage.dart';
import 'package:weza/storage/hive_storage.dart';
import 'package:weza/storage/sqlite_storage.dart';

MessageStorage getStorageImplementation() {
  if (kIsWeb) {
    return HiveStorage();
  } else {
    return SqliteStorage();
  }
}