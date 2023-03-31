// To Display, where a Product is located in the Wardrobe

import 'package:appwrite/models.dart';

class WardrobePos {
  String wardrobeFk;
  String wardrobeFQDN;
  String productFk;
  int stowColumn;
  int stowRow;
  int amount;

  WardrobePos(
      {required this.wardrobeFk,
      required this.productFk,
      required this.stowColumn,
      required this.stowRow,
      required this.amount,
      required this.wardrobeFQDN});

  WardrobePos.fromAppwriteDocument(Document document, String fqdn)
      : wardrobeFk = document.data['wardrobe_fk'],
        productFk = document.data['product_fk'],
        stowColumn = document.data['stow_column'],
        stowRow = document.data['stow_row'],
        amount = document.data['amount'],
        wardrobeFQDN = fqdn;

  @override
  String toString() {
    return "WardrobePos{wardrobeFqdn: $wardrobeFQDN, col: $stowColumn, row: $stowRow, amount: $amount}";
  }
}

// class ColRow {
//   int pos_column;
//   int pos_row;

//   ColRow(this.pos_column, this.pos_row);

//   ColRow.fromJson(Map<String, dynamic> json)
//       : pos_column = json['pos_column'],
//         pos_row = json['pos_row'];

//   @override
//   String toString() {
//     return "$pos_row, $pos_column";
//   }
// }

// class WardrobeColRow {
//   int wardrobeFk;
//   int posColumn;
//   int posRow;
//   int columns; // Refernzed to wardrobe (MAX columns)
//   int rows; // Refernzed to wardrobe (MAX rows)

//   WardrobeColRow(
//       {required this.wardrobeFk,
//       required this.posColumn,
//       required this.posRow,
//       required this.columns,
//       required this.rows});

//   factory WardrobeColRow.fromJson(Map<String, dynamic> json) {
//     return WardrobeColRow(
//       wardrobeFk: json['wardrobe_fk'],
//       posColumn: json['pos_column'],
//       posRow: json['pos_row'],
//       columns: json['columns'],
//       rows: json['rows'],
//     );
//   }
// }
