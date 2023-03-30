import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:wardrobe_flutter/screens/add_product_to_drawer.dart';
import 'package:wardrobe_flutter/screens/create_product.dart';
import 'package:wardrobe_flutter/screens/create_wardrobe.dart';
import 'package:wardrobe_flutter/screens/show_single_wardrobe_drawer.dart';
import 'package:wardrobe_flutter/screens/authentication/login_screen.dart';
import 'package:wardrobe_flutter/screens/authentication/register_screen.dart';
import 'package:wardrobe_flutter/services/api.dart';
import 'package:wardrobe_flutter/views/showAllProductsView.dart';
import 'package:wardrobe_flutter/views/show_all_wardrobes_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  appwriteClient
      .setEndpoint('https://appwrite.skyface.de/v1')
      .setProject('6425b268553b93ec8c55')
      .setSelfSigned(status: false);
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
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        // settings.name = settings.name.toLowerCase();
        RouteSettings routeSettings = RouteSettings(name: settings.name);
        if (settings.name!.contains('?')) {
          try {
            int questionMarkIndex = settings.name!.toLowerCase().indexOf('?');
            switch (
                settings.name!.toLowerCase().substring(0, questionMarkIndex)) {
              // case DrawersScreen.routeName:
              //   final wardrobeId =
              //       Uri.parse(settings.name!).queryParameters['wardrobeId'];
              //   return MaterialPageRoute(
              //     builder: (context) => DrawersScreen(
              //       wardrobeId!,
              //     ),
              //     settings: routeSettings,
              //   );
              // case ShowProductsInDrawerScreen.routeName:
              //   final drawerId =
              //       Uri.parse(settings.name!).queryParameters['drawerId'];
              //   return MaterialPageRoute(
              //       builder: (context) => ShowProductsInDrawerScreen(
              //             drawerId!,
              //           ),
              //       settings: routeSettings);
            }
          } catch (e) {
            print(e);
          }
        }
        switch (settings.name!.toLowerCase()) {
          case LoginScreen.routeName:
            return MaterialPageRoute(
                builder: (context) => const LoginScreen(),
                settings: routeSettings);
          case RegisterScreen.routeName:
            return MaterialPageRoute(
                builder: (context) => RegisterScreen(),
                settings: routeSettings);
          case CreateProductScreen.routeName:
            return MaterialPageRoute(
                builder: (context) => const CreateProductScreen(),
                settings: routeSettings);

          case ShowAllWardrobesView.routeName:
            return MaterialPageRoute(
                builder: (context) => const ShowAllWardrobesView(),
                settings: routeSettings);
        }
      },
      routes: {
        ShowSingleWardrobeDrawerScreen.routeName: (context) =>
            ShowSingleWardrobeDrawerScreen(),
        CreateWardrobeScreen.routeName: (context) => CreateWardrobeScreen(),
        AddProductToDrawerScreen.routeName: (context) =>
            AddProductToDrawerScreen(),
        '/': (context) => const MainHomePage(),
        // '/': (context) => MyHomePage(title: 'Flutter Demo Home Page'),
        // '/login': (context) => const LoginScreen(),
        // '/register': (context) => RegisterScreen(),
        // // '/add_product': (context) => AddProductScreen(),
        // '/wardrobes': (context) => WardrobesScreen(),
        // // '/wardrobe/show': (context) => DrawersScreen(),
        // '/wardrobe/show/products': (context) => ProductsScreen()
      },
    );
  }
}

class MainHomePage extends StatefulWidget {
  const MainHomePage({Key? key}) : super(key: key);

  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = <Widget>[
    const ShowAllWardrobesView(),
    ShowAllProductsView()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wardrobe'),
      ),
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Wardrobes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_display),
            label: 'Products',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
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
          SpeedDialChild(
            child: Icon(Icons.add),
            label: 'Create new product',
            onTap: () {
              Navigator.pushNamed(context, CreateProductScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   void checkIsLoggedIn() async {
//     bool isLoggedIn;
//     await SharedPreferences.getInstance().then((value) => {
//           isLoggedIn = value.getBool('isLoggedIn') ?? false,
//           if (!isLoggedIn) {Navigator.pushReplacementNamed(context, '/login')}
//         });
//   }

//   void initAppWrite() async {
//     AppWriteCustom.initAppwrite();
//   }

//   @override
//   void initState() {
//     initAppWrite();
//     super.initState();
//     checkIsLoggedIn();
//   }

//   Databases appwriteDatabases = AppWriteCustom().getAppwriteDatabases();
//   Teams appwriteTeams = AppWriteCustom().getAppwriteTeams();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: FutureBuilder(
//         future: AppWriteCustom().getWardrobe(),
//         builder: (context, AsyncSnapshot<Wardrobe> snapshot) {
//           if (snapshot.hasData) {
//             return Column(
//               children: [
//                 // FutureBuilder(
//                 //   future: AppWriteCustom().getTeams(),
//                 //   builder: (context, AsyncSnapshot<List<Team>> snapshot) {
//                 //     if (snapshot.hasData) {
//                 //       return ListView.builder(
//                 //         shrinkWrap: true,
//                 //         physics: const NeverScrollableScrollPhysics(),
//                 //         itemCount: snapshot.data!.length,
//                 //         itemBuilder: (context, index) {
//                 //           return ListTile(
//                 //             title: Text(snapshot.data![index].name),
//                 //           );
//                 //         },
//                 //       );
//                 //     } else {
//                 //       return Center(
//                 //         child: CircularProgressIndicator(),
//                 //       );
//                 //     }
//                 //   },
//                 // ),
//                 // ColoredBox(
//                 //   color: Colors.red,
//                 //   child: Text('${snapshot.data!.products.length}'),
//                 // ),
//                 Expanded(
//                   child: GridView.builder(
//                     shrinkWrap: true,
//                     itemCount: snapshot.data!.products.length,
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       mainAxisExtent: 200,
//                     ),
//                     itemBuilder: (context, index) {
//                       return Card(
//                         child: ListTile(
//                           title: Text(snapshot.data!.products[index].Title),
//                           // subtitle: Text(snapshot.data!.products[index].description),
//                         ),
//                       );
//                       // return ListTile(
//                       //   tileColor: Colors.red,
//                       //   title: Text(snapshot.data!.products[index].Title),
//                       // );
//                     },
//                   ),
//                 )
//               ],
//             );
//           } else {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         },
//       ),
//       //  Center(
//       //   child: GridView.builder(gridDelegate: gridDelegate, itemBuilder: itemBuilder)
//       // ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.pushNamed(context, '/add_product');
//         },
//         tooltip: 'Add Product',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
