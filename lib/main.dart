import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:moduloeventos/prueba_harry.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      title: 'Divum Encuestas',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: PruebaHarry(),
    );
  }
}
