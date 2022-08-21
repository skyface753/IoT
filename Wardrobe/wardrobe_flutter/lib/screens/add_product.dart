import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:wardrobe_flutter/appwrite.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class Product {
  String Title;
  String $id;
  String Image_ID;

  Product(this.Title, this.$id, this.Image_ID);

  Product.fromJson(Map<String, dynamic> json)
      : Title = json['Title'],
        $id = json['\$id'],
        Image_ID = json['Image_ID'];

  Map<String, dynamic> toJson() => {
        'Title': Title,
        '\$id': $id,
        'Image_ID': Image_ID,
      };
}

class _AddProductScreenState extends State<AddProductScreen> {
  Databases appwriteDatabases = AppWriteCustom().getAppwriteDatabases();

  Future<List<Product>> getAllProducts() async {
    DocumentList docs = await appwriteDatabases.listDocuments(
        collectionId: AppWriteCustom.productCollectionID);
    print("HI");
    List<Product> products = [];
    print(docs.documents.first.data);
    for (var doc in docs.documents) {
      print("Dhwud");
      try {
        products.add(Product.fromJson(doc.data));
      } catch (e) {
        print(e);
      }
      print("cjnjcbe");
    }
    print("HI2");
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Product'),
        ),
        body: Column(
          children: [
            FutureBuilder(
              future: getAllProducts(),
              builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data!.elementAt(index).Title),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ));
  }
}
