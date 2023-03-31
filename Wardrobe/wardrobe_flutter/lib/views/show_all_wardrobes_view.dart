import 'package:flutter/material.dart';
import 'package:wardrobe_flutter/models/wardrobe.dart';
import 'package:wardrobe_flutter/screens/show_single_wardrobe_drawer.dart';
import 'package:wardrobe_flutter/services/api.dart';

class ShowAllWardrobesView extends StatefulWidget {
  static const routeName = '/wardrobe/all';
  const ShowAllWardrobesView({Key? key}) : super(key: key);
  @override
  ShowAllWardrobesViewState createState() => ShowAllWardrobesViewState();
}

class ShowAllWardrobesViewState extends State<ShowAllWardrobesView> {
  Future<void> loginDebugAccount() async {
    //TODO: Remove this
    // await ApiService.register("test@skyface.de", "Test123!");
    await ApiService.login("test@skyface.de", "Test123!");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApiService.getAllWardrobes(),
      builder: (context, AsyncSnapshot<List<Wardrobe>?> snapshot) {
        if (snapshot.hasError) {
          return Column(
            children: [
              Text(snapshot.error.toString()),
              ElevatedButton(
                onPressed: () async {
                  await loginDebugAccount();
                },
                child: const Text('Login'),
              ),
            ],
          );
        }
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
                  title: Text(snapshot.data![index].fqdn),
                  trailing: Text(
                      "${snapshot.data![index].maxRows} x ${snapshot.data![index].maxColumns}"),
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
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
