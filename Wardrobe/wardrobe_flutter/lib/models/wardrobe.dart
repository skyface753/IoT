import 'package:wardrobe_flutter/models/product.dart';

class Wardrobe {
  int id;
  String fname;
  int columns;
  int rows;

  Wardrobe(this.id, this.fname, this.columns, this.rows);

  Wardrobe.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        fname = json['fname'],
        columns = json['columns'],
        rows = json['rows'];
}
