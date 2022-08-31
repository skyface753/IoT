// import 'package:flutter/material.dart';
// import 'package:wardrobe_flutter/helpers/goto_home.dart';
// import 'package:wardrobe_flutter/models/drawers_products_XREF.dart';
// import 'package:wardrobe_flutter/models/product.dart';
// import 'package:wardrobe_flutter/services/api.dart';

// class ShowProductsInDrawerScreen extends StatefulWidget {
//   static const String routeName = '/wardrobe/products/show';
//   final String drawerId;
//   const ShowProductsInDrawerScreen(this.drawerId, {Key? key}) : super(key: key);
//   @override
//   ShowProductsInDrawerScreenState createState() =>
//       ShowProductsInDrawerScreenState();
// }

// class ShowProductsInDrawerScreenState
//     extends State<ShowProductsInDrawerScreen> {
//   @override
//   Widget build(BuildContext context) {
//     String currDrawerId = widget.drawerId;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("nfjf"),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 gotoHome(context);
//               },
//               icon: const Icon(Icons.home)),
//         ],
//       ),
//       body: FutureBuilder(
//           future: ApiService.get(currDrawerId),
//           builder: (context, AsyncSnapshot<List<Product>?> snapshot) {
//             if (snapshot.hasData) {
//               return ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: snapshot.data!.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     leading: snapshot.data![index].imagePath != null
//                         ? CircleAvatar(
//                             backgroundImage: NetworkImage(
//                                 "${ApiService.host}/${snapshot.data![index].imagePath!}"))
//                         : const CircleAvatar(
//                             backgroundImage: AssetImage(
//                                 'images/No_image_available.svg.png')),
//                     title: Text(snapshot.data![index].name),
//                     subtitle: Text(snapshot.data![index].description),
//                     trailing: Text("${snapshot.data![index].number}"),
//                     onTap: () {
//                       Navigator.pushNamed(context, '/product/show',
//                           arguments: snapshot.data![index]);
//                     },
//                   );
//                 },
//               );
//             } else {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//           }),
//     );
//   }
// }
