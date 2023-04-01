import 'package:appwrite/models.dart';

class Wardrobe {
  String $id;
  String fqdn;
  int maxColumns;
  int maxRows;

  Wardrobe(this.$id, this.fqdn, this.maxColumns, this.maxRows);

  Wardrobe.fromAppwriteDocument(Document document)
      : $id = document.$id,
        fqdn = document.data['fqdn'],
        maxColumns = document.data['max_columns'],
        maxRows = document.data['max_rows'];
}
