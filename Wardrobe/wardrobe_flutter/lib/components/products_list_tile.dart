import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:wardrobe_flutter/services/api.dart';

class ProductListTile extends StatefulWidget {
  final String? imageID;

  const ProductListTile({Key? key, this.imageID}) : super(key: key);

  @override
  ProductListTileState createState() => ProductListTileState();
}

class ProductListTileState extends State<ProductListTile> {
  Image? imageFile;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 50,
        height: 50,
        child: widget.imageID != null
            ? FutureBuilder(
                future: appwriteStorage.getFilePreview(
                    bucketId: productImageBucketID, fileId: widget.imageID!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    imageFile = Image.memory(snapshot.data as Uint8List);
                    return CircleAvatar(backgroundImage: imageFile!.image);
                  } else if (snapshot.hasError) {
                    return const Text(textAlign: TextAlign.center, "No Image");
                    // CircleAvatar(
                    //     backgroundImage:
                    //         AssetImage('No_image_available.svg.png'));
                  }
                  return const CircularProgressIndicator();
                },
              )
            : const Text(textAlign: TextAlign.center, "No Image"));
    // : CircleAvatar(
    //     backgroundImage: AssetImage('No_image_available.svg.png')));
  }
}
