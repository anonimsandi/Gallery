import 'package:image_picker/image_picker.dart';
import '../database/database_helper.dart';

class PhotoController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> photos = [];
  List<int> selectedPhotos = [];

  Future<void> fetchPhotos() async {
    photos = await _dbHelper.getAllPhotos();
    print(photos);
  }

  Future<void> fetchFavPhotos() async {
    photos = await _dbHelper.getFavPhotos();
  }

  Future<void> pickAndUploadPhoto() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      for (var pickedFile in pickedFiles) {
        await _dbHelper.insertPhoto(pickedFile.path);
      }
      fetchPhotos();
    }
  }

  void toggleSelectPhoto(int id) {
    if (selectedPhotos.contains(id)) {
      selectedPhotos.remove(id);
    } else {
      selectedPhotos.add(id);
    }
  }

  Future<void> deleteSelectedPhotos() async {
    for (final id in selectedPhotos) {
      await _dbHelper.deletePhoto(id);
    }
    selectedPhotos.clear();
    fetchPhotos();
  }

}
