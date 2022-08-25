import 'package:flutter/material.dart';
import 'package:wardrobe_flutter/models/drawer.dart';
import 'package:wardrobe_flutter/models/wardrobe.dart';
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
  Widget build(BuildContext context) {
    Wardrobe? currentWardrobe;
    try {
      currentWardrobe = ModalRoute.of(context)!.settings.arguments as Wardrobe;
    } catch (e) {
      print(e);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Drawers'),
      ),
      body: FutureBuilder(
          future: ApiService.getProductsByWardrobeId(
              currentWardrobe!.id.toString()),
          builder: (context, AsyncSnapshot<List<WardrobeDrawer>?> snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: currentWardrobe!.columns,
                    mainAxisExtent: 100),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data![index].id.toString()),
                    subtitle: Text(snapshot.data![index].position.toString()),
                    onTap: () {
                      Navigator.pushNamed(context,
                          '${ShowProductsInDrawerScreen.routeName}?drawerId=${snapshot.data![index].id}');
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
