import 'package:flutter/material.dart';
import 'package:wardrobe_flutter/models/wardrobe.dart';
import 'package:wardrobe_flutter/screens/drawers_screen.dart';
import 'package:wardrobe_flutter/services/api.dart';

class WardrobesScreen extends StatefulWidget {
  static const routeName = '/wardrobes';
  const WardrobesScreen({Key? key}) : super(key: key);
  @override
  WardrobesScreenState createState() => WardrobesScreenState();
}

class WardrobesScreenState extends State<WardrobesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wardrobes'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              icon: Icon(Icons.login)),
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
                  onTap: () {
                    Navigator.pushNamed(context,
                        '${DrawersScreen.routeName}?wardrobeId=${snapshot.data![index].id}');
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
    );
  }
}
