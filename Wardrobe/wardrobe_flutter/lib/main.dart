import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wardrobe_flutter/appwrite.dart';
import 'package:wardrobe_flutter/screens/add_product.dart';
import 'package:wardrobe_flutter/screens/login_screen.dart';
import 'package:wardrobe_flutter/screens/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(title: 'Flutter Demo Home Page'),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/add_product': (context) => AddProductScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void checkIsLoggedIn() async {
    bool isLoggedIn;
    await SharedPreferences.getInstance().then((value) => {
          isLoggedIn = value.getBool('isLoggedIn') ?? false,
          if (!isLoggedIn) {Navigator.pushReplacementNamed(context, '/login')}
        });
  }

  void initAppWrite() async {
    AppWriteCustom.initAppwrite();
  }

  @override
  void initState() {
    initAppWrite();
    super.initState();
    checkIsLoggedIn();
  }

  Databases appwriteDatabases = AppWriteCustom().getAppwriteDatabases();
  Teams appwriteTeams = AppWriteCustom().getAppwriteTeams();

  Future<List<Document>> getData() async {
    return await appwriteDatabases
        .listDocuments(collectionId: AppWriteCustom.collectionID)
        .then((value) {
      return value.documents;
    });
  }

  Future<List<Team>> getTeams() async {
    return await appwriteTeams.list().then((value) {
      return value.teams;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, AsyncSnapshot<List<Document>> snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                FutureBuilder(
                  future: getTeams(),
                  builder: (context, AsyncSnapshot<List<Team>> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(snapshot.data![index].name),
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
                ColoredBox(
                  color: Colors.red,
                  child: Text('${snapshot.data!.length}'),
                ),
                Expanded(
                  child: GridView.builder(
                    itemCount: snapshot.data!.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data![index].$id),
                      );
                    },
                  ),
                )
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      //  Center(
      //   child: GridView.builder(gridDelegate: gridDelegate, itemBuilder: itemBuilder)
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_product');
        },
        tooltip: 'Add Product',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
