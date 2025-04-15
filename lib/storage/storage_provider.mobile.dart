
import 'dart:io';
import 'package:weza/storage/mpesa_storage.dart';

import 'sqlite_storage.dart';

MessageStorage getStorageImplementation() {
  return SqliteStorage();
}