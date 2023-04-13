import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:wardrobe_flutter/models/wardrobe.dart';
import 'package:wardrobe_flutter/screens/authentication/login_screen.dart';
import 'package:wardrobe_flutter/screens/show_single_wardrobe_drawer.dart';
import 'package:wardrobe_flutter/services/api.dart';

class ShowAllWardrobesView extends StatefulWidget {
  static const routeName = '/wardrobe/all';
  const ShowAllWardrobesView({Key? key}) : super(key: key);
  @override
  ShowAllWardrobesViewState createState() => ShowAllWardrobesViewState();
}

class ShowAllWardrobesViewState extends State<ShowAllWardrobesView> {
  void search(String query) async {
    final resultFqdn = await appwriteDatabase.listDocuments(
        databaseId: wardrobeDatabaseID,
        collectionId: wardrobeCollectionID,
        queries: [Query.search("fqdn", query)]);
    _searchResult = resultFqdn.documents
        .map((e) => Wardrobe.fromAppwriteDocument(e))
        .toList();
    setState(() {
      showSearch = true;
    });
  }

  bool showSearch = false;
  List<Wardrobe> _searchResult = [];

  void closeSearch() {
    setState(() {
      showSearch = false;
    });
  }

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApiService.getAllWardrobes(),
      builder: (context, AsyncSnapshot<List<Wardrobe>?> snapshot) {
        if (snapshot.hasError) {
          _btnController.error();
          return ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('An error occured'),
                ElevatedButton(
                    child: const Text("Login"),
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, LoginScreen.routeName);
                    }),
              ],
            ),
          );
        }
        if (snapshot.hasData) {
          _btnController.success();
          if (snapshot.data!.isEmpty) {
            _btnController.reset();
            return ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No Wardrobes found'),
                  RoundedLoadingButton(
                    controller: _btnController,
                    onPressed: () {
                      setState(() {});
                    },
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: SlidableAutoCloseBehavior(
              child: ListView.builder(
                // shrinkWrap: true,
                itemCount:
                    showSearch ? _searchResult.length : snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Slidable(
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        extentRatio: 0.25,
                        children: [
                          SlidableAction(
                            onPressed: (context) async {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Wardrobe'),
                                  content: const Text(
                                      'Are you sure you want to delete this wardrobe?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await ApiService.deleteWardrobe(
                                            showSearch
                                                ? _searchResult[index].$id
                                                : snapshot.data![index].$id);
                                        // snapshot.data![index].$id);
                                        Navigator.of(context).pop();
                                        setState(() {});
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            backgroundColor: Colors.red,
                            label: 'Delete',
                          )
                        ],
                      ),
                      child: ListTile(
                        // title: Text(snapshot.data![index].fqdn),
                        title: Text(showSearch
                            ? _searchResult[index].fqdn
                            : snapshot.data![index].fqdn),
                        // trailing: Text(
                        //     "${snapshot.data![index].maxRows} x ${snapshot.data![index].maxColumns}"),
                        trailing: Text(
                            "${showSearch ? _searchResult[index].maxRows : snapshot.data![index].maxRows} x ${showSearch ? _searchResult[index].maxColumns : snapshot.data![index].maxColumns}"),
                        onTap: () {
                          // MaterialPageRoute(
                          //   builder: (context) =>
                          //       DrawersScreen(snapshot.data![index]),
                          // );
                          Navigator.pushNamed(
                              context, ShowSingleWardrobeDrawerScreen.routeName,
                              // arguments: snapshot.data![index]);
                              arguments: showSearch
                                  ? _searchResult[index]
                                  : snapshot.data![index]);
                        },
                      ));
                },
              ),
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
