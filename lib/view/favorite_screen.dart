import 'package:flutter/material.dart';
import 'package:gallery_app/components/bottom_navigation_bar.dart';
import 'package:gallery_app/components/confirmation_dialog.dart';
import 'package:gallery_app/components/shimmer_image.dart';
import 'package:gallery_app/controllers/photo_controller.dart';
import 'package:gallery_app/view/detail_photo_screen.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final PhotoController _controller = PhotoController();
  int _currentIndex = 1;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  Future<void> _loadPhotos() async {
    await _controller.fetchFavPhotos();
    setState(() {
      _isLoading = false;
    });
  }

  void _toggleSelectPhoto(int id) {
    setState(() {
      _controller.toggleSelectPhoto(id);
    });
  }

  Future<void> _deleteSelectedPhotos() async {
    await _controller.deleteSelectedPhotos();
    Navigator.of(context).pop();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Favourite',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        actions: [
          if (_controller.selectedPhotos.isNotEmpty)
            IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => showDialog(
                      context: context,
                      builder: (context) {
                        return ConfirmationDialog(
                          title: 'Are you sure?',
                          content:
                              'Anda yakin ingin menghapus foto ini? This action cannot be undone.',
                          onConfirm: _deleteSelectedPhotos,
                          onCancel: () => Navigator.of(context).pop(),
                        );
                      },
                    )),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _controller.photos.isEmpty
              ? const Center(child: Text('Kosong.'))
              : GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _controller.photos.length,
                  itemBuilder: (context, index) {
                    final photo = _controller.photos[index];
                    final isSelected =
                        _controller.selectedPhotos.contains(photo['id']);

                    return GestureDetector(
                      onLongPress: () => _toggleSelectPhoto(photo['id']),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected
                                    ? Colors.blue
                                    : Colors.transparent,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: ShimmerImage(
                              filePath: photo['filePath'],
                              width: double.infinity,
                              height: double.infinity,
                              onTap: () => _controller.selectedPhotos.isEmpty
                                  ? Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            DetailImageScreen(
                                          id: photo['id'],
                                          filePath: photo['filePath'],
                                          isFav: photo['isFav'],
                                        ),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration:
                                            Duration.zero,
                                      ),
                                    )
                                  : _toggleSelectPhoto(photo['id']),
                            ),
                          ),
                          if (isSelected)
                            const Positioned(
                              top: 8,
                              right: 8,
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.blue,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
      bottomNavigationBar: BottomNavigationBarComponent(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
