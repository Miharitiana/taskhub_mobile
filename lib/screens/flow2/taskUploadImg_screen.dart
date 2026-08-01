import 'package:flutter/material.dart';

const _adaiOrange = Color(0xFFB5651D);

class TaskUploadImgScreen extends StatefulWidget {
  const TaskUploadImgScreen({super.key});

  @override
  State<TaskUploadImgScreen> createState() => _TaskUploadImgScreenState();
}

class _TaskUploadImgScreenState extends State<TaskUploadImgScreen> {
  String? _previewUrl;
  String? _fileName;
  String? _fileSize;

  void _pickFromCamera() {
    // TODO: brancher image_picker -> ImagePicker().pickImage(source: ImageSource.camera)
    setState(() {
      _previewUrl = 'https://i.pravatar.cc/600?img=68';
      _fileName = 'capture_bug_login.png';
      _fileSize = '1.2 MB';
    });
  }

  void _pickFromGallery() {
    // TODO: brancher image_picker -> ImagePicker().pickImage(source: ImageSource.gallery)
    setState(() {
      _previewUrl = 'https://i.pravatar.cc/600?img=68';
      _fileName = 'capture_bug_login.png';
      _fileSize = '1.2 MB';
    });
  }

  void _removeSelection() {
    setState(() {
      _previewUrl = null;
      _fileName = null;
      _fileSize = null;
    });
  }

  void _sendPhoto() {
    if (_previewUrl == null) return;
    // TODO: envoyer le fichier au backend
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black87),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  const Text(
                    'Ajouter une photo',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    if (_previewUrl != null)
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              _previewUrl!,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: GestureDetector(
                              onTap: _removeSelection,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(color: Colors.black26, blurRadius: 4),
                                  ],
                                ),
                                child: const Icon(Icons.close, size: 18, color: Colors.black87),
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _PickOptionCard(
                            icon: Icons.camera_alt_outlined,
                            label: 'Appareil photo',
                            onTap: _pickFromCamera,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _PickOptionCard(
                            icon: Icons.image_outlined,
                            label: 'Galerie',
                            onTap: _pickFromGallery,
                          ),
                        ),
                      ],
                    ),
                    if (_fileName != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _fileName!,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _fileSize ?? '',
                                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: _removeSelection,
                              child: Icon(Icons.close, size: 18, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _previewUrl != null ? _sendPhoto : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _adaiOrange,
                    disabledBackgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Envoyer la photo',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PickOptionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PickOptionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 26, color: Colors.black87),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
