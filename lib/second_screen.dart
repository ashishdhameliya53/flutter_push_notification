import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var arg =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    // print('routName --> ${routName}');
    // print(arg);
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Screen'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(arg['name']),
            Text(arg['notification_type']),
            Text(arg['product_id']),
          ],
        ),
      ),
    );
  }
}
