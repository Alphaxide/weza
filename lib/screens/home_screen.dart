// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:weza/models/mpesa_message.dart';
import 'package:weza/storage/mpesa_storage.dart';
import 'package:weza/utils/mpesa_parser.dart';

class HomeScreen extends StatefulWidget {
  final MessageStorage storage;
  
  const HomeScreen({Key? key, required this.storage}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _messageController = TextEditingController();
  MpesaMessage? _parsedMessage;
  bool _isLoading = false;
  String _errorMessage = '';
  List<MpesaMessage> _recentMessages = [];

  @override
  void initState() {
    super.initState();
    _loadRecentMessages();
  }

  Future<void> _loadRecentMessages() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final messages = await widget.storage.getAllMessages();
      setState(() {
        _recentMessages = messages;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load messages: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _parseAndSaveMessage() async {
    final message = _messageController.text.trim();
    
    if (message.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter an M-Pesa message';
      });
      return;
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      // Parse the message
      final parsedMessage = MpesaParser.parseSms(message);
      
      // Save to storage
      await widget.storage.insertMessage(parsedMessage);
      
      setState(() {
        _parsedMessage = parsedMessage;
        _isLoading = false;
      });
      
      // Clear the input
      _messageController.clear();
      
      // Refresh the message list
      _loadRecentMessages();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to parse message: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('M-Pesa Message Analyzer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input field for M-Pesa message
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Paste M-Pesa Message',
                border: OutlineInputBorder(),
                hintText: 'Paste your M-Pesa message here',
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            
            // Parse button
            ElevatedButton(
              onPressed: _isLoading ? null : _parseAndSaveMessage,
              child: _isLoading 
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Parse & Save Message'),
            ),
            
            // Error message
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            
            // Display parsed message
            if (_parsedMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Parsed Message',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Divider(),
                        Text('Transaction Code: ${_parsedMessage!.transactionCode}'),
                        Text('Type: ${_parsedMessage!.transactionType}'),
                        Text('Amount: KSh ${_parsedMessage!.amount}'),
                        Text('From/To: ${_parsedMessage!.senderOrReceiverName}'),
                        Text('Category: ${_parsedMessage!.category}'),
                        Text('Direction: ${_parsedMessage!.direction}'),
                        Text('Date: ${_parsedMessage!.transactionDate.toString()}'),
                      ],
                    ),
                  ),
                ),
              ),
            
            // Recent messages header
            Padding(
              padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
              child: Text(
                'Recent Messages',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            
            // Recent messages list
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : _recentMessages.isEmpty
                  ? const Center(child: Text('No messages yet'))
                  : ListView.builder(
                      itemCount: _recentMessages.length,
                      itemBuilder: (context, index) {
                        final message = _recentMessages[index];
                        return ListTile(
                          title: Text('${message.transactionType} - KSh ${message.amount}'),
                          subtitle: Text('${message.senderOrReceiverName} - ${message.transactionDate.toString()}'),
                          trailing: Text(message.category),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}