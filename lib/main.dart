import 'package:flutter/material.dart';
import 'package:scanner/entry.dart';
import 'package:scanner/scanner.dart';
void main() {
  runApp(MaterialApp(
    //Given Title
    title: 'ASAPP2',
    debugShowCheckedModeBanner: false,
    //Given Theme Color
    theme: ThemeData(
      primarySwatch: Colors.indigo,
    ),
    //Declared first page of our app
    initialRoute: '/',
    routes: {
      '/':(context)=>Entry(),
      '/scan': (context)=>ScanQR()
    },
  ));
}



