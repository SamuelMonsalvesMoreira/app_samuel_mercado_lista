import 'package:app_samuel_mercado_lista/view/lista_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> abrirTela(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const MaterialApp(home: Tela4View()));
}

Future<void> selecionarLista(WidgetTester tester, String nome) async {
  await tester.tap(find.byType(DropdownButtonFormField<String>));
  await tester.pumpAndSettle();
  await tester.tap(find.text(nome).last);
  await tester.pumpAndSettle();
}

Future<void> adicionarItem(
    WidgetTester tester, String nome, String quantidade) async {
  await tester.enterText(
      find.widgetWithText(TextField, 'Nome do Item'), nome);
  await tester.enterText(
      find.widgetWithText(TextField, 'Quantidade'), quantidade);
  await tester.tap(find.text('Adicionar Item'));
  await tester.pumpAndSettle();
}

Future<void> pesquisar(WidgetTester tester, String termo) async {
  await tester.enterText(
      find.widgetWithText(TextField, 'Termo de Pesquisa'), termo);
  await tester.tap(find.text('Pesquisar'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('remover depois de pesquisar apaga o item certo',
      (tester) async {
    await abrirTela(tester);
    await selecionarLista(tester, 'Lista 1');
    await adicionarItem(tester, 'Arroz', '1');
    await adicionarItem(tester, 'Feijão', '2');

    await pesquisar(tester, 'feij');
    expect(find.text('Arroz'), findsNothing);
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    await pesquisar(tester, '');
    expect(find.text('Arroz'), findsOneWidget);
    expect(find.text('Feijão'), findsNothing);
  });

  testWidgets('marcar como comprado depois de pesquisar marca o item certo',
      (tester) async {
    await abrirTela(tester);
    await selecionarLista(tester, 'Lista 1');
    await adicionarItem(tester, 'Arroz', '1');
    await adicionarItem(tester, 'Feijão', '2');

    await pesquisar(tester, 'feij');
    await tester.tap(find.byIcon(Icons.check_circle_outline));
    await tester.pumpAndSettle();

    await pesquisar(tester, '');
    final arroz = find.ancestor(
        of: find.text('Arroz'), matching: find.byType(ListTile));
    final feijao = find.ancestor(
        of: find.text('Feijão'), matching: find.byType(ListTile));
    expect(
        find.descendant(
            of: arroz, matching: find.byIcon(Icons.check_circle_outline)),
        findsOneWidget);
    expect(
        find.descendant(of: feijao, matching: find.byIcon(Icons.check_circle)),
        findsOneWidget);
  });

  testWidgets('pesquisa vazia volta a mostrar todos os itens',
      (tester) async {
    await abrirTela(tester);
    await selecionarLista(tester, 'Lista 1');
    await adicionarItem(tester, 'Arroz', '1');
    await adicionarItem(tester, 'Feijão', '2');

    await pesquisar(tester, 'arroz');
    await pesquisar(tester, 'feij');
    expect(find.text('Feijão'), findsOneWidget);

    await pesquisar(tester, '');
    expect(find.text('Arroz'), findsOneWidget);
    expect(find.text('Feijão'), findsOneWidget);
  });

  testWidgets('não cria lista com nome repetido', (tester) async {
    await abrirTela(tester);
    await tester.tap(find.text('Criar Lista'));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.widgetWithText(TextField, 'Nome da Lista'), 'lista 1');
    await tester.tap(find.text('Criar'));
    await tester.pumpAndSettle();

    expect(find.text('Já existe uma lista com esse nome.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
