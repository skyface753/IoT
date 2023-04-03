import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:wardrobe_flutter/components/products_list_tile.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:wardrobe_flutter/models/product.dart';
import 'package:wardrobe_flutter/models/wardrobe_col_pos.dart';
import 'package:wardrobe_flutter/services/api.dart';

class ShowAllProductsView extends StatefulWidget {
  const ShowAllProductsView({super.key});

  @override
  ShowAllProductsViewState createState() => ShowAllProductsViewState();
}

class ShowAllProductsViewState extends State<ShowAllProductsView> {
  // RealtimeSubscription? subscription;

  @override
  void initState() {
    // final realtime = Realtime(appwriteClient);
    // subscription = realtime.subscribe([
    //   'databases.$wardrobeDatabaseID.collections.$productCollectionID.documents'
    // ]);
    // subscription?.stream.listen((event) {
    //   print(event);
    //   if (mounted) {
    //     setState(() {});
    //   }
    // });
    super.initState();
  }

  // subscription cancel when widget is disposed
  @override
  void dispose() {
    // subscription?.close();
    super.dispose();
  }

  List<Product>? searchResultProducts = [];
  bool _showSearchedProducts = false;

  void search(String query) async {
    query = query.trim();
    final resultName = await appwriteDatabase.listDocuments(
        databaseId: wardrobeDatabaseID,
        collectionId: productCollectionID,
        queries: [
          Query.search('name', query),
          // Query.search('description', query),
        ]);
    final resultDescription = await appwriteDatabase.listDocuments(
        databaseId: wardrobeDatabaseID,
        collectionId: productCollectionID,
        queries: [
          // Query.search('name', query),
          Query.search('description', query),
        ]);
    final resultCombined = await appwriteDatabase.listDocuments(
        databaseId: wardrobeDatabaseID,
        collectionId: productCollectionID,
        queries: [
          Query.search('name', query),
          Query.search('description', query),
        ]);
    print(resultName);
    print(resultDescription);
    print(resultCombined.documents.toList().toString());

    // Merge results without duplicates (by id)
    List<Product> mergedResult = [];
    for (var i = 0; i < resultName.documents.length; i++) {
      mergedResult.add(Product.fromAppwriteDocument(resultName.documents[i]));
    }
    for (var i = 0; i < resultDescription.documents.length; i++) {
      final product =
          Product.fromAppwriteDocument(resultDescription.documents[i]);
      if (!mergedResult.any((element) => element.$id == product.$id)) {
        mergedResult.add(product);
      }
    }
    searchResultProducts = mergedResult;
    setState(() {
      _showSearchedProducts = true;
    });
  }

  void closeSearch() {
    setState(() {
      _showSearchedProducts = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApiService.getAllProducts(),
      builder: (context, AsyncSnapshot<List<Product>?> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No Products found'),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: ListView.builder(
              shrinkWrap: false,
              itemCount: _showSearchedProducts && searchResultProducts != null
                  ? searchResultProducts!.length
                  : snapshot.data!.length,
              itemBuilder: (context, index) {
                return ProductListTile(
                  // product: snapshot.data![index],
                  product: _showSearchedProducts && searchResultProducts != null
                      ? searchResultProducts![index]
                      : snapshot.data![index],
                  onTap: () async {
                    List<WardrobePos>? wardrobePos =
                        // await ApiService.getWardrobeProductPositions(
                        //     snapshot.data![index].$id);
                        await ApiService.getWardrobeProductPositions(
                            _showSearchedProducts &&
                                    searchResultProducts != null
                                ? searchResultProducts![index].$id
                                : snapshot.data![index].$id);
                    // PRINT
                    for (var i = 0; i < wardrobePos!.length; i++) {
                      print(wardrobePos[i].toString());
                    }
                    // _showBottomSheet(
                    //     context, wardrobePos, snapshot.data![index]);
                    _showBottomSheet(
                        context,
                        wardrobePos,
                        _showSearchedProducts && searchResultProducts != null
                            ? searchResultProducts![index]
                            : snapshot.data![index]);
                  },
                );
              },
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  void _showBottomSheet(
      BuildContext context, List<WardrobePos> wardrobePos, Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: Color.fromRGBO(0, 0, 0, 0.001),
            child: GestureDetector(
              onTap: () {},
              child: DraggableScrollableSheet(
                initialChildSize: 0.4,
                minChildSize: 0.2,
                maxChildSize: 0.75,
                builder: (_, controller) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(25.0),
                        topRight: const Radius.circular(25.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.remove,
                          color: Colors.grey[600],
                        ),
                        ProductAsRow(product: product, height: 80, width: 80),

                        // Row(
                        //   // Left picture from appwrite.getFilePreview if product.imageFileID is set
                        //   // Right product.name and product.description
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                        //   children: [
                        //     // ProductImage(
                        //     //   imageID: product.imageFileID,
                        //     //   height: 80,
                        //     //   width: 80,
                        //     // ),

                        //     Column(
                        //       children: [
                        //         Text(product.name,
                        //             style: TextStyle(fontSize: 20)),
                        //         Text(product.description,
                        //             style: TextStyle(fontSize: 15)),
                        //       ],
                        //     ),
                        //     ElevatedButton(
                        //         onPressed: () {
                        //           // TODO: Edit product
                        //           // Navigator.pushNamed(context, '/editProduct',
                        //           //     arguments: product);
                        //         },
                        //         child: Text("Edit"))
                        //   ],
                        // ),
                        Expanded(
                          child: ListView.builder(
                            controller: controller,
                            itemCount: wardrobePos.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                    "${wardrobePos[index].wardrobeFQDN} - ${wardrobePos[index].stowColumn}:${wardrobePos[index].stowRow} -> ${wardrobePos[index].amount}x"),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
