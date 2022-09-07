import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:wardrobe_flutter/models/wardrobe.dart';
import 'package:wardrobe_flutter/screens/authentication/login_screen.dart';
import 'package:wardrobe_flutter/screens/create_product.dart';
import 'package:wardrobe_flutter/screens/create_wardrobe.dart';
import 'package:wardrobe_flutter/screens/show_single_wardrobe_drawer.dart';
import 'package:wardrobe_flutter/services/api.dart';

class ShowAllWardrobesView extends StatefulWidget {
  static const routeName = '/wardrobe/all';
  const ShowAllWardrobesView({Key? key}) : super(key: key);
  @override
  ShowAllWardrobesViewState createState() => ShowAllWardrobesViewState();
}

class ShowAllWardrobesViewState extends State<ShowAllWardrobesView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApiService.getAllWardrobes(),
      builder: (context, AsyncSnapshot<List<Wardrobe>?> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index].fname),
                trailing: Text(
                    "${snapshot.data![index].rows} x ${snapshot.data![index].columns}"),
                onTap: () {
                  // MaterialPageRoute(
                  //   builder: (context) =>
                  //       DrawersScreen(snapshot.data![index]),
                  // );
                  Navigator.pushNamed(
                      context, ShowSingleWardrobeDrawerScreen.routeName,
                      arguments: snapshot.data![index]);
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
