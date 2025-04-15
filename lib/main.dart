import 'package:flutter/material.dart';
import 'package:weza/screens/home_screen.dart';
import 'package:weza/storage/storage_provider.dart';
import 'package:weza/storage/mpesa_storage.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage
  final MessageStorage storage = getStorageImplementation();
  await storage.initialize();
  
  runApp(MyApp(storage: storage));
}

class MyApp extends StatelessWidget {
  final MessageStorage storage;
  
  const MyApp({Key? key, required this.storage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M-Pesa Message Analyzer',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(storage: storage),
    );
  }
}