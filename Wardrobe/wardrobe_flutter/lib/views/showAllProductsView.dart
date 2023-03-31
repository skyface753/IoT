import 'package:flutter/material.dart';
import 'package:wardrobe_flutter/components/products_ListTile.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:wardrobe_flutter/models/product.dart';
import 'package:wardrobe_flutter/models/wardrobe_col_pos.dart';
import 'package:wardrobe_flutter/services/api.dart';

class ShowAllProductsView extends StatefulWidget {
  @override
  _ShowAllProductsViewState createState() => _ShowAllProductsViewState();
}

class _ShowAllProductsViewState extends State<ShowAllProductsView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApiService.getAllProducts(),
      builder: (context, AsyncSnapshot<List<Product>?> snapshot) {
        if (snapshot.hasData) {
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].name),
                  trailing: Text(snapshot.data![index].description),
                  leading: Product_ListTile(
                    imageID: snapshot.data![index].imageFileID,
                  ),
                  onTap: () async {
                    List<WardrobePos>? wardrobePos =
                        await ApiService.getWardrobeProductPositions(
                            snapshot.data![index].$id);
                    // PRINT
                    for (var i = 0; i < wardrobePos!.length; i++) {
                      print(wardrobePos[i].toString());
                    }
                    // ignore: use_build_context_synchronously
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          if (wardrobePos.length == 0) {
                            return Center(
                              child: Text("Product not in any wardrobe"),
                            );
                          }
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: wardrobePos.length,
                              itemBuilder: (context, index) {
                                // String text = "";
                                // for (var i = 0;
                                //     i < wardrobePos[index].colRow.length;
                                //     i++) {
                                //   text +=
                                //       wardrobePos[index].colRow[i].toString() +
                                //           " : ";
                                // }
                                return ListTile(
                                  title: Text(
                                      "${wardrobePos[index].wardrobeFQDN} - ${wardrobePos[index].stowColumn}:${wardrobePos[index].stowRow}"),
                                  // trailing: Text(text),
                                  // trailing: Text(
                                  //     wardrobePos[index].posColumn.toString() +
                                  //         " - " +
                                  //         wardrobePos[index].posRow.toString()),
                                  // onTap: () {
                                  //   showDialog(
                                  //       context: context,
                                  //       builder: (context) {
                                  //         WardrobePos currWardrobePos =
                                  //             wardrobePos[index];
                                  //         int currentColumn = 1;
                                  //         int currentRow = 1;
                                  //         return AlertDialog(
                                  //           title: Text(currWardrobePos
                                  //               .wardrobeFk
                                  //               .toString()),
                                  //           content: SizedBox(
                                  //             height: 400,
                                  //             width: 400,
                                  //             child: GridView.count(
                                  //               crossAxisCount:
                                  //                   currWardrobePos.columns,
                                  //               shrinkWrap: true,
                                  //               children: List.generate(
                                  //                   currWardrobePos.rows *
                                  //                       currWardrobePos.columns,
                                  //                   (index) {
                                  //                 currentColumn = (index %
                                  //                         currWardrobePos
                                  //                             .columns) +
                                  //                     1;
                                  //                 currentRow = (index ~/
                                  //                         currWardrobePos
                                  //                             .columns) +
                                  //                     1;
                                  //                 bool isAProdInColRowPos =
                                  //                     false;
                                  //                 for (var i = 0;
                                  //                     i <
                                  //                         currWardrobePos
                                  //                             .colRow.length;
                                  //                     i++) {
                                  //                   if (currWardrobePos
                                  //                               .colRow[i]
                                  //                               .pos_column ==
                                  //                           currentColumn &&
                                  //                       currWardrobePos
                                  //                               .colRow[i]
                                  //                               .pos_row ==
                                  //                           currentRow) {
                                  //                     isAProdInColRowPos = true;
                                  //                   }
                                  //                 }
                                  //                 return Container(
                                  //                     // color: Colors.red,
                                  //                     decoration: BoxDecoration(
                                  //                         border: Border.all(
                                  //                           width: 1,
                                  //                         ),
                                  //                         color:
                                  //                             isAProdInColRowPos
                                  //                                 ? Colors.red
                                  //                                 : Colors
                                  //                                     .white));
                                  //                 return Container(
                                  //                   color: Colors.red,
                                  //                 );
                                  //               }),
                                  //             ),
                                  //           ),
                                  //           actions: [
                                  //             TextButton(
                                  //                 onPressed: () {
                                  //                   Navigator.pop(context);
                                  //                 },
                                  //                 child: const Text("OK"))
                                  //           ],
                                  //         );
                                  //       });
                                  // },
                                );
                              },
                            ),
                          );
                        });
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
}
