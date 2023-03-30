import 'package:flutter/material.dart';
import 'package:wardrobe_flutter/models/darwer_position.dart';
import 'package:wardrobe_flutter/models/product.dart';
import 'package:wardrobe_flutter/screens/create_product.dart';
import 'package:wardrobe_flutter/services/api.dart';

class AddProductToDrawerScreen extends StatefulWidget {
  static const String routeName = '/wardrobe/add_product_to_drawer';

  const AddProductToDrawerScreen({
    Key? key,
  }) : super(key: key);

  @override
  AddProductToDrawerScreenState createState() =>
      AddProductToDrawerScreenState();
}

late String wardrobeId;
late int column;
late int row;

TextEditingController _numberController = TextEditingController();

class AddProductToDrawerScreenState extends State<AddProductToDrawerScreen> {
  @override
  Widget build(BuildContext context) {
    DrawerPosition? drawerPosition;
    try {
      drawerPosition =
          ModalRoute.of(context)?.settings.arguments as DrawerPosition;
      wardrobeId = drawerPosition.wardrobeId;
      column = drawerPosition.column;
      row = drawerPosition.row;
    } catch (e) {
      print(e);
    }
    if (drawerPosition == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Add product to drawer"),
        ),
        body: Center(
          child: Text("Error"),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Add product to ${drawerPosition.wardrobeId} ${drawerPosition.column} ${drawerPosition.row}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, CreateProductScreen.routeName)
                  .then((value) => setState(() {}));
            },
          ),
        ],
      ),
      body: FutureBuilder(
          future: ApiService.getAllProducts(),
          builder: (BuildContext context,
              AsyncSnapshot<List<Product>?> allProducts) {
            if (allProducts.hasData) {
              return ListView.builder(
                itemCount: allProducts.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      title: Text(allProducts.data![index].name),
                      onTap: () {
                        // Show number dialog
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              _numberController.text = "1";
                              return AlertDialog(
                                title: Text("How many?"),
                                content: TextField(
                                  controller: _numberController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: "Number",
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                      child: Text("Add"),
                                      onPressed: () async {
                                        await ApiService.addProductToDrawer(
                                                allProducts.data![index].$id,
                                                wardrobeId,
                                                column,
                                                row,
                                                int.parse(
                                                    _numberController.text))
                                            .then(
                                          (value) => {
                                            if (value)
                                              {
                                                showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title:
                                                                Text("Success"),
                                                            content: Text(
                                                                "Product added to drawer"),
                                                            actions: [
                                                              TextButton(
                                                                child:
                                                                    Text("OK"),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        })
                                                    .then((value) => {
                                                          Navigator.of(context)
                                                              .pop()
                                                        })
                                              }
                                            else
                                              {
                                                //Alert error
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text("Error"),
                                                        content: Text(
                                                            "Error adding product to drawer"),
                                                        actions: [
                                                          TextButton(
                                                            child: Text("Ok"),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          )
                                                        ],
                                                      );
                                                    })
                                              }
                                          },
                                        );
                                      })
                                ],
                              );
                            });
                      });
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
      // Center(
      //   child: Text('Add product to drawer'),
      // ),
    );
  }
}
