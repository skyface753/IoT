import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wardrobe_flutter/models/drawer.dart';
import 'package:wardrobe_flutter/models/product.dart';
import 'package:wardrobe_flutter/models/wardrobe.dart';
import 'package:wardrobe_flutter/models/wardrobe_products.dart';

class ApiService {
  static String serverPath = 'http://localhost:5000/file/upload';
  static String host = "http://localhost:5000";
  static String apiKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxLCJpYXQiOjE2NjEyNjAzNTIsImV4cCI6MTY2Mzg1MjM1Mn0.Ww3tl2HDd8QHG7Hz5pl6wQ77kpPcX9eZcwFB54TY2hQ";
  static Future<List<Wardrobe>?> getAllWardrobes() async {
    try {
      final response = await http.post(Uri.parse(host + "/wardrobe/all"),
          body: {}, headers: {"authorization": apiKey});

      if (response.statusCode == 200) {
        print("HIHK");
        var returnResponse = json.decode(response.body);
        print(returnResponse);
        return returnResponse
            .map<Wardrobe>((json) => Wardrobe.fromJson(json))
            .toList();
        // return (response.body as List)
        //     .map((e) => Wardrobe.fromJson(e as Map<String, dynamic>))
        //     .toList();
      } else {
        print("ERROR");
        throw Exception('Failed to load post');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<bool> login(String username, String password) async {
    final response = await http.post(Uri.parse(host + "/login"), body: {
      "username": username,
      "password": password,
    });
    if (response.statusCode == 200) {
      var returnResponse = json.decode(response.body);
      print(returnResponse);
      return returnResponse['success'];
    } else {
      return false;
    }
  }

  static Future<bool> register(String username, String password) async {
    final response = await http.post(Uri.parse(host + "/register"),
        body: {'username': username, 'password': password});
    if (response.statusCode == 200) {
      var returnResponse = json.decode(response.body);
      return returnResponse['success'];
    } else {
      return false;
    }
  }

  static Future<List<WardrobeProduct>?> getProductsByWardrobeId(
      String wardrobeId) async {
    try {
      final response =
          await http.post(Uri.parse(host + "/wardrobe/productsById"), body: {
        "wardrobeId": wardrobeId,
      });

      if (response.statusCode == 200) {
        var returnResponse = json.decode(response.body);
        print(returnResponse);
        return returnResponse
            .map<WardrobeProduct>((json) => WardrobeProduct.fromJson(json))
            .toList();
      } else {
        print("ERROR");
        print(response.statusCode);
        throw Exception('Failed to load post');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<bool> createProduct(
      String name, String description, int? image_fk) async {
    print("Name: $name");
    print("Description: $description");
    print("Image_fk: $image_fk");
    late var body;

    if (image_fk != null) {
      body = {
        "name": name,
        "description": description,
        "image_fk": image_fk.toString(),
      };
    } else {
      body = {
        "name": name,
        "description": description,
      };
    }
    final response =
        await http.post(Uri.parse(host + "/product/create"), body: body);
    print(response.body);
    if (response.statusCode == 200) {
      var returnResponse = json.decode(response.body);
      print(returnResponse);
      return returnResponse['success'];
    } else {
      return false;
    }
  }

  static Future<List<Product>?> getAllProducts() async {
    try {
      final response = await http.post(Uri.parse(host + "/product/all"),
          body: {}, headers: {"authorization": apiKey});

      if (response.statusCode == 200) {
        var returnResponse = json.decode(response.body);
        print(returnResponse);
        return returnResponse
            .map<Product>((json) => Product.fromJson(json))
            .toList();
      } else {
        print("ERROR");
        throw Exception('Failed to load post');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<bool> createWardrobe(String name, int columns, int rows) async {
    final response =
        await http.post(Uri.parse(host + "/wardrobe/create"), body: {
      "fname": name,
      "columns": columns.toString(),
      "rows": rows.toString(),
    }, headers: {
      "authorization": apiKey
    });
    print(response.body);
    if (response.statusCode == 200) {
      var returnResponse = json.decode(response.body);
      print(returnResponse);
      return returnResponse['success'];
    } else {
      return false;
    }
  }

  static Future<bool> addProductToDrawer(
      int productId, int wardrobeId, int column, int row, int number) async {
    final response =
        await http.post(Uri.parse(host + "/product/addProductToDrawer"), body: {
      "productId": productId.toString(),
      "wardrobeId": wardrobeId.toString(),
      "column": column.toString(),
      "row": row.toString(),
      "number": number.toString(),
    }, headers: {
      "authorization": apiKey
    });
    print(response.body);
    if (response.statusCode == 200) {
      var returnResponse = json.decode(response.body);
      print(returnResponse);
      return returnResponse['success'];
    } else {
      return false;
    }
  }
  // static Future<List<Product>?> getProductsByDrawerId(String drawerId) async {
  //   try {
  //     final response = await http
  //         .post(Uri.parse(host + "/product/by-drawer/" + drawerId), body: {});

  //     if (response.statusCode == 200) {
  //       var returnResponse = json.decode(response.body);
  //       print(returnResponse);
  //       return returnResponse
  //           .map<Product>((json) => Product.fromJson(json))
  //           .toList();
  //     } else {
  //       print("ERROR");
  //       print(response.statusCode);
  //       throw Exception('Failed to load post');
  //     }
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }
}
