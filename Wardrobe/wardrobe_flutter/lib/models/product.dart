import 'package:appwrite/models.dart';

class Product {
  String $id;
  String name;
  String description;
  String? imageFileID;
  // int? borrowedNum; // borrowed_num;
  // int inStock;

  Product(this.$id, this.name, this.description, this.imageFileID);

  Product.fromJson(Map<String, dynamic> json)
      : $id = json['id'],
        name = json['name'],
        description = json['description'],
        imageFileID = json['imageFileID'];

  Product.fromAppwriteDocument(Document document)
      : $id = document.$id,
        name = document.data['name'],
        description = document.data['description'],
        imageFileID = document.data['imageFileID'];
}
