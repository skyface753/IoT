import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:wardrobe_flutter/screens/add_product.dart';

Client appwriteClient = Client();
Storage appwriteStorage = Storage(appwriteClient);
Account appwriteAccount = Account(appwriteClient);
Databases appwriteDatabases =
    Databases(appwriteClient, databaseId: AppWriteCustom.dbID);
Teams appwriteTeams = Teams(appwriteClient);

class AppWriteCustom {
  static void initAppwrite() {
    appwriteClient
        .setEndpoint('https://appwrite.skyface.de/v1')
        .setProject('63027d145c40731b5f2a');
  }

  static String dbID = "63028270ec83c327644d";
  static String collectionID = "6302827d16cab7fd7d7a";
  static String productCollectionID = "6302873e0359281ee929";

  getAppwriteStorage() {
    return appwriteStorage;
  }

  getAppwriteAccount() {
    return appwriteAccount;
  }

  getAppwriteDatabases() {
    return appwriteDatabases;
  }

  getAppwriteTeams() {
    return appwriteTeams;
  }

  Future<Wardrobe> getWardrobe() async {
    // var docs =  await appwriteDatabases
    //     .listDocuments(collectionId: AppWriteCustom.collectionID)
    //     .then((value) {
    //   print(value.documents);
    //   return value.documents;
    // });
    return Wardrobe.test();
  }

  Future<List<Team>> getTeams() async {
    return await appwriteTeams.list().then((value) {
      return value.teams;
    });
  }
}

class Wardrobe {
  int colums;
  int rows;
  List<Product> products;

  Wardrobe(this.colums, this.rows, this.products);

  Wardrobe.test()
      : this.colums = 2,
        this.rows = 2,
        this.products = [
          Product("Test1", "test1",
              "https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png"),
          Product("Test2", "test2",
              "https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png"),
          Product("Test3", "test3",
              "https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png"),
          Product("Test4", "test4",
              "https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png"),
        ];

  Wardrobe.fromJson(Map<String, dynamic> json)
      : colums = json['colums'],
        rows = json['rows'],
        products = json['products'];

  Map<String, dynamic> toJson() => {
        'colums': colums,
        'rows': rows,
        'products': products,
      };
}
