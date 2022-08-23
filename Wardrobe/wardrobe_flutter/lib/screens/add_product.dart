// import 'package:appwrite/appwrite.dart';
// import 'package:appwrite/models.dart';
// import 'package:flutter/material.dart';
// import 'package:wardrobe_flutter/appwrite.dart';

// class AddProductScreen extends StatefulWidget {
//   @override
//   _AddProductScreenState createState() => _AddProductScreenState();
// }

// class _AddProductScreenState extends State<AddProductScreen> {
//   Databases appwriteDatabases = AppWriteCustom().getAppwriteDatabases();

//   Future<List<Product>> getAllProducts() async {
//     DocumentList docs = await appwriteDatabases.listDocuments(
//         collectionId: AppWriteCustom.productCollectionID);
//     List<Product> products = [];
//     for (var doc in docs.documents) {
//       products.add(Product.fromJson(doc.data));
//     }
//     return products;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Add Product'),
//         ),
//         body: Column(
//           children: [
//             FutureBuilder(
//               future: getAllProducts(),
//               builder: (context, AsyncSnapshot<List<Product>> snapshot) {
//                 if (snapshot.hasData) {
//                   return ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: snapshot.data!.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: Text(snapshot.data!.elementAt(index).Title),
//                       );
//                     },
//                   );
//                 } else {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//               },
//             ),
//           ],
//         ));
//   }
// }
