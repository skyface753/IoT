import 'package:appwrite/models.dart';
import 'package:wardrobe_flutter/models/product.dart';

class WardrobeProduct extends Product {
  int number; // Anzahl in Drawer
  int stowColumn;
  int stowRow;

  WardrobeProduct(
      {required String id,
      required String name,
      required String description,
      required this.number,
      String? imagePath,
      required this.stowColumn,
      required this.stowRow})
      : super(id, name, description, imagePath);

  WardrobeProduct.fromAppwriteDocument(Document document)
      : number = document.data['amount'],
        stowColumn = document.data['stow_column'],
        stowRow = document.data['stow_row'],
        super.fromAppwriteDocument(document);
}
