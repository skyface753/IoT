class Product {
  int id;
  String name;
  String description;
  String? imagePath;
  int? borrowedNum; // borrowed_num;
  int inStock;

  Product(this.id, this.name, this.description, this.imagePath,
      this.borrowedNum, this.inStock);

  Product.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        imagePath = json['imagePath'],
        borrowedNum = json['borrowed_num'],
        inStock = json['in_stock'] != null ? int.parse(json['in_stock']) : 0;
}
