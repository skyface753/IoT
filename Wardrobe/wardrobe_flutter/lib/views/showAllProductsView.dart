import 'package:flutter/material.dart';
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
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index].name),
                trailing: Text(snapshot.data![index].description),
                onTap: () async {
                  List<WardrobePos>? wardrobePos =
                      await ApiService.lightLEDByProductId(
                          snapshot.data![index].$id);
                  // PRINT
                  for (var i = 0; i < wardrobePos!.length; i++) {
                    print(wardrobePos[i].toString());
                  }
                  // for (var i = 0; i < wardrobeColRow!.length; i++) {
                  //   print(wardrobeColRow[i].wardrobeFk.toString() + "-------");
                  //   print(wardrobeColRow[i].posColumn);
                  //   print(wardrobeColRow[i].posRow);
                  // }
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: wardrobePos.length,
                            itemBuilder: (context, index) {
                              String text = "";
                              for (var i = 0;
                                  i < wardrobePos[index].colRow.length;
                                  i++) {
                                text +=
                                    wardrobePos[index].colRow[i].toString() +
                                        " : ";
                              }
                              return ListTile(
                                title: Text(wardrobePos[index].fname),
                                trailing: Text(text),
                                // trailing: Text(
                                //     wardrobePos[index].posColumn.toString() +
                                //         " - " +
                                //         wardrobePos[index].posRow.toString()),
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        WardrobePos currWardrobePos =
                                            wardrobePos[index];
                                        int currentColumn = 1;
                                        int currentRow = 1;
                                        return AlertDialog(
                                          title: Text(currWardrobePos.wardrobeFk
                                              .toString()),
                                          content: SizedBox(
                                            height: 400,
                                            width: 400,
                                            child: GridView.count(
                                              crossAxisCount:
                                                  currWardrobePos.columns,
                                              shrinkWrap: true,
                                              children: List.generate(
                                                  currWardrobePos.rows *
                                                      currWardrobePos.columns,
                                                  (index) {
                                                currentColumn = (index %
                                                        currWardrobePos
                                                            .columns) +
                                                    1;
                                                currentRow = (index ~/
                                                        currWardrobePos
                                                            .columns) +
                                                    1;
                                                bool isAProdInColRowPos = false;
                                                for (var i = 0;
                                                    i <
                                                        currWardrobePos
                                                            .colRow.length;
                                                    i++) {
                                                  if (currWardrobePos.colRow[i]
                                                              .pos_column ==
                                                          currentColumn &&
                                                      currWardrobePos.colRow[i]
                                                              .pos_row ==
                                                          currentRow) {
                                                    isAProdInColRowPos = true;
                                                  }
                                                }
                                                return Container(
                                                    // color: Colors.red,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                          width: 1,
                                                        ),
                                                        color:
                                                            isAProdInColRowPos
                                                                ? Colors.red
                                                                : Colors
                                                                    .white));
                                                // if (currWardrobePos.posColumn ==
                                                //         index %
                                                //                 currWardrobePos
                                                //                     .columns +
                                                //             1 &&
                                                //     currWardrobePos.posRow ==
                                                //         index ~/
                                                //                 currWardrobePos
                                                //                     .columns +
                                                //             1) {
                                                //   return Container(
                                                //     // color: Colors.red,
                                                //     decoration: BoxDecoration(
                                                //         border: Border.all(
                                                //           width: 1,
                                                //         ),
                                                //         color: Colors.red),
                                                //   );
                                                // } else {
                                                //   return Container(
                                                //     // color: Colors.transparent,
                                                //     decoration: BoxDecoration(
                                                //         border: Border.all(
                                                //           width: 1,
                                                //         ),
                                                //         color:
                                                //             Colors.transparent),
                                                //   );
                                                // }
                                                return Container(
                                                  color: Colors.red,
                                                );
                                              }),
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("OK"))
                                          ],
                                        );
                                      });
                                },
                              );
                            },
                          ),
                        );
                      });
                  // MaterialPageRoute(
                  //   builder: (context) =>
                  //       DrawersScreen(snapshot.data![index]),
                  // );
                  // Navigator.pushNamed(
                  //     context, ShowSingleWardrobeDrawerScreen.routeName,
                  //     arguments: snapshot.data![index]);
                },
              );
            },
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
