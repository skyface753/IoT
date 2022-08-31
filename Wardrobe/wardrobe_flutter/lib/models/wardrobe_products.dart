class WardrobeProduct {
  int id;
  String name;
  String description;
  int number;
  String? genFilename;
  int posColumn;
  int posRow;

  WardrobeProduct(this.id, this.name, this.description, this.number,
      this.genFilename, this.posColumn, this.posRow);

  WardrobeProduct.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        number = json['number'],
        genFilename = json['genFilename'],
        posColumn = json['pos_column'],
        posRow = json['pos_row'];
}
