// To Display, where a Product is located in the Wardrobe

class WardrobePos {
  int wardrobeFk;
  String fname;
  int columns;
  int rows;
  List<ColRow> colRow;

  WardrobePos(
      this.wardrobeFk, this.fname, this.columns, this.rows, this.colRow);

  WardrobePos.fromJson(Map<String, dynamic> json)
      : wardrobeFk = json['wardrobe_fk'],
        fname = json['fname'],
        columns = json['columns'],
        rows = json['rows'],
        colRow = json['drawers']
            .map<ColRow>((json) => ColRow.fromJson(json))
            .toList();

  @override
  String toString() {
    return "WardrobePos{wardrobeFk: $wardrobeFk, columns: $columns, rows: $rows, colRow: ${colRow.toString()}}";
  }
}

class ColRow {
  int pos_column;
  int pos_row;

  ColRow(this.pos_column, this.pos_row);

  ColRow.fromJson(Map<String, dynamic> json)
      : pos_column = json['pos_column'],
        pos_row = json['pos_row'];

  @override
  String toString() {
    return "$pos_row, $pos_column";
  }
}

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
