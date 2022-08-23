import 'package:flutter/material.dart';
import 'package:wardrobe_flutter/models/drawer.dart';
import 'package:wardrobe_flutter/screens/products_screen.dart';
import 'package:wardrobe_flutter/services/api.dart';

class DrawersScreen extends StatefulWidget {
  static const String routeName = '/wardrobe/show';
  final String wardrobeId;

  const DrawersScreen(this.wardrobeId, {Key? key}) : super(key: key);
  @override
  DrawersScreenState createState() => DrawersScreenState();
}

class DrawersScreenState extends State<DrawersScreen> {
  @override
  Widget build(BuildContext context) {
    String currWardrobeId = widget.wardrobeId;
    // try {
    //   final currWardrobe =
    //       ModalRoute.of(context)!.settings.arguments as Wardrobe;
    //   print("ID: " + currWardrobe.id);
    //   currWardrobeId = currWardrobe.id;
    // } catch (e) {
    //   currWardrobeId = null;
    //   gotoHome(context);
    // }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Drawers'),
      ),
      body: FutureBuilder(
          future: ApiService.getDrawerByWardrobeId(currWardrobeId),
          builder: (context, AsyncSnapshot<List<WardrobeDrawer>?> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        '${snapshot.data![index].id} pos:${snapshot.data![index].position}'),
                    onTap: () {
                      Navigator.pushNamed(context,
                          '${ProductsScreen.routeName}?drawerId=${snapshot.data![index].id}');
                    },
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
