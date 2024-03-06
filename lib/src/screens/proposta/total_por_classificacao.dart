import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:dashboard_web/src/api/proposta.dart';
import 'package:dashboard_web/src/models/proposta/total_por_classificacao.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PropostaTotalPorClassificacaoPage(),
    );
  }
}

class PropostaTotalPorClassificacaoPage extends StatefulWidget {
  const PropostaTotalPorClassificacaoPage({Key? key}) : super(key: key);

  @override
  State<PropostaTotalPorClassificacaoPage> createState() =>
      _PropostaTotalPorClassificacaoPageState();
}

class _PropostaTotalPorClassificacaoPageState
    extends State<PropostaTotalPorClassificacaoPage> {
  List<PropostaTotalPorClassificacaoModel> _dados = [];
  bool existeItens = false;
  int index = 0;
  double total = 0.0;
  String graficoLabel = '';
  double graficoValor = 0.0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      List<PropostaTotalPorClassificacaoModel> dadosRetorno =
          await PropostaApi.getTotalPropopostaPorClassificacao();
      setState(() {
        _dados = dadosRetorno;
        if (_dados.isEmpty) {
          existeItens = false;
        } else {
          for (var posicao in dadosRetorno) {
            total = total + posicao.propostaValor!;
            print(posicao.propostaValor!.toString() + ' - ' + total.toString());
          }
          existeItens = true;
        }
      });
    } catch (e) {
      print('Erro ao buscar dados de proposta: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 48, bottom: 8),
              child: Text(
                'Valor de Proposta',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Text(
              'R\$ ' + total.toStringAsFixed(2),
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.5),
            ),
            _graficoWidget(),
          ],
        ),
      ),
    );
  }

  // Renomeie a função para _graficoWidget
  Widget _graficoWidget() {
    return (!existeItens)
        ? Container(
            width: MediaQuery.sizeOf(context).width,
            height: 200,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 5,
                    centerSpaceRadius: 110,
                    sections: loadDadosProposta(),
                

                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    graficoLabel,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.teal,
                    ),
                  ),
                  Text(
                    graficoValor.toStringAsFixed(2),
                    style: TextStyle(fontSize: 28),
                  ),
                ],
              )
            ],
          );
  }

  // Atualize a função para usar o índice i em vez de index
  List<PieChartSectionData> loadDadosProposta() {
    return List.generate(_dados.length, (i) {
      final isTouched = i == index;
      final fontSize = isTouched ? 18.0 : 14.0;
      final radius = isTouched ? 60.0 : 50.0;
      final color = isTouched ? Colors.tealAccent : Colors.tealAccent[400];

      double porcentagem = _dados[i].propostaValor! / total;
      porcentagem = porcentagem * 100;

      return PieChartSectionData(
        color: color,
        value: porcentagem,
        title: '${porcentagem.toStringAsFixed(0)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      );
    });
  }
}
