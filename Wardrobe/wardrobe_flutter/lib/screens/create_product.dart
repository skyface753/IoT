import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:async/async.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wardrobe_flutter/services/api.dart';

class CreateProductScreen extends StatefulWidget {
  static const String routeName = '/product/create';

  const CreateProductScreen({Key? key}) : super(key: key);
  @override
  _CreateProductScreenState createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  File? _image;
  int? serverFileId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create Product'),
        ),
        body: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
            ),
            Checkbox(
                value: serverFileId != null,
                onChanged: (value) {
                  // TODO: delete server file
                  // Prevent onchange
                  return;
                }),
            IconButton(
                onPressed: () async {
                  print("Add Image");
                  getFile();
                  // FilePickerResult? result = await FilePicker.platform
                  //     .pickFiles(
                  //         type: FileType.image,
                  //         allowMultiple: false,
                  //         allowCompression: false);

                  // if (result != null) {
                  //   Uint8List fileBytes = result.files.first.bytes!;
                  //   String fileName = result.files.first.name;
                  //   File file = File(fileName);
                  //   file.writeAsBytesSync(fileBytes);
                  //   String path = result.files.single.path!;
                  //   if (path.isNotEmpty) {
                  //     File file = File(path);
                  //     setState(() {
                  //       _image = file;
                  //     });
                  //   }
                  // } else {
                  //   print("No file selected");
                  //   // User canceled the picker
                  // }
                },
                icon: Icon(Icons.add_a_photo)),
            if (_image != null) Image.file(_image!),
            ElevatedButton(
                onPressed: () {
                  print("Create Product");
                },
                child: Text("Create Product"))
          ],
        ));
  }

  bool uploadInProgress = false;
  PlatformFile? objFile;
  late File file;

  Future<void> getFile() async {
    if (kIsWeb) {
      var result = await FilePicker.platform.pickFiles(
        withReadStream:
            true, // this will return PlatformFile object with read stream#
        type: FileType.image,
        allowMultiple: false,
        allowCompression: false,
      );
      if (result != null) {
        setState(() {
          uploadInProgress = true;
          objFile = result.files.single;
          uploadFileWeb();
        });
      }
    } else {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        allowCompression: false,
        type: FileType.image,
      );
      if (result != null) {
        setState(() {
          uploadInProgress = true;
        });
        file = File(result.files.single.path!);
        uploadFile(file, null);
      } else {
        // User canceled the picker
      }
    }
  }

  uploadFileWeb() async {
    final request = http.MultipartRequest(
      "POST",
      Uri.parse(ApiService.serverPath),
    );
    request.headers['Authorization'] = ApiService.apiKey;
    // request.fields['customer_fk'] = customerID.toString();

    request.files.add(http.MultipartFile(
        "myFile", objFile!.readStream!, objFile!.size,
        filename: objFile!.name));

    var resp = await request.send();

    _handleResponse(resp);
    //------Read response
    // String result = await resp.stream.bytesToString();
    // if (kDebugMode) {
    //   print(result);
    // }
    // // setState(() {
    // //   uploadInProgress = false;
    // // });
  }

  uploadFile(File fileForUpload, String? filename) async {
    var stream = new http.ByteStream(fileForUpload.openRead());
    stream.cast();
    // var stream =
    //     // ignore: deprecated_member_use
    //     http.ByteStream(DelegatingStream.typed(fileForUpload.openRead()));
    var length = await fileForUpload.length();
    var uri = Uri.parse(ApiService.serverPath);
    var request = http.MultipartRequest("POST", uri);
    var fileNameforRequest = "";
    if (filename != null) {
      fileNameforRequest = filename;
    } else {
      fileNameforRequest = path.basename(fileForUpload.path);
    }
    var multipartFile = http.MultipartFile('myFile', stream, length,
        filename: fileNameforRequest);
    request.files.add(multipartFile);

    request.headers['Authorization'] = ApiService.apiKey;
    // request.fields['customer_fk'] = customerID.toString();

    var response = await request.send();
    _handleResponse(response);
    // response.stream.transform(utf8.decoder).listen((value) {
    //   setState(() {
    //     uploadInProgress = false;
    //   });
    // });
  }

  _handleResponse(http.StreamedResponse response) async {
    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var responseJson = json.decode(responseBody);
      print(responseJson);
      setState(() {
        uploadInProgress = false;
        serverFileId = responseJson['fileId'];
      });
    } else {
      print('Error status code: ${response.statusCode}');
    }
  }
}
