import 'package:flutter/material.dart';

import 'conversationInfo_screen.dart';

const _adaiOrange = Color(0xFFB5651D);

class ChatMessage {
  final String id;
  final String sender;
  final String role;
  final bool isMe;
  final String message;
  final String? imageUrl;
  final String time;
  final bool isRead;

  const ChatMessage({
    required this.id,
    required this.sender,
    required this.role,
    required this.isMe,
    required this.message,
    this.imageUrl,
    required this.time,
    this.isRead = false,
  });
}

class ConversationScreen extends StatefulWidget {
  final int? conversationId;
  final String projectName;
  final int onlineMembersCount;
  final List<String> memberAvatarUrls;

  const ConversationScreen({
    super.key,
    this.conversationId,
    this.projectName = 'Mobile App',
    this.onlineMembersCount = 8,
    this.memberAvatarUrls = const [
      'https://i.pravatar.cc/100?img=12',
      'https://i.pravatar.cc/100?img=32',
      'https://i.pravatar.cc/100?img=51',
      'https://i.pravatar.cc/100?img=45',
    ],
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final _messageController = TextEditingController();
  final String? _typingUser = 'Aina R.';

  final List<ChatMessage> _messages = const [
    ChatMessage(
      id: '1',
      sender: 'Aina R.',
      role: 'Designer',
      isMe: false,
      message: 'Bonjour l\'équipe 👋\nVoici la nouvelle maquette de l\'écran de connexion.',
      imageUrl: 'https://i.pravatar.cc/400?img=60',
      time: '09:21',
    ),
    ChatMessage(
      id: '2',
      sender: 'Moi',
      role: '',
      isMe: true,
      message: 'Super ! Le design est nickel 👌\nJe vais commencer l\'intégration.',
      time: '09:24',
      isRead: true,
    ),
    ChatMessage(
      id: '3',
      sender: 'Tovo M.',
      role: 'Développeur',
      isMe: false,
      message: 'Parfait, dis-moi si tu as besoin des endpoints.',
      time: '09:25',
    ),
    ChatMessage(
      id: '4',
      sender: 'Moi',
      role: '',
      isMe: true,
      message: 'Merci ! 🙏',
      time: '09:26',
      isRead: true,
    ),
    ChatMessage(
      id: '5',
      sender: 'Mirindra R.',
      role: 'Chef de projet',
      isMe: false,
      message: 'N\'oubliez pas de mettre à jour la checklist de la tâche.',
      time: '09:27',
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    // TODO: envoyer le message au backend / ajouter à la liste locale
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.projectName,
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 15),
            ),
            Text(
              '${widget.onlineMembersCount} membres en ligne',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 11.5),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: widget.memberAvatarUrls.length * 18.0 + 20,
            child: Stack(
              children: [
                for (int i = 0; i < widget.memberAvatarUrls.length; i++)
                  Positioned(
                    left: i * 18.0,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundImage: NetworkImage(widget.memberAvatarUrls[i]),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ConversationInfoScreen(
                    projectName: widget.projectName,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) => _MessageBubble(message: _messages[index]),
              ),
            ),
            if (_typingUser != null)
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 6),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '$_typingUser est en train d\'écrire...',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                ),
              ),
            _MessageInputBar(
              controller: _messageController,
              onSend: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage('https://i.pravatar.cc/100?u=${message.sender}'),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isMe)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4, left: 4),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: message.sender,
                            style: const TextStyle(
                              color: _adaiOrange,
                              fontWeight: FontWeight.w700,
                              fontSize: 12.5,
                            ),
                          ),
                          if (message.role.isNotEmpty)
                            TextSpan(
                              text: '  •  ${message.role}',
                              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                            ),
                        ],
                      ),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isMe ? const Color(0xFFDCF3DC) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: isMe ? null : Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.message,
                        style: const TextStyle(fontSize: 13.5, color: Colors.black87, height: 1.4),
                      ),
                      if (message.imageUrl != null) ...[
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            message.imageUrl!,
                            height: 120,
                            width: 220,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message.time,
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 10.5),
                      ),
                      if (isMe && message.isRead) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.done_all, size: 13, color: Color(0xFF3A9B54)),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _MessageInputBar({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      color: Colors.white,
      child: Row(
        children: [
          Icon(Icons.image_outlined, color: Colors.grey.shade500, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Écrire un message...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              color: _adaiOrange,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 18),
              onPressed: onSend,
            ),
          ),
        ],
      ),
    );
  }
}
