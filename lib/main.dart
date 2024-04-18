import 'package:device_preview/device_preview.dart';
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';

import 'view/cadastro_view.dart';
import 'view/lista_view.dart';
import 'view/recuperar_senha_view.dart';
import 'view/sobre_view.dart';
import 'view/tela_inicial_view.dart';


void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      initialRoute: 't1',
      routes: {
        't1': (context) => PrincipalView(),
        't2': (context) => Tela2View(),
        't3': (context) => Tela3View(),
        't4': (context) => Tela4View(),
        't6': (context) => SobreView(),
      },
      home: Scaffold(
        appBar: AppBar(
          title: Text('My App - Lista de Mercado'),
        ),
      ),
    );
  }
}
