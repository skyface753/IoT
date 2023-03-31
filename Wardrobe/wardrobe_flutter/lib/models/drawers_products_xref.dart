import 'package:wardrobe_flutter/models/product.dart';

class DrawersProductsXREF {
  String $id;
  String productFk;
  String drawerFk;
  int quantity;
  Product? product;

  DrawersProductsXREF(
      this.$id, this.productFk, this.drawerFk, this.quantity, this.product);

  DrawersProductsXREF.fromJson(Map<String, dynamic> json)
      : $id = json['\$id'],
        productFk = json['products_fk'],
        drawerFk = json['drawers_fk'],
        quantity = json['quantity'];

  void setProduct(Product product) {
    this.product = product;
  }
  // product = Product.fromJson(json['product']);

  // Map<String, dynamic> toJson() => {
  //       '\$id': $id,
  //       'product_fk': productFk,
  //       'drawer_fk': drawerFk,
  //       'quantity': quantity,
  //       'product': product.toJson(),
  //     };
}
