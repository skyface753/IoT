import 'package:wardrobe_flutter/models/product.dart';
import 'package:wardrobe_flutter/models/wardrobe.dart';
import 'package:wardrobe_flutter/models/wardrobe_col_pos.dart';
import 'package:wardrobe_flutter/models/wardrobe_products.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';

Client appwriteClient = Client();
Account appwriteAccount = Account(appwriteClient);
Databases appwriteDatabase = Databases(appwriteClient);
Storage appwriteStorage = Storage(appwriteClient);

String wardrobeDatabaseID = "6425b6ba3e077a2ed4d4";

String productCollectionID = "6425b84d23835cc3c652";
String wardrobeCollectionID = "6425b6c71990c4516480";
String wardrobeProductXrefCollectionID = "6425b9a0aed622464ccf";

String productImageBucketID = "64269512a77339ffe0cb";

class ApiService {
  static Future<List<Wardrobe>?> getAllWardrobes() async {
    try {
      final docs = await appwriteDatabase.listDocuments(
        databaseId: wardrobeDatabaseID,
        collectionId: wardrobeCollectionID,
      );
      return docs.documents
          .map<Wardrobe>((json) => Wardrobe.fromAppwriteDocument(json))
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      return Future.error("Error getting wardrobes");
    }
  }

  static Future<bool> login(String email, String password) async {
    try {
      final response = await appwriteAccount.createEmailSession(
          email: email, password: password);
      return true;
    } catch (e) {
      debugPrint(e.toString());
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
      debugPrint(e.toString());
      return false;
    }
  }

  static Future<List<WardrobeProduct>?> getProductsByWardrobeId(
      String wardrobeId) async {
    try {
      final docs = await appwriteDatabase.listDocuments(
        databaseId: wardrobeDatabaseID,
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
          databaseId: wardrobeDatabaseID,
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
      debugPrint(e.toString());
      return Future.error("Error getting products");
    }
  }

  static Future<String> uploadFile(InputFile file) async {
    try {
      final response = await appwriteStorage.createFile(
          bucketId: productImageBucketID, fileId: ID.unique(), file: file);

      return response.$id;
    } catch (e) {
      debugPrint(e.toString());
      return Future.error("Error uploading file");
    }
  }

  static Future<bool> createProduct(
      String name, String description, String? imageFileID) async {
    try {
      final response = await appwriteDatabase.createDocument(
        databaseId: wardrobeDatabaseID,
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
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  static Future<List<Product>?> getAllProducts() async {
    try {
      final docs = await appwriteDatabase.listDocuments(
        databaseId: wardrobeDatabaseID,
        collectionId: productCollectionID,
      );
      // print(docs);
      return docs.documents
          .map<Product>((json) => Product.fromAppwriteDocument(json))
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      return Future.error("Error getting wardrobes");
    }
  }

  static Future<bool> createWardrobe(
      String fqdn, int maxColumns, int maxRows) async {
    try {
      final response = await appwriteDatabase.createDocument(
        databaseId: wardrobeDatabaseID,
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
      debugPrint(e.toString());
      return Future.error("Error creating wardrobe");
    }
  }

  static Future<bool> addProductToDrawer(String productId, String wardrobeId,
      int column, int row, int amount) async {
    try {
      // Check if product already exists in drawer
      final exists = await appwriteDatabase.listDocuments(
          databaseId: wardrobeDatabaseID,
          collectionId: wardrobeProductXrefCollectionID,
          queries: [
            Query.equal("product_fk", productId),
            Query.equal("wardrobe_fk", wardrobeId),
            Query.equal("stow_column", column),
            Query.equal("stow_row", row),
          ]);
      if (exists.documents.isNotEmpty) {
        debugPrint(exists.documents.length.toString() + " entries found");
        if (exists.documents.length > 1) {
          debugPrint("More than one entry found");
          // Zusammenfassen
          try {
            int totalAmount = 0;
            for (var doc in exists.documents) {
              var amount = doc.data["amount"];
              debugPrint("Amount: " + amount.toString());
              totalAmount += int.parse(amount.toString());
            }
            // Update amount
            final response = await appwriteDatabase.updateDocument(
              databaseId: wardrobeDatabaseID,
              collectionId: wardrobeProductXrefCollectionID,
              documentId: exists.documents[0].$id,
              data: {
                "amount": totalAmount,
              },
            );
            // Delete all other entries
            for (var doc in exists.documents) {
              if (doc.$id != exists.documents[0].$id) {
                final response = await appwriteDatabase.deleteDocument(
                  databaseId: wardrobeDatabaseID,
                  collectionId: wardrobeProductXrefCollectionID,
                  documentId: doc.$id,
                );
              }
            }
            print(response);
            return true;
          } catch (e) {
            debugPrint(e.toString());
            return false;
          }
        } else {
          // Update amount
          final response = await appwriteDatabase.updateDocument(
            databaseId: wardrobeDatabaseID,
            collectionId: wardrobeProductXrefCollectionID,
            documentId: exists.documents[0].$id,
            data: {
              "amount": exists.documents[0].data["amount"] + amount,
            },
          );
          print(response);
          return true;
        }
      } else {
        // Create new entry
        final response = await appwriteDatabase.createDocument(
          databaseId: wardrobeDatabaseID,
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
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  static Future<List<WardrobePos>?> getWardrobeProductPositions(
      String productId) async {
    try {
      final docs = await appwriteDatabase.listDocuments(
          databaseId: wardrobeDatabaseID,
          collectionId: wardrobeProductXrefCollectionID,
          queries: [
            Query.equal("product_fk", productId),
          ]);
      if (docs.documents.isEmpty) {
        debugPrint("No products found");
        return [];
      }
      List<String> wardrobeIds = [];
      for (var doc in docs.documents) {
        wardrobeIds.add(doc.data["wardrobe_fk"]);
      }
      if (wardrobeIds.isEmpty) {
        debugPrint("No wardrobes found");
        return [];
      }
      final wardrobes = await appwriteDatabase.listDocuments(
          databaseId: wardrobeDatabaseID,
          collectionId: wardrobeCollectionID,
          queries: [
            Query.equal("\$id", wardrobeIds),
          ]);
      List<WardrobePos> wardrobePos = [];
      for (var doc in docs.documents) {
        try {
          var wardrobe = wardrobes.documents
              .firstWhere((element) => element.$id == doc.data["wardrobe_fk"]);
          wardrobePos.add(
              WardrobePos.fromAppwriteDocument(doc, wardrobe.data["fqdn"]));
        } catch (e) {
          debugPrint(e.toString());
          wardrobePos.add(
              WardrobePos.fromAppwriteDocument(doc, "Error fetching wardrobe"));
        }
      }
      return wardrobePos;
    } catch (e) {
      debugPrint(e.toString());
      return Future.error("Error getting wardrobes");
    }
  }
}
