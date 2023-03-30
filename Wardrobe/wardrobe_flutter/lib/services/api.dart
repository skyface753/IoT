import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wardrobe_flutter/models/drawer.dart';
import 'package:wardrobe_flutter/models/product.dart';
import 'package:wardrobe_flutter/models/wardrobe.dart';
import 'package:wardrobe_flutter/models/wardrobe_col_pos.dart';
import 'package:wardrobe_flutter/models/wardrobe_products.dart';
import 'package:appwrite/appwrite.dart';

Client appwriteClient = Client();
Account appwriteAccount = Account(appwriteClient);
Databases appwriteDatabase = Databases(appwriteClient);

String wardrobeDbID = "6425b6ba3e077a2ed4d4";

String wardrobeProductXrefCollectionID = "6425b9a0aed622464ccf";
String procutCollectionID = "6425b84d23835cc3c652";
String wardrobeCollectionID = "6425b6c71990c4516480";

class ApiService {
  static Future<List<Wardrobe>?> getAllWardrobes() async {
    try {
      final docs = await appwriteDatabase.listDocuments(
        databaseId: wardrobeDbID,
        collectionId: wardrobeCollectionID,
      );
      print(docs);
      return docs.documents
          .map<Wardrobe>((json) => Wardrobe.fromAppwriteDocument(json))
          .toList();
    } catch (e) {
      print(e);
      return Future.error("Error getting wardrobes");
    }
  }

  static Future<bool> login(String email, String password) async {
    try {
      final response = await appwriteAccount.createEmailSession(
          email: email, password: password);
      print(response);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> register(String email, String password) async {
    try {
      final response = await appwriteAccount.create(
          userId: ID.unique(), email: email, password: password);
      print(response);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<List<WardrobeProduct>?> getProductsByWardrobeId(
      String wardrobeId) async {
    // try {
    //   final response =
    //       await http.post(Uri.parse(host + "/wardrobe/productsById"), body: {
    //     "wardrobeId": wardrobeId,
    //   });

    //   if (response.statusCode == 200) {
    //     var returnResponse = json.decode(response.body);
    //     print(returnResponse);
    //     return returnResponse
    //         .map<WardrobeProduct>((json) => WardrobeProduct.fromJson(json))
    //         .toList();
    //   } else {
    //     print("ERROR");
    //     print(response.statusCode);
    //     throw Exception('Failed to load post');
    //   }
    // } catch (e) {
    //   print(e);
    //   return null;
    // }
  }

  static Future<bool> createProduct(
      String name, String description, int? imageFk) async {
    return true;
    // print("Name: $name");
    // print("Description: $description");
    // print("Image_fk: $imageFk");
    // late var body;

    // if (imageFk != null) {
    //   body = {
    //     "name": name,
    //     "description": description,
    //     "image_fk": imageFk.toString(),
    //   };
    // } else {
    //   body = {
    //     "name": name,
    //     "description": description,
    //   };
    // }
    // final response =
    //     await http.post(Uri.parse(host + "/product/create"), body: body);
    // print(response.body);
    // if (response.statusCode == 200) {
    //   var returnResponse = json.decode(response.body);
    //   print(returnResponse);
    //   return returnResponse['success'];
    // } else {
    //   return false;
    // }
  }

  static Future<List<Product>?> getAllProducts() async {
    // try {
    //   final response = await http.post(Uri.parse(host + "/product/all"),
    //       body: {}, headers: {"authorization": apiKey});

    //   if (response.statusCode == 200) {
    //     var returnResponse = json.decode(response.body);
    //     print(returnResponse);
    //     return returnResponse
    //         .map<Product>((json) => Product.fromJson(json))
    //         .toList();
    //   } else {
    //     print("ERROR");
    //     throw Exception('Failed to load post');
    //   }
    // } catch (e) {
    //   print(e);
    //   return null;
    // }
  }

  static Future<bool> createWardrobe(String name, int columns, int rows) async {
    return true;
    // final response =
    //     await http.post(Uri.parse(host + "/wardrobe/create"), body: {
    //   "fname": name,
    //   "columns": columns.toString(),
    //   "rows": rows.toString(),
    // }, headers: {
    //   "authorization": apiKey
    // });
    // print(response.body);
    // if (response.statusCode == 200) {
    //   var returnResponse = json.decode(response.body);
    //   print(returnResponse);
    //   return returnResponse['success'];
    // } else {
    //   return false;
    // }
  }

  static Future<bool> addProductToDrawer(
      int productId, String wardrobeId, int column, int row, int number) async {
    return true;
    // final response =
    //     await http.post(Uri.parse(host + "/product/addProductToDrawer"), body: {
    //   "productId": productId.toString(),
    //   "wardrobeId": wardrobeId.toString(),
    //   "column": column.toString(),
    //   "row": row.toString(),
    //   "number": number.toString(),
    // }, headers: {
    //   "authorization": apiKey
    // });
    // print(response.body);
    // if (response.statusCode == 200) {
    //   var returnResponse = json.decode(response.body);
    //   print(returnResponse);
    //   return returnResponse['success'];
    // } else {
    //   return false;
    // }
  }

  static Future<List<WardrobePos>?> lightLEDByProductId(int productId) async {
    // final response = await http.post(
    //     Uri.parse(host + "/product/lightLEDByProductId"),
    //     body: {"productId": productId.toString()},
    //     headers: {"authorization": apiKey});
    // // print(response.body);
    // if (response.statusCode == 200) {
    //   var returnResponse = json.decode(response.body);
    //   returnResponse = returnResponse['drawerByWardrobe'];
    //   print(returnResponse);
    //   Map<String, dynamic> map = returnResponse;
    /*
      {
        "1": {
            "wardrobe_fk": 1,
            "columns": 2,
            "rows": 4,
            "drawers": [
                {
                    "pos_column": 1,
                    "pos_row": 1
                },
                {
                    "pos_column": 1,
                    "pos_row": 2
                }
            ]
        },
        "2": {
            "wardrobe_fk": 2,
            "columns": 6,
            "rows": 3,
            "drawers": [
                {
                    "pos_column": 1,
                    "pos_row": 1
                }
            ]
        }
    }
      */
    //   List<WardrobePos> wardrobePosList = [];
    //   map.forEach((key, value) {
    //     print("Key: $key");
    //     print("Value: $value");
    //     print("Value: ${value['drawers']}");
    //     wardrobePosList.add(WardrobePos.fromJson(value));
    //     // List<DrawerPos> drawerPosList = [];
    //     // value['drawers'].forEach((drawer) {
    //     //   drawerPosList.add(DrawerPos(
    //     //       pos_column: drawer['pos_column'],
    //     //       pos_row: drawer['pos_row'],
    //     //       number: drawer['number']));
    //     // });
    //     // wardrobePosList.add(WardrobePos(
    //     //     wardrobe_fk: value['wardrobe_fk'],
    //     //     columns: value['columns'],
    //     //     rows: value['rows'],
    //     //     drawers: drawerPosList));
    //   });
    //   return wardrobePosList;
    //   // List<WardrobePos> list = [];
    //   // for (var i = 0; i < returnResponse.length; i++) {
    //   //   list.add(WardrobePos.fromJson(returnResponse[i]));
    //   // }
    //   // return list;
    //   // return returnResponse
    //   //     .map<WardrobePos>((json) => WardrobePos.fromJson(json))
    //   //     .toList();
    //   // print(returnResponse);
    //   // return returnResponse['drawer'];
    // } else {
    //   return null;
    // }
  }

  // static Future<List<Product>?> getProductsByDrawerId(String drawerId) async {
  //   try {
  //     final response = await http
  //         .post(Uri.parse(host + "/product/by-drawer/" + drawerId), body: {});

  //     if (response.statusCode == 200) {
  //       var returnResponse = json.decode(response.body);
  //       print(returnResponse);
  //       return returnResponse
  //           .map<Product>((json) => Product.fromJson(json))
  //           .toList();
  //     } else {
  //       print("ERROR");
  //       print(response.statusCode);
  //       throw Exception('Failed to load post');
  //     }
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }
}
