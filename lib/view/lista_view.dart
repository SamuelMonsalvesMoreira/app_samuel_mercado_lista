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
  String _termoPesquisa = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista', style: TextStyle(fontSize: 20)),
        // Os botões ficam em "actions" para não estourar a largura
        // do título em telas estreitas.
        actions: [
          TextButton(
            onPressed: _criarNovaLista,
            child: Text('Criar Lista'),
          ),
          TextButton(
            onPressed: _excluirLista,
            child: Text('Excluir Lista'),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              // A key muda junto com a seleção para o campo refletir
              // listas criadas ou excluídas.
              key: ValueKey(_listaSelecionada),
              initialValue: _listaSelecionada,
              items: _listasDeCompras.map((lista) {
                return DropdownMenuItem<String>(
                  value: lista['nome'],
                  child: Text(lista['nome']),
                );
              }).toList(),
              onChanged: (value) {
                _selecionarLista(value);
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
                helperText: 'Deixe vazio e pesquise para ver todos os itens',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _pesquisarItem(),
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
                  final item = _itensFiltrados[index];
                  return ListTile(
                    title: Text(item['nome']),
                    subtitle: Text('Quantidade: ${item['quantidade']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _editarItemDaLista(item);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _removerItemDaLista(item);
                          },
                        ),
                        IconButton(
                          icon: item['comprado']
                              ? Icon(Icons.check_circle, color: Colors.green)
                              : Icon(Icons.check_circle_outline,
                                  color: Colors.grey),
                          onPressed: () {
                            _alternarCompraItem(item);
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
                // Volta para a tela de login sem empilhar novas telas.
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  /// Itens da lista selecionada, sem filtro.
  List<dynamic> _itensDaListaSelecionada() {
    for (var lista in _listasDeCompras) {
      if (lista['nome'] == _listaSelecionada) {
        return lista['itens'];
      }
    }
    return [];
  }

  /// Recalcula os itens exibidos a partir da lista completa
  /// e do termo de pesquisa atual.
  void _atualizarItensExibidos() {
    final termo = _termoPesquisa.toLowerCase();
    _itensFiltrados = _itensDaListaSelecionada()
        .cast<Map<String, dynamic>>()
        .where((item) =>
            termo.isEmpty ||
            (item['nome'] as String).toLowerCase().contains(termo))
        .toList();
  }

  void _selecionarLista(String? nomeLista) {
    setState(() {
      _listaSelecionada = nomeLista;
      _atualizarItensExibidos();
    });
  }

  void _criarNovaLista() {
    _novaListaController.clear();
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
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
                Navigator.pop(dialogContext);
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                String nomeLista = _novaListaController.text.trim();
                if (nomeLista.isEmpty) {
                  return;
                }
                final jaExiste = _listasDeCompras.any((lista) =>
                    (lista['nome'] as String).toLowerCase() ==
                    nomeLista.toLowerCase());
                if (jaExiste) {
                  _mostrarMensagem('Já existe uma lista com esse nome.');
                  return;
                }
                Navigator.pop(dialogContext);
                setState(() {
                  _listasDeCompras.add({'nome': nomeLista, 'itens': []});
                  _listaSelecionada = nomeLista;
                  _atualizarItensExibidos();
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
    if (_listaSelecionada == null) {
      _mostrarMensagem('Selecione uma lista para excluir.');
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Excluir Lista'),
          content: Text(
              'Tem certeza de que deseja excluir a lista "$_listaSelecionada"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _listasDeCompras.removeWhere(
                      (lista) => lista['nome'] == _listaSelecionada);
                  _listaSelecionada = null;
                  _itensFiltrados = [];
                });
                Navigator.pop(dialogContext);
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
        _itensDaListaSelecionada().add({
          'nome': nomeItem,
          'quantidade': quantidadeItem,
          'comprado': false,
        });
        _atualizarItensExibidos();
        _itemController.clear();
        _quantidadeController.clear();
      });
    } else {
      _mostrarMensagem(
          'Selecione uma lista e preencha nome e quantidade do item.');
    }
  }

  void _editarItemDaLista(Map<String, dynamic> item) {
    final quantidadeController =
        TextEditingController(text: item['quantidade']);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Editar Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Nome: ${item['nome']}'),
              TextField(
                controller: quantidadeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Nova Quantidade',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final novaQuantidade = quantidadeController.text.trim();
                if (novaQuantidade.isEmpty) {
                  _mostrarMensagem('Informe a quantidade.');
                  return;
                }
                setState(() {
                  item['quantidade'] = novaQuantidade;
                });
                Navigator.pop(dialogContext);
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    ).then((_) => quantidadeController.dispose());
  }

  void _removerItemDaLista(Map<String, dynamic> item) {
    setState(() {
      _itensDaListaSelecionada().remove(item);
      _atualizarItensExibidos();
    });
  }

  void _alternarCompraItem(Map<String, dynamic> item) {
    setState(() {
      item['comprado'] = !item['comprado'];
    });
  }

  void _pesquisarItem() {
    setState(() {
      _termoPesquisa = _pesquisaController.text.trim();
      _atualizarItensExibidos();
    });
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
