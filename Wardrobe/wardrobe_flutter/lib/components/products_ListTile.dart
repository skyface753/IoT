import 'package:flutter/material.dart';
import 'package:wardrobe_flutter/models/product.dart';
import 'package:wardrobe_flutter/models/wardrobe_products.dart';
import 'package:wardrobe_flutter/services/api.dart';

ListTile wardrobeProduct_ListTile(WardrobeProduct wardrobeProduct) {
  return ListTile(
      title: Text(wardrobeProduct.name),
      subtitle: Text(wardrobeProduct.description),
      trailing: Text(wardrobeProduct.number.toString()),
      leading: SizedBox(
          width: 50,
          height: 50,
          child:
              //  wardrobeProduct.imagePathReplaceWithStorageID != null
              // ? CircleAvatar(
              //     backgroundImage: NetworkImage(
              //         ApiService.host + "/" + wardrobeProduct.imagePath!),
              //   )
              // :
              CircleAvatar(
                  backgroundImage:
                      AssetImage('images/No_image_available.svg.png'))));
}
