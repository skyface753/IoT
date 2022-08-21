import 'package:appwrite/appwrite.dart';

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
}
