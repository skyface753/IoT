import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:wardrobe_flutter/models/product.dart';
import 'package:wardrobe_flutter/models/wardrobe_products.dart';
import 'package:wardrobe_flutter/services/api.dart';

// class WardrobeProduct_ListTile extends StatefulWidget {
//   final WardrobeProduct wardrobeProduct;

//   const WardrobeProduct_ListTile({Key? key, required this.wardrobeProduct})
//       : super(key: key);

//   @override
//   WardrobeProduct_ListTileState createState() =>
//       WardrobeProduct_ListTileState();
// }

// class WardrobeProduct_ListTileState extends State<WardrobeProduct_ListTile> {
//   File? imageFile;

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//         title: Text(widget.wardrobeProduct.name),
//         subtitle: Text(widget.wardrobeProduct.description),
//         trailing: Text(widget.wardrobeProduct.number.toString()),
//         leading: SizedBox(
//             width: 50,
//             height: 50,
//             child: widget.wardrobeProduct.imageFileID != null
//                 ? FutureBuilder(
//                     future: appwriteStorage.getFile(
//                         bucketId: product_image_BucketID,
//                         fileId: widget.wardrobeProduct.imageFileID!),
//                     builder: (context, snapshot) {
//                       if (snapshot.hasData) {
//                         imageFile = snapshot.data as File;
//                         return CircleAvatar(
//                             backgroundImage: FileImage(imageFile!));
//                       } else {
//                         return CircleAvatar(
//                             backgroundImage: AssetImage(
//                                 'images/No_image_available.svg.png'));
//                       }
//                     },
//                   )
//                 : CircleAvatar(
//                     backgroundImage:
//                         AssetImage('images/No_image_available.svg.png'))));
//   }
// }

class Product_ListTile extends StatefulWidget {
  final String? imageID;

  const Product_ListTile({Key? key, this.imageID}) : super(key: key);

  @override
  Product_ListTileState createState() => Product_ListTileState();
}

class Product_ListTileState extends State<Product_ListTile> {
  Image? imageFile;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 50,
        height: 50,
        child: widget.imageID != null
            ? FutureBuilder(
                future: appwriteStorage.getFilePreview(
                    bucketId: product_image_BucketID, fileId: widget.imageID!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    imageFile = Image.memory(snapshot.data as Uint8List);
                    return CircleAvatar(backgroundImage: imageFile!.image);
                  } else if (snapshot.hasError) {
                    return Text(textAlign: TextAlign.center, "No Image");
                    // CircleAvatar(
                    //     backgroundImage:
                    //         AssetImage('No_image_available.svg.png'));
                  }
                  return CircularProgressIndicator();
                },
              )
            : Text(textAlign: TextAlign.center, "No Image"));
    // : CircleAvatar(
    //     backgroundImage: AssetImage('No_image_available.svg.png')));
  }
}
