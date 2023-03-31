import 'package:flutter/foundation.dart';
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
      if (kDebugMode) {
        print(e);
      }
    }
    if (drawerPosition == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Add product to drawer"),
        ),
        body: const Center(
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
                                title: const Text("How many?"),
                                content: TextField(
                                  controller: _numberController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: "Number",
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                      child: const Text("Add"),
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
                                                            title: const Text(
                                                                "Success"),
                                                            content: const Text(
                                                                "Product added to drawer"),
                                                            actions: [
                                                              TextButton(
                                                                child:
                                                                    const Text(
                                                                        "OK"),
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
                                                        title:
                                                            const Text("Error"),
                                                        content: const Text(
                                                            "Error adding product to drawer"),
                                                        actions: [
                                                          TextButton(
                                                            child: const Text(
                                                                "Ok"),
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
              return const Center(child: CircularProgressIndicator());
            }
          }),
      // Center(
      //   child: Text('Add product to drawer'),
      // ),
    );
  }
}
