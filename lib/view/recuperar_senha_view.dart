// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class Tela3View extends StatefulWidget {
  const Tela3View({Key? key}) : super(key: key);

  @override
  State<Tela3View> createState() => _Tela3ViewState();
}

class _Tela3ViewState extends State<Tela3View> {
  TextEditingController txtValor2 = TextEditingController();
  TextEditingController txtValor3 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recuperar Senha'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Campo de Texto 2
              TextFormField(
                controller: txtValor2,
                decoration: InputDecoration(
                  labelText: 'Nova Senha',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              // Campo de Texto 3
              TextFormField(
                controller: txtValor3,
                decoration: InputDecoration(
                  labelText: 'Código de Confirmação',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botão "Voltar"
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context, 't2');
                    },
                    child: Text('Voltar'),
                  ),
                  SizedBox(width: 20),

                  // Botão "Abrir"
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 't4');
                    },
                    child: Text('Abrir'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}