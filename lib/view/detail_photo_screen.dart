import 'package:flutter/material.dart';
import 'package:gallery_app/components/confirmation_dialog.dart';
import 'package:gallery_app/controllers/detail_photo_controller.dart';
import 'package:gallery_app/view/home_screen.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:io';

class DetailImageScreen extends StatefulWidget {
  final int id;
  final String filePath;
  final int isFav;

  const DetailImageScreen({
    Key? key,
    required this.id,
    required this.filePath,
    required this.isFav,
  }) : super(key: key);

  @override
  _DetailImageScreenState createState() => _DetailImageScreenState();
}

class _DetailImageScreenState extends State<DetailImageScreen> {
  final DetailPhotoController _controller = DetailPhotoController();
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFav == 1; // Menginisialisasi status favorit
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
        backgroundColor: const Color.fromARGB(97, 253, 0, 0),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: PhotoView(
              imageProvider: FileImage(File(widget.filePath)),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered,
              backgroundDecoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
              ),
              basePosition: Alignment.center,
            ),
          ),
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildActionButton(
                    icon: Icons.delete,
                    label: "Hapus",
                    onPressed: () {
                      _showDeleteConfirmationDialog(context);
                    },
                  ),
                  const SizedBox(width: 10),
                  _buildActionButton(
                    icon: isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    label: "Suka",
                    onPressed: () async {
                      await _controller.changesFavorite(widget.id, isFavorite);
                      setState(() {
                        isFavorite = !isFavorite; // Toggle status favorit
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.black),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: 'Delete Photo',
          content: 'Anda yakin ingin menghapus foto ini?',
          onConfirm: () async {
            await _controller.deletePhotoById(widget.id);
            Navigator.of(context).pop();

            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    HomeScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          },
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }
}
