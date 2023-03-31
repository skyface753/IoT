import 'dart:io';

import 'package:appwrite/appwrite.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wardrobe_flutter/services/api.dart';

class CreateProductScreen extends StatefulWidget {
  static const String routeName = '/product/create';

  const CreateProductScreen({Key? key}) : super(key: key);
  @override
  CreateProductScreenState createState() => CreateProductScreenState();
}

class CreateProductScreenState extends State<CreateProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _image;
  String? serverFileId;
  // bool withImage = false;

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
              onChanged: (value) {
                setState(() {});
              },
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
            ),
            _image != null
                ? Image.file(
                    _image!,
                    width: 100,
                    height: 100,
                  )
                : Container(),
            IconButton(
                onPressed: () async {
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
                icon: const Icon(Icons.add_a_photo)),
            // if (_image != null) Image.file(_image!),
            ElevatedButton(
                // Style disabled when name is empty
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        _nameController.text.isEmpty
                            ? Colors.grey
                            : Colors.blue)),
                onPressed: () async {
                  if (_nameController.text.isEmpty) {
                    return;
                  }
                  if (fileForUpload == null) {
                    ApiService.createProduct(
                      _nameController.text,
                      _descriptionController.text,
                      null,
                    ).then((wasSuccessful) {
                      if (wasSuccessful) {
                        Navigator.pop(context);
                      } else {}
                    });
                    return;
                  } else {
                    try {
                      await uploadFile(fileForUpload!);
                      if (serverFileId == null) {
                        return;
                      }
                      ApiService.createProduct(
                        _nameController.text,
                        _descriptionController.text,
                        serverFileId,
                      ).then((wasSuccessful) {
                        if (wasSuccessful) {
                          Navigator.pop(context);
                        } else {}
                      });
                    } catch (e) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Error"),
                              content: const Text("Error uploading image"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Ok"))
                              ],
                            );
                          });
                    }
                  }

                  // print("Upload Image");
                  // uploadFile(fileForUpload);
                  // print("Create Product");
                  // ApiService.createProduct(
                  //   _nameController.text,
                  //   _descriptionController.text,
                  //   serverFileId,
                  // ).then((wasSuccessful) {
                  //   if (wasSuccessful) {
                  //     Navigator.pop(context);
                  //   } else {
                  //     print("Error creating product");
                  //   }
                  // });
                },
                child: const Text("Create Product"))
          ],
        ));
  }

  bool uploadInProgress = false;
  InputFile? fileForUpload;
  // PlatformFile? objFile;
  // late File file;

  Future<void> getFile() async {
    if (kIsWeb) {
      var result = await FilePicker.platform.pickFiles(
        withReadStream:
            false, // this will return PlatformFile object with read stream#
        type: FileType.image,
        allowMultiple: false,
        allowCompression: false,
      );
      if (result != null) {
        final objFile = result.files.single;
        // setState(() {
        //   uploadInProgress = true;
        // });
        _image = File(objFile.name);
        // print(objFile!);
        fileForUpload =
            InputFile.fromBytes(bytes: objFile.bytes!, filename: objFile.name);
        // uploadFile(input);
      } else {
        return;
      }
    } else {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        allowCompression: false,
        type: FileType.image,
      );
      if (result != null) {
        // setState(() {
        //   uploadInProgress = true;
        // });
        _image = File(result.files.single.path!);
        fileForUpload = InputFile.fromPath(
            path: result.files.single.path!,
            filename: result.files.single.name);
        // uploadFile(input);
      } else {
        return;
        // User canceled the picker
      }
    }
    setState(() {
      // withImage = true;
    });
  }

  uploadFile(InputFile input) async {
    try {
      var response = await ApiService.uploadFile(input);
      setState(() {
        uploadInProgress = false;
        serverFileId = response;
      });
    } catch (e) {}
  }
}
