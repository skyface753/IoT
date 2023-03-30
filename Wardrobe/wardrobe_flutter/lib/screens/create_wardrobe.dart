import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wardrobe_flutter/services/api.dart';

class CreateWardrobeScreen extends StatefulWidget {
  static const String routeName = '/wardrobe/create';
  @override
  _CreateWardrobeScreenState createState() => _CreateWardrobeScreenState();
}

class _CreateWardrobeScreenState extends State<CreateWardrobeScreen> {
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _columnsController =
      TextEditingController(text: '1');
  final TextEditingController _rowsController =
      TextEditingController(text: '1');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Wardrobe'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _fnameController,
            decoration: InputDecoration(
              labelText: 'Name',
            ),
          ),
          Row(
            children: [
              Text('Columns'),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _columnsController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ], // Only numbers can be entered
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text('Rows'),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _rowsController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ], // Only numbers can be entered
                ),
              ),
            ],
          ),
          TextButton(
            child: Text('Create'),
            onPressed: () async {
              if (await ApiService.createWardrobe(
                _fnameController.text,
                int.parse(_columnsController.text),
                int.parse(_rowsController.text),
              )) {
                Navigator.pop(context);
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Error'),
                    content: Text('Could not create wardrobe'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Ok'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              }
              // Navigator.pushNamed(context, '/wardrobe/show', arguments: Wardrobe(
              //   fname: _fnameController.text,
              //   columns: _columns,
              //   rows: _rows,
              // ));
            },
          ),
        ],
      ),
    );
  }
}
