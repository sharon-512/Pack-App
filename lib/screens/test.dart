import 'package:flutter/material.dart';

class TestWidget extends StatefulWidget {
  const TestWidget({Key? key}) : super(key: key);

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  String name2 = '';

  @override
  Widget build(BuildContext context) {
    TextEditingController name = TextEditingController();
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          SizedBox(
            height: 200,
          ),
          TextField(controller: name),
          Container(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  name2 = name.text;
                  print('512-->  $name2');
                });
              },
              child: Text('Submit'),
            ),
          ),
          Text(
            'My name is $name2',
            style: TextStyle(fontSize: 24),
          )
        ],
      ),
    ));
  }
}
