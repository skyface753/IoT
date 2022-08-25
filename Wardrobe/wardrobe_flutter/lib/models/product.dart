class Product {
  int id;
  int number; // Anzahl der Produkte im Drawer
  String name;
  String description;
  String? imagePath; // image_fk

  Product(this.id, this.number, this.name, this.description, this.imagePath);

  Product.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        number = json['number'],
        name = json['name'],
        description = json['description'],
        imagePath = json['genFilename'];
}
