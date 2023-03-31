import 'package:wardrobe_flutter/models/product.dart';

class WardrobeProduct extends Product {
  int number; // Anzahl in Drawer
  int posColumn;
  int posRow;

  WardrobeProduct(String id, String name, String description, this.number,
      String imagePath, this.posColumn, this.posRow)
      : super(id, name, description, imagePath);

  WardrobeProduct.fromJson(Map<String, dynamic> json)
      : number = json['number'],
        posColumn = json['pos_column'],
        posRow = json['pos_row'],
        super.fromJson(json);
}
