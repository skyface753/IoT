class Product {
  int id;
  int number; // Anzahl der Produkte im Drawer
  int stock; // Anzahl der Produkte im Lager
  String name;
  String description;
  String imagePath; // image_path

  Product(this.id, this.number, this.stock, this.name, this.description,
      this.imagePath);

  Product.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        number = json['number'],
        stock = json['stock'],
        name = json['name'],
        description = json['description'],
        imagePath = json['image_path'];
}
