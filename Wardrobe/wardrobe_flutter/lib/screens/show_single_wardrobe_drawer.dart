import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:wardrobe_flutter/models/drawer.dart';
import 'package:wardrobe_flutter/models/wardrobe.dart';
import 'package:wardrobe_flutter/models/wardrobe_products.dart';
import 'package:wardrobe_flutter/screens/show_products_in_drawer.dart';
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
      print(e);
    }
    var size = MediaQuery.of(context).size;
/*24 is for notification bar on Android*/
    double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    double itemWidth = size.width / 2;
    if (currentWardrobe != null) {
      itemHeight = (size.height - kToolbarHeight - 24) / currentWardrobe.rows;
      itemWidth = size.width / currentWardrobe.columns;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(currentWardrobe?.fname ?? 'No wardrobe'),
        ),
        body: currentWardrobe == null
            ? Center(
                child: Text('No wardrobe selected'),
              )
            : FutureBuilder(
                future: ApiService.getProductsByWardrobeId(
                    currentWardrobe.id.toString()),
                builder:
                    (context, AsyncSnapshot<List<WardrobeProduct>?> snapshot) {
                  return GridView.count(
                    crossAxisCount: currentWardrobe!.columns,
                    // shrinkWrap: true,
                    childAspectRatio: itemWidth / itemHeight,
                    children: List.generate(
                        currentWardrobe.rows * currentWardrobe.columns,
                        (index) {
                      return InkWell(
                        onTap: () {
                          print(
                              'column: ${index % currentWardrobe!.columns} row: ${index / currentWardrobe.columns}');
                          int column = index % currentWardrobe.columns + 1;
                          int row = index ~/ currentWardrobe.columns + 1;
                          showBarModalBottomSheet(
                              context: context,
                              builder: (context) {
                                List<WardrobeProduct> productsAtColAndRow =
                                    snapshot
                                        .data!
                                        .where((element) =>
                                            element.posColumn == column &&
                                            element.posRow == row)
                                        .toList();
                                print("Products");
                                for (var product in productsAtColAndRow) {
                                  print(product.name);
                                }
                                // return Text("HI");
                                return Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.8,
                                  child: ListView.builder(
                                    itemCount: productsAtColAndRow.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                          title: Text(
                                              productsAtColAndRow[index].name),
                                          subtitle: Text(
                                              productsAtColAndRow[index]
                                                  .description),
                                          leading: SizedBox(
                                              width: 50,
                                              height: 50,
                                              child: productsAtColAndRow[index]
                                                          .genFilename !=
                                                      null
                                                  ? CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(ApiService
                                                                  .host +
                                                              "/" +
                                                              productsAtColAndRow[
                                                                      index]
                                                                  .genFilename!),
                                                    )
                                                  : CircleAvatar(
                                                      backgroundImage: AssetImage(
                                                          'images/No_image_available.svg.png'))));
                                    },
                                  ),
                                );
                              });
                          //  ROW = index ~/ rows + 1;
                          // Navigator.pushNamed(context, ShowProductsInDrawerScreen.routeName,
                          //     arguments: WardrobeProducts(
                          //         currentWardrobe!.id, currentWardrobe.fname, index));
                        },
                        child: Container(
                          child: Center(
                            child: Text('$index'),
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
                }));
  }
}
