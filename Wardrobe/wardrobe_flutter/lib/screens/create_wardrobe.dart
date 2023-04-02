import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wardrobe_flutter/services/api.dart';

class CreateWardrobeScreen extends StatefulWidget {
  static const String routeName = '/wardrobe/create';

  const CreateWardrobeScreen({super.key});
  @override
  CreateWardrobeScreenState createState() => CreateWardrobeScreenState();
}

class CreateWardrobeScreenState extends State<CreateWardrobeScreen> {
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _columnsController =
      TextEditingController(text: '1');
  final TextEditingController _rowsController =
      TextEditingController(text: '1');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Wardrobe'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _fnameController,
            decoration: const InputDecoration(
              labelText: 'Name',
            ),
          ),
          Row(
            children: [
              const Text('Columns'),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _columnsController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ], // Only numbers can be entered
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text('Rows'),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _rowsController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ], // Only numbers can be entered
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
          TextButton(
            child: const Text('Create'),
            onPressed: () async {
              if (_fnameController.text.isEmpty) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Error creating wardrobe'),
                    content: const Text('Name cannot be empty'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Ok'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
                return;
              }
              if (int.tryParse(_columnsController.text) == null ||
                  (int.tryParse(_columnsController.text) ?? 0) < 1) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Error creating wardrobe'),
                    content:
                        const Text('Columns must be a number greater than 0'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Ok'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
                return;
              }
              if (int.tryParse(_rowsController.text) == null ||
                  (int.tryParse(_rowsController.text) ?? 0) < 1) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Error creating wardrobe'),
                    content: const Text('Rows must be a number greater than 0'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Ok'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
                return;
              }
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
                    title: const Text('Error creating wardrobe'),
                    content: const Text('Check your permissions'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Ok'),
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
          // Grid preview
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: int.tryParse(_columnsController.text) ?? 1,
            children: List.generate(
              (int.tryParse(_columnsController.text) ?? 1) *
                  (int.tryParse(_rowsController.text) ?? 1),
              (index) => Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Item $index',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
