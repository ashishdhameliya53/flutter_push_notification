import 'package:flutter/material.dart';

class ThirdScreen extends StatelessWidget {
  const ThirdScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var arg =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
   return Scaffold(
      appBar: AppBar(
        title: Text('Third Screen'),
      ),
      body:  Center(
        child: Column(
          children: [
            Text(arg['name']),
            Text(arg['notification_type']),
          ],
        ),
      ),
    );
  }
}