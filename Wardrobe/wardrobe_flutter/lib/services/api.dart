import 'package:wardrobe_flutter/models/product.dart';
import 'package:wardrobe_flutter/models/wardrobe.dart';
import 'package:wardrobe_flutter/models/wardrobe_col_pos.dart';
import 'package:wardrobe_flutter/models/wardrobe_products.dart';
import 'package:appwrite/appwrite.dart';

Client appwriteClient = Client();
Account appwriteAccount = Account(appwriteClient);
Databases appwriteDatabase = Databases(appwriteClient);
Storage appwriteStorage = Storage(appwriteClient);

String wardrobeDbID = "6425b6ba3e077a2ed4d4";

String productCollectionID = "6425b84d23835cc3c652";
String wardrobeCollectionID = "6425b6c71990c4516480";
String wardrobeProductXrefCollectionID = "6425b9a0aed622464ccf";

String productImageBucketID = "64269512a77339ffe0cb";

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
    try {
      final docs = await appwriteDatabase.listDocuments(
        databaseId: wardrobeDbID,
        collectionId: wardrobeProductXrefCollectionID,
        queries: [
          Query.equal("wardrobe_fk", wardrobeId),
        ],
      );
      // {product_fk: 64269d26709933b1d7df, wardrobe_fk: 6425bfcbcdd7c255ded8, stow_column: 1, stow_row: 1, amount: 15, $id: 6426b0a3dd7298cf0467, $createdAt: 2023-03-31T10:06:27.907+00:00, $updatedAt: 2023-03-31T10:06:27.907+00:00, $permissions: [read("user:6425bf616245fd85be99"), update("user:6425bf616245fd85be99"), delete("user:6425bf616245fd85be99")], $collectionId: 6425b9a0aed622464ccf, $databaseId: 6425b6ba3e077a2ed4d4}
      List<WardrobeProduct> products = [];
      for (var doc in docs.documents) {
        // Get the product
        final productDoc = await appwriteDatabase.getDocument(
          databaseId: wardrobeDbID,
          collectionId: productCollectionID,
          documentId: doc.data['product_fk'],
        );
        WardrobeProduct wardrobeProduct = WardrobeProduct(
          description: productDoc.data['description'],
          name: productDoc.data['name'],
          id: productDoc.$id,
          imagePath: productDoc.data['image_path'],
          number: doc.data['amount'],
          stowColumn: doc.data['stow_column'],
          stowRow: doc.data['stow_row'],
        );
        products.add(wardrobeProduct);
      }

      return products;
    } catch (e) {
      print(e);
      return Future.error("Error getting products");
    }
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

  static Future<String> uploadFile(InputFile file) async {
    try {
      final response = await appwriteStorage.createFile(
          bucketId: productImageBucketID, fileId: ID.unique(), file: file);
      print(response);
      return response.$id;
    } catch (e) {
      print(e);
      return Future.error("Error uploading file");
    }
  }

  static Future<bool> createProduct(
      String name, String description, String? imageFileID) async {
    try {
      final response = await appwriteDatabase.createDocument(
        databaseId: wardrobeDbID,
        collectionId: productCollectionID,
        documentId: ID.unique(),
        data: imageFileID != null
            ? {
                "name": name,
                "description": description,
                "imageFileID": imageFileID,
              }
            : {
                "name": name,
                "description": description,
              },
      );
      print(response);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
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
    try {
      final docs = await appwriteDatabase.listDocuments(
        databaseId: wardrobeDbID,
        collectionId: productCollectionID,
      );
      // print(docs);
      return docs.documents
          .map<Product>((json) => Product.fromAppwriteDocument(json))
          .toList();
    } catch (e) {
      print(e);
      return Future.error("Error getting wardrobes");
    }
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

  static Future<bool> createWardrobe(
      String fqdn, int maxColumns, int maxRows) async {
    try {
      final response = await appwriteDatabase.createDocument(
        databaseId: wardrobeDbID,
        collectionId: wardrobeCollectionID,
        documentId: ID.unique(),
        data: {
          "fqdn": fqdn,
          "max_columns": maxColumns,
          "max_rows": maxRows,
        },
      );
      print(response);
      return true;
    } catch (e) {
      print(e);
      return Future.error("Error creating wardrobe");
    }
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

  static Future<bool> addProductToDrawer(String productId, String wardrobeId,
      int column, int row, int amount) async {
    try {
      // Check if product already exists in drawer
      final exists = await appwriteDatabase.listDocuments(
          databaseId: wardrobeDbID,
          collectionId: wardrobeProductXrefCollectionID,
          queries: [
            Query.equal("product_fk", productId),
            Query.equal("wardrobe_fk", wardrobeId),
            Query.equal("stow_column", column),
            Query.equal("stow_row", row),
          ]);
      if (exists.documents.isNotEmpty) {
        // Update amount
        final response = await appwriteDatabase.updateDocument(
          databaseId: wardrobeDbID,
          collectionId: wardrobeProductXrefCollectionID,
          documentId: exists.documents[0].$id,
          data: {
            "amount": exists.documents[0].data["amount"] + amount,
          },
        );
        print(response);
        return true;
      } else {
        // Create new entry
        final response = await appwriteDatabase.createDocument(
          databaseId: wardrobeDbID,
          collectionId: wardrobeProductXrefCollectionID,
          documentId: ID.unique(),
          data: {
            "product_fk": productId,
            "wardrobe_fk": wardrobeId,
            "stow_column": column,
            "stow_row": row,
            "amount": amount,
          },
        );
        print(response);
        return true;
      }
      // final response = await appwriteDatabase.createDocument(
      //   databaseId: wardrobeDbID,
      //   collectionId: wardrobeProductXrefCollectionID,
      //   documentId: ID.unique(),
      //   data: {
      //     "product_fk": productId,
      //     "wardrobe_fk": wardrobeId,
      //     "stow_column": column,
      //     "stow_row": row,
      //     "amount": amount,
      //   },
      // );
      // print(response);
      // return true;
    } catch (e) {
      print(e);
      return false;
    }
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

  static Future<List<WardrobePos>?> getWardrobeProductPositions(
      String productId) async {
    try {
      final docs = await appwriteDatabase.listDocuments(
          databaseId: wardrobeDbID,
          collectionId: wardrobeProductXrefCollectionID,
          queries: [
            Query.equal("product_fk", productId),
          ]);
      final wardrobes = await appwriteDatabase.listDocuments(
        databaseId: wardrobeDbID,
        collectionId: wardrobeCollectionID,
      );
      List<WardrobePos> wardrobePos = [];
      for (var doc in docs.documents) {
        var wardrobe = wardrobes.documents
            .firstWhere((element) => element.$id == doc.data["wardrobe_fk"]);
        wardrobePos
            .add(WardrobePos.fromAppwriteDocument(doc, wardrobe.data["fqdn"]));
      }
      return wardrobePos;
    } catch (e) {
      print(e);
      return Future.error("Error getting wardrobes");
    }
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
