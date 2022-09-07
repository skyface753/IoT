import 'package:flutter/material.dart';
import 'package:wardrobe_flutter/models/product.dart';
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
                onTap: () {
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
