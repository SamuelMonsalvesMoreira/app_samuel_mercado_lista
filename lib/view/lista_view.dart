// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';

class Tela4View extends StatefulWidget {
  const Tela4View({Key? key}) : super(key: key);

  @override
  State<Tela4View> createState() => _Tela4ViewState();
}

class _Tela4ViewState extends State<Tela4View> {
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantidadeController = TextEditingController();
  final TextEditingController _novaListaController = TextEditingController();
  final TextEditingController _pesquisaController = TextEditingController();
  // ignore: prefer_final_fields
  List<Map<String, dynamic>> _listasDeCompras = [
    // Exemplo de lista de compras
    {
      'nome': 'Lista 1',
      'itens': [],
    },

    {
      'nome': 'Lista 2',
      'itens': [],
    },
  ];

  List<Map<String, dynamic>> _itensFiltrados = [];
  String? _listaSelecionada;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Lista', style: TextStyle(fontSize: 20)),

            Spacer(),
            ElevatedButton(
              onPressed: _criarNovaLista,
              child: Text('Criar Lista'),
            ),
            SizedBox(width: 8), // Espaçamento entre botões
            ElevatedButton(
              onPressed: _excluirLista,
              child: Text('Excluir Lista'),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _listaSelecionada,
              items: _listasDeCompras.map((lista) {
                return DropdownMenuItem<String>(
                  value: lista['nome'],
                  child: Text(lista['nome']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _listaSelecionada = value;
                  _filtrarItens(value!);
                });
              },
              decoration: InputDecoration(
                labelText: 'Selecione uma Lista',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _pesquisaController,
              decoration: InputDecoration(
                labelText: 'Termo de Pesquisa',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _pesquisarItem,
                    child: Text('Pesquisar'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: _itemController,
              decoration: InputDecoration(
                labelText: 'Nome do Item',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _quantidadeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Quantidade',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _adicionarItemNaLista,
              child: Text('Adicionar Item'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _itensFiltrados.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_itensFiltrados[index]['nome']),
                    subtitle: Text(
                        'Quantidade: ${_itensFiltrados[index]['quantidade']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _editarItemDaLista(index);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _removerItemDaLista(index);
                          },
                        ),
                        IconButton(
                          icon: _itensFiltrados[index]['comprado']
                              ? Icon(Icons.check_circle, color: Colors.green)
                              : Icon(Icons.check_circle_outline,
                                  color: Colors.grey),
                          onPressed: () {
                            _alternarCompraItem(index);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 't1');
              },
              child: Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }

  void _criarNovaLista() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Criar Nova Lista'),
          content: TextField(
            controller: _novaListaController,
            decoration: InputDecoration(
              labelText: 'Nome da Lista',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  String nomeLista = _novaListaController.text.trim();
                  if (nomeLista.isNotEmpty) {
                    _listasDeCompras.add({'nome': nomeLista, 'itens': []});
                    _listaSelecionada = nomeLista;
                    _filtrarItens(nomeLista);
                    Navigator.pop(context);
                  }
                });
              },
              child: Text('Criar'),
            ),
          ],
        );
      },
    );
  }

  void _excluirLista() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Excluir Lista'),
          content:
              Text('Tem certeza de que deseja excluir a lista selecionada?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _listasDeCompras.removeWhere(
                      (lista) => lista['nome'] == _listaSelecionada);
                  _listaSelecionada = null;
                  _itensFiltrados.clear();
                });
                Navigator.pop(context);
              },
              child: Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  void _adicionarItemNaLista() {
    String nomeItem = _itemController.text.trim();
    String quantidadeItem = _quantidadeController.text.trim();

    if (nomeItem.isNotEmpty &&
        quantidadeItem.isNotEmpty &&
        _listaSelecionada != null) {
      setState(() {
        for (var lista in _listasDeCompras) {
          if (lista['nome'] == _listaSelecionada) {
            lista['itens'].add({
              'nome': nomeItem,
              'quantidade': quantidadeItem,
              'comprado': false,
            });
            break;
          }
        }
        _filtrarItens(_listaSelecionada!);
        _itemController.clear();
        _quantidadeController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Selecione uma lista e preencha nome e quantidade do item.'),
        ),
      );
    }
  }

  void _editarItemDaLista(int index) {
    String nomeItem = _itensFiltrados[index]['nome'];
    String quantidadeItem = _itensFiltrados[index]['quantidade'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Nome: $nomeItem'),
              TextField(
                controller: TextEditingController(text: quantidadeItem),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  quantidadeItem = value;
                },
                decoration: InputDecoration(
                  labelText: 'Nova Quantidade',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _itensFiltrados[index]['quantidade'] = quantidadeItem;
                });
                Navigator.pop(context);
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _removerItemDaLista(int index) {
    setState(() {
      for (var lista in _listasDeCompras) {
        if (lista['nome'] == _listaSelecionada) {
          lista['itens'].removeAt(index);
          break;
        }
      }
      _filtrarItens(_listaSelecionada!);
    });
  }

  void _alternarCompraItem(int index) {
    setState(() {
      for (var lista in _listasDeCompras) {
        if (lista['nome'] == _listaSelecionada) {
          lista['itens'][index]['comprado'] =
              !lista['itens'][index]['comprado'];
          break;
        }
      }
    });
  }

  void _filtrarItens(String listaSelecionada) {
    setState(() {
      for (var lista in _listasDeCompras) {
        if (lista['nome'] == listaSelecionada) {
          _itensFiltrados = List.from(lista['itens']);
          break;
        }
      }
    });
  }

  void _pesquisarItem() {
    String termoPesquisa = _pesquisaController.text.trim().toLowerCase();
    if (termoPesquisa.isNotEmpty) {
      setState(() {
        _itensFiltrados = _itensFiltrados.where((item) {
          return item['nome'].toLowerCase().contains(termoPesquisa);
        }).toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Insira um termo de pesquisa válido.'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _itemController.dispose();
    _quantidadeController.dispose();
    _novaListaController.dispose();
    _pesquisaController.dispose();
    super.dispose();
  }
}
