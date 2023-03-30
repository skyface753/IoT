import 'package:appwrite/models.dart';
import 'package:wardrobe_flutter/models/product.dart';

class Wardrobe {
  String $id;
  String fqdn;
  int maxColumns;
  int maxRows;

  Wardrobe(this.$id, this.fqdn, this.maxColumns, this.maxRows);

  Wardrobe.fromJson(Map<String, dynamic> json)
      : $id = json['id'],
        fqdn = json['fqdn'],
        maxColumns = json['max_columns'],
        maxRows = json['max_rows'];

  Wardrobe.fromAppwriteDocument(Document document)
      : $id = document.$id,
        fqdn = document.data['fqdn'],
        maxColumns = document.data['max_columns'],
        maxRows = document.data['max_rows'];
}
