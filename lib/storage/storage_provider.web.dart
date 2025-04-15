
import 'dart:html' as html;
import 'package:weza/storage/mpesa_storage.dart';

import 'hive_storage.dart';

MessageStorage getStorageImplementation() {
  return HiveStorage();
}
