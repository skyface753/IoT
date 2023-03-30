class Product {
  int $id;
  String name;
  String description;
  String? imagePathReplaceWithStorageID;
  // int? borrowedNum; // borrowed_num;
  // int inStock;

  Product(this.$id, this.name, this.description,
      this.imagePathReplaceWithStorageID);

  Product.fromJson(Map<String, dynamic> json)
      : $id = json['id'],
        name = json['name'],
        description = json['description'],
        imagePathReplaceWithStorageID = json['imagePath'];
  // borrowedNum = json['borrowed_num'],
  // inStock = json['in_stock'] != null ? int.parse(json['in_stock']) : 0;
}
