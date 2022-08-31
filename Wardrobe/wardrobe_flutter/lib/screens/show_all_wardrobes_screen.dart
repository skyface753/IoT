import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:wardrobe_flutter/models/wardrobe.dart';
import 'package:wardrobe_flutter/screens/authentication/login_screen.dart';
import 'package:wardrobe_flutter/screens/create_product.dart';
import 'package:wardrobe_flutter/screens/create_wardrobe.dart';
import 'package:wardrobe_flutter/screens/show_single_wardrobe_drawer.dart';
import 'package:wardrobe_flutter/services/api.dart';

class ShowAllWardrobesScreen extends StatefulWidget {
  static const routeName = '/wardrobe/all';
  const ShowAllWardrobesScreen({Key? key}) : super(key: key);
  @override
  ShowAllWardrobesScreenState createState() => ShowAllWardrobesScreenState();
}

class ShowAllWardrobesScreenState extends State<ShowAllWardrobesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wardrobes'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              },
              icon: Icon(Icons.login)),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, CreateProductScreen.routeName);
              },
              icon: Icon(Icons.production_quantity_limits)),
        ],
      ),
      body: FutureBuilder(
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
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        children: [
          SpeedDialChild(
            child: Icon(Icons.add),
            label: 'Create new wardrobe',
            onTap: () {
              Navigator.pushNamed(context, CreateWardrobeScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
