// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';

import 'sobre_view.dart';

class PrincipalView extends StatefulWidget {
  const PrincipalView({Key? key}) : super(key: key);

  @override
  State<PrincipalView> createState() => _PrincipalViewState();
}

class _PrincipalViewState extends State<PrincipalView> {
  final formKey = GlobalKey<FormState>();
  final txtValor1 = TextEditingController();
  final txtValor2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/imagens/mercado.jpg',
              width: 200,
              height: 200,
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SobreView(),
                      ),
                    );
                  },
                  icon: Icon(Icons.info),
                ),
              ],
            ),
            SizedBox(height: 30),
            TextFormField(
              controller: txtValor1,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                labelText: 'Usuário',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: txtValor2,
              obscureText: true,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navega para Tela4View quando o botão "Login" é pressionado
                    Navigator.pushNamed(context, 't4');
                  },
                  child: Text('Login'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    // Navega para Tela2View quando o botão "Cadastrar" é pressionado
                    Navigator.pushNamed(context, 't2');
                  },
                  child: Text('Cadastrar'),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Esqueceu a senha?'),
                TextButton(
                  onPressed: () {
                    // Navega para Tela3View quando o botão "Clique aqui" é pressionado
                    Navigator.pushNamed(context, 't3');
                  },
                  child: Text('Clique aqui'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
