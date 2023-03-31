import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wardrobe_flutter/models/darwer_position.dart';
import 'package:wardrobe_flutter/models/wardrobe.dart';
import 'package:wardrobe_flutter/models/wardrobe_products.dart';
import 'package:wardrobe_flutter/screens/add_product_to_drawer.dart';
import 'package:wardrobe_flutter/services/api.dart';

class ShowSingleWardrobeDrawerScreen extends StatefulWidget {
  static const String routeName = '/wardrobe/show';

  const ShowSingleWardrobeDrawerScreen({Key? key}) : super(key: key);
  @override
  ShowSingleWardrobeDrawerScreenState createState() =>
      ShowSingleWardrobeDrawerScreenState();
}

class ShowSingleWardrobeDrawerScreenState
    extends State<ShowSingleWardrobeDrawerScreen> {
  @override
  void initState() {
    super.initState();
  }

  // List<WardrobeProduct>? _wardrobeProducts;
  // _getWardrobeProducts(int wardrobeId) async {
  //   if (_wardrobeProducts != null) {
  //     return;
  //   }
  //   await ApiService.getProductsByWardrobeId(wardrobeId.toString())
  //       .then((value) {
  //     setState(() {
  //       _wardrobeProducts = value ?? [];
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Wardrobe? currentWardrobe;
    try {
      currentWardrobe = ModalRoute.of(context)!.settings.arguments as Wardrobe;
      // _getWardrobeProducts(currentWardrobe.id);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    var size = MediaQuery.of(context).size;
/*24 is for notification bar on Android*/
    double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    double itemWidth = size.width / 2;
    if (currentWardrobe != null) {
      itemHeight =
          (size.height - kToolbarHeight - 24) / currentWardrobe.maxRows;
      itemWidth = size.width / currentWardrobe.maxColumns;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(currentWardrobe?.fqdn ?? 'No wardrobe'),
        ),
        body: currentWardrobe == null
            ? const Center(
                child: Text('No wardrobe selected'),
              )
            : FutureBuilder(
                future: ApiService.getProductsByWardrobeId(
                    currentWardrobe.$id.toString()),
                builder:
                    (context, AsyncSnapshot<List<WardrobeProduct>?> snapshot) {
                  if (kDebugMode) {
                    print("HI");
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text("Error"));
                  }
                  if (snapshot.hasData) {
                    return GridView.count(
                      crossAxisCount: currentWardrobe!.maxColumns,
                      // shrinkWrap: true,
                      childAspectRatio: itemWidth / itemHeight,

                      children: List.generate(
                          currentWardrobe.maxRows * currentWardrobe.maxColumns,
                          (index) {
                        return InkWell(
                          onTap: () {
                            if (kDebugMode) {
                              print(
                                  'column: ${index % currentWardrobe!.maxColumns} row: ${index / currentWardrobe.maxColumns}');
                            }
                            int column =
                                index % currentWardrobe!.maxColumns + 1;
                            int row = index ~/ currentWardrobe.maxColumns + 1;
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  List<WardrobeProduct> productsAtColAndRow =
                                      snapshot.data!
                                          .where((element) =>
                                              element.stowColumn == column &&
                                              element.stowRow == row)
                                          .toList();
                                  print("Products");
                                  for (var product in productsAtColAndRow) {
                                    print(product.name);
                                  }
                                  // return Text("HI");
                                  return SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.8,
                                    child: Column(children: [
                                      ListView.builder(
                                        itemCount: productsAtColAndRow.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          // return wardrobeProduct_ListTile(
                                          //     productsAtColAndRow[index]);
                                          return ListTile(
                                            title: Text(
                                                productsAtColAndRow[index]
                                                    .name),
                                            subtitle: Text(
                                                productsAtColAndRow[index]
                                                    .description
                                                    .toString()),
                                            trailing: Text(
                                                "Anzahl: ${productsAtColAndRow[index].number}"),
                                          );
                                        },
                                      ),
                                      IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                    context,
                                                    AddProductToDrawerScreen
                                                        .routeName,
                                                    arguments: DrawerPosition(
                                                        wardrobeId:
                                                            currentWardrobe!
                                                                .$id,
                                                        column: column,
                                                        row: row))
                                                .then((value) {
                                              setState(() {});
                                              // TODO: refresh
                                            });
                                          })
                                    ]),
                                  );
                                });
                            //  ROW = index ~/ rows + 1;
                            // Navigator.pushNamed(context, ShowProductsInDrawerScreen.routeName,
                            //     arguments: WardrobeProducts(
                            //         currentWardrobe!.id, currentWardrobe.fname, index));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: Center(
                              child: Text(
                                  '${(index % currentWardrobe!.maxColumns) + 1} : ${(index ~/ currentWardrobe.maxColumns) + 1}'),
                            ),
                          ),
                        );
                      }),
                      // FutureBuilder(
                      //     future: ApiService.getProductsByWardrobeId(
                      //         currentWardrobe!.id.toString()),
                      //     builder:
                      //         (context, AsyncSnapshot<List<WardrobeProduct>?> snapshot) {
                      //       if (snapshot.hasData) {
                      //         return GridView.builder(
                      //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //               crossAxisCount: currentWardrobe!.columns,
                      //               mainAxisExtent: 100),
                      //           itemCount: snapshot.data!.length,
                      //           itemBuilder: (context, index) {
                      //             return ListTile(
                      //               title: Text(snapshot.data![index].id.toString() +
                      //                   ' ' +
                      //                   snapshot.data![index].name),
                      //               subtitle:
                      //                   Text(snapshot.data![index].description.toString()),
                      //               trailing: Text("Anzahl: " +
                      //                   snapshot.data![index].number.toString() +
                      //                   " ColumnPos: " +
                      //                   snapshot.data![index].posColumn.toString() +
                      //                   " RowPos: " +
                      //                   snapshot.data![index].posRow.toString()),
                      //               onTap: () {
                      //                 // Navigator.pushNamed(context,
                      //                 //     '${ShowProductsInDrawerScreen.routeName}?drawerId=${snapshot.data![index].id}');
                      //               },
                      //             );
                      //           },
                      //         );
                      //       } else {
                      //         return const Center(
                      //           child: CircularProgressIndicator(),
                      //         );
                      //       }
                      //     }),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }));
  }
}
