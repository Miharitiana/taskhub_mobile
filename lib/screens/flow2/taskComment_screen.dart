import 'package:flutter/material.dart';

import 'taskUploadImg_screen.dart';

const _adaiOrange = Color(0xFFB5651D);

class Comment {
  final String author;
  final String avatarUrl;
  final String timestamp;
  final String message;
  final String? imageUrl;
  final int likeCount;

  const Comment({
    required this.author,
    required this.avatarUrl,
    required this.timestamp,
    required this.message,
    this.imageUrl,
    this.likeCount = 0,
  });
}

class TaskCommentScreen extends StatefulWidget {
  const TaskCommentScreen({super.key});

  @override
  State<TaskCommentScreen> createState() => _TaskCommentScreenState();
}

class _TaskCommentScreenState extends State<TaskCommentScreen> {
  final _commentController = TextEditingController();

  final List<Comment> _comments = [
    const Comment(
      author: 'Mirindra R.',
      avatarUrl: 'https://i.pravatar.cc/100?img=12',
      timestamp: '25/06/2026 à 14:30',
      message: 'J\'ai commencé l\'intégration de la vue UI. Tout avance comme prévu.',
      imageUrl: 'https://i.pravatar.cc/400?img=60',
      likeCount: 2,
    ),
    const Comment(
      author: 'Aina R.',
      avatarUrl: 'https://i.pravatar.cc/100?img=45',
      timestamp: '25/06/2026 à 15:10',
      message: 'Super ! N\'oublie pas le mode sombre.',
      likeCount: 1,
    ),
    const Comment(
      author: 'Tovo M.',
      avatarUrl: 'https://i.pravatar.cc/100?img=51',
      timestamp: '25/06/2026 à 15:45',
      message: 'Je vais préparer les endpoints pour l\'authentification.',
    ),
    const Comment(
      author: 'Mirindra R.',
      avatarUrl: 'https://i.pravatar.cc/100?img=12',
      timestamp: 'Aujourd\'hui à 09:21',
      message: 'L\'intégration est presque terminée. Je fais les tests maintenant.',
    ),
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _sendComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _comments.add(
        Comment(
          author: 'Moi',
          avatarUrl: 'https://i.pravatar.cc/100?img=8',
          timestamp: 'À l\'instant',
          message: text,
        ),
      );
      _commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        title: const Text(
          'Commentaires',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _comments.length,
                itemBuilder: (context, index) => _CommentBubble(comment: _comments[index]),
              ),
            ),
            _CommentInputBar(
              controller: _commentController,
              onSend: _sendComment,
            ),
          ],
        ),
      ),
    );
  }
}

class _CommentBubble extends StatelessWidget {
  final Comment comment;

  const _CommentBubble({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(comment.avatarUrl),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        comment.author,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        comment.timestamp,
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    comment.message,
                    style: const TextStyle(fontSize: 13.5, color: Colors.black87, height: 1.4),
                  ),
                  if (comment.imageUrl != null) ...[
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        comment.imageUrl!,
                        height: 130,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                  if (comment.likeCount > 0) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.thumb_up, size: 14, color: _adaiOrange),
                        const SizedBox(width: 4),
                        Text(
                          '${comment.likeCount}',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _CommentInputBar({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: 'Écrire un commentaire...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const TaskUploadImgScreen(),
                        ),
                      );
                    },
                    child: Icon(Icons.attach_file, color: Colors.grey.shade500, size: 20),
                  ),
                ],
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
