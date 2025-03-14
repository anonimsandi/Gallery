import 'package:gallery_app/controllers/photo_controller.dart';
import 'package:gallery_app/database/database_helper.dart';

class DetailPhotoController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final PhotoController _controller = PhotoController();

  Future<void> deletePhotoById(int id) async {
    await _dbHelper.deletePhoto(id);
  }
  
  Future<void> changesFavorite(int id, bool isFav) async {
    await _dbHelper.setFav(id, isFav);
    _controller.fetchFavPhotos();
  }
}