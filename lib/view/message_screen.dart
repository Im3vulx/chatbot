import 'package:chatbot/service/message_service.dart';
import 'package:chatbot/view/conversation_screen.dart';
import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({
    super.key,
    required this.conversationId,
    required this.characterImage,
    required this.characterName,
  });

  final String conversationId;
  final String characterImage;
  final String characterName;

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen>
    with SingleTickerProviderStateMixin {
  final MessageService _apiMessageService = MessageService();
  List<Map<String, dynamic>> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  bool _isBotTyping = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late final ScrollController
      _scrollController; // Ajout du contrôleur de défilement

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);
    _scrollController =
        ScrollController(); // Initialisation du contrôleur de défilement
    _loadAllMessages(); // Charger les messages dès le début
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose(); // Disposer du contrôleur de défilement
    super.dispose();
  }

  Future<void> _loadAllMessages() async {
    final allMessages =
        await _apiMessageService.getAllMessageInfo(widget.conversationId);
    setState(() {
      _messages = allMessages;
    });
    // Défilement vers le bas après le chargement des messages
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  // Fonction pour faire défiler la liste jusqu'au bas
  void _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  // Envoi d'un message
  Future<void> _sendMessage(String message) async {
    setState(() {
      _isBotTyping = true;
    });
    await _apiMessageService.sendMessage(widget.conversationId, message);
    await _loadAllMessages(); // Recharger les messages après l'envoi
    setState(() {
      _isBotTyping = false;
    });
    _scrollToBottom(); // Défilement vers le bas après l'envoi du message
  }

  // Régénérer le dernier message
  Future<void> _regenerateLastMessage() async {
    setState(() {
      _isBotTyping = true;
    });
    await _apiMessageService.regenerateLastMessage(widget.conversationId);
    await _loadAllMessages(); // Recharger les messages après la régénération
    setState(() {
      _isBotTyping = false;
    });
    _scrollToBottom(); // Défilement vers le bas après la régénération
  }

  Widget _buildTypingIndicator() {
    return FadeTransition(
      opacity: _animation,
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('.'),
          SizedBox(width: 1),
          Text('.'),
          SizedBox(width: 1),
          Text('.'),
        ],
      ),
    );
  }

  Widget _buildMessageItem(Map<String, dynamic> message, bool isUserMessage) {
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUserMessage)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                backgroundImage: widget.characterImage != null
                    ? NetworkImage(
                        'https://mds.sprw.dev/image_data/${widget.characterImage}',
                      )
                    : null,
                child: widget.characterImage == null
                    ? const Icon(Icons.android)
                    : null,
              ),
            ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color:
                    isUserMessage ? const Color(0xFF137C8B) : Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(message['content'],
                      style: TextStyle(
                        color: isUserMessage ? Colors.white : Colors.black,
                      )),
                  if (message.containsKey('image_url') &&
                      message['image_url'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Image.network(
                        message['image_url'],
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.image_not_supported,
                          size: 50.0,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (isUserMessage)
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.person,
                size: 40,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ConversationScreen(),
              ),
            );
          },
        ),
        title: Text(widget.characterName),
        titleTextStyle: const TextStyle(
            color: Color(0xFF344D59),
            fontSize: 24,
            fontWeight: FontWeight.bold),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length + (_isBotTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= _messages.length) {
                  return _buildTypingIndicator();
                }
                final message = _messages[index];
                bool isUserMessage = message['is_sent_by_human'] as bool;
                return _buildMessageItem(message, isUserMessage);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: _regenerateLastMessage,
                  style: OutlinedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(12),
                    side: const BorderSide(color: Color(0xFF137C8B)),
                  ),
                  child: const Icon(Icons.refresh, color: Color(0xFF137C8B)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final message = _messageController.text.trim();
                    if (message.isNotEmpty) {
                      _sendMessage(message);
                      _messageController.clear();
                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                        _scrollToBottom();
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(12),
                    backgroundColor: const Color(0xFF137C8B), // Background color
                  ),
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
