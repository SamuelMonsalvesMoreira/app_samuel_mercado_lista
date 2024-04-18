// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';

class Tela2View extends StatefulWidget {
  const Tela2View({Key? key}) : super(key: key);

  @override
  State<Tela2View> createState() => _Tela2ViewState();
}

class _Tela2ViewState extends State<Tela2View> {
  TextEditingController txtValor1 = TextEditingController();
  TextEditingController txtValor2 = TextEditingController();
  TextEditingController txtValor3 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final nome = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro ${nome ?? ''}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Campo de Texto 1
            TextFormField(
              controller: txtValor1,
              decoration: InputDecoration(
                labelText: 'Nome Completo',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Campo de Texto 2
            TextFormField(
              controller: txtValor2,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Campo de Texto 3
            TextFormField(
              controller: txtValor3,
              decoration: InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Botão "Voltar"
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Voltar'),
                ),

                SizedBox(width: 20),

                // Botão "Abrir"
                ElevatedButton(
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
    );
  }
}
