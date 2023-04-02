import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:wardrobe_flutter/models/product.dart';
import 'package:wardrobe_flutter/services/api.dart';

class ProductListTile extends StatefulWidget {
  final Product product;
  final double? width;
  final double? height;
  // onTab
  final Function? onTap;

  const ProductListTile(
      {Key? key, required this.product, this.width, this.height, this.onTap})
      : super(key: key);

  @override
  _ProductListTileState createState() => _ProductListTileState();
}

class _ProductListTileState extends State<ProductListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _ProductImage(
        imageID: widget.product.imageFileID,
        width: widget.width,
        height: widget.height,
      ),

      title: Text(widget.product.name),
      subtitle: Text(widget.product.description),
      onTap: widget.onTap as void Function()?,
      // trailing: IconButton(
      //   icon: const Icon(Icons.delete),
      //   onPressed: () async {
      //     await ApiService.deleteProduct(widget.product.id);
      //     setState(() {});
      //   },
      // ),
    );
  }
}

class ProductAsRow extends StatefulWidget {
  final Product product;
  final double? width;
  final double? height;
  // onTab
  final Function? onTap;

  const ProductAsRow(
      {Key? key, required this.product, this.width, this.height, this.onTap})
      : super(key: key);

  @override
  _ProductAsRowState createState() => _ProductAsRowState();
}

class _ProductAsRowState extends State<ProductAsRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ProductImage(
          imageID: widget.product.imageFileID,
          width: widget.width,
          height: widget.height,
        ),
        // const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(widget.product.name),
            Text(widget.product.description),
          ],
        ),
        // const Spacer(),
        // IconButton(
        //   icon: const Icon(Icons.delete),
        //   onPressed: () async {
        //     await ApiService.deleteProduct(widget.product.id);
        //     setState(() {});
        //   },
        // ),
      ],
    );
  }
}

class _ProductImage extends StatefulWidget {
  final String? imageID;
  final double? width;
  final double? height;

  const _ProductImage({Key? key, this.imageID, this.width, this.height})
      : super(key: key);

  @override
  _ProductImageState createState() => _ProductImageState();
}

class _ProductImageState extends State<_ProductImage> {
  Image? imageFile;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: widget.width ?? 50,
        height: widget.height ?? 50,
        child: widget.imageID != null
            ? FutureBuilder(
                future: appwriteStorage
                    .getFilePreview(
                        bucketId: productImageBucketID, fileId: widget.imageID!)
                    .catchError((error) {
                  print(error);
                }),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    imageFile = Image.memory(
                      snapshot.data as Uint8List,
                      // fit: BoxFit.cover,
                    );
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
