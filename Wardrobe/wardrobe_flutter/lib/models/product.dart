class Product {
  int id;
  String name;
  String description;
  String? imagePath; // genFilename;
  int borrowedNum; // borrowed_num;
  int inStock;

  Product(this.id, this.name, this.description, this.imagePath,
      this.borrowedNum, this.inStock);

  Product.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        imagePath = json['genFilename'],
        borrowedNum = json['borrowed_num'],
        inStock = json['in_stock'];
}
