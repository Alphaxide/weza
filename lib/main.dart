import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weza/models/mpesa_message.dart';
import 'package:weza/storage/storage_provider.dart';
import 'package:weza/utils/mpesa_parser.dart';
import 'package:weza/storage/message_storage.dart';// or storage_provider.dart if cross-platform

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = getStorageImplementation(); // Swapable backend
  await storage.initialize();
  runApp(MyApp(storage as MessageStorage));
}

class MyApp extends StatelessWidget {
  final MessageStorage storage;
  MyApp(this.storage);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M-PESA Parser Web',
      theme: ThemeData(primarySwatch: Colors.green),
      home: MpesaHomePage(storage),
    );
  }
}

class MpesaHomePage extends StatefulWidget {
  final MessageStorage storage;
  MpesaHomePage(this.storage);

  @override
  State<MpesaHomePage> createState() => _MpesaHomePageState();
}

class _MpesaHomePageState extends State<MpesaHomePage> {
  final TextEditingController _controller = TextEditingController();
  List<MpesaMessage> messages = [];

  void _parseAndSave() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final parsedMessage = MpesaParser.parseSms(text);
    await widget.storage.insertMessage(parsedMessage);
    _controller.clear();
    _loadMessages();
  }

  void _loadMessages() async {
    final allMessages = await widget.storage.getAllMessages();
    setState(() => messages = allMessages.reversed.toList());
  }

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('M-PESA Message Parser')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Paste your M-PESA message here...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: _parseAndSave,
              child: Text('Parse & Save'),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                for (var msg in messages) {
                  await widget.storage.deleteMessage(msg.id!);
                }
                _loadMessages();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Clear All'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: messages.isEmpty
                  ? Center(child: Text('No messages saved yet.'))
                  : ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        return Card(
                          child: ListTile(
                            title: Text(
                              '${msg.transactionType} - Ksh ${msg.amount.toStringAsFixed(2)}',
                            ),
                            subtitle: Text(
                              '${msg.transactionCode}\nTo/From: ${msg.senderOrReceiverName}',
                            ),
                            isThreeLine: true,
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
