import 'dart:convert';
import 'package:dashboard_web/src/config/global.dart';
import 'package:dashboard_web/src/models/proposta/total_por_classificacao.dart';
import 'package:http/http.dart' as http;

class PropostaApi {

  static Future<List<PropostaTotalPorClassificacaoModel>> getTotalPropopostaPorClassificacao() async {
    final String url = '${ParametrosGlobais.baseUrlApi}/v1/proposta/consulta-proposta';

    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      List<PropostaTotalPorClassificacaoModel> empresas =
          jsonResponse.map((json) => PropostaTotalPorClassificacaoModel.fromJson(json)).toList();
      return empresas;
    } else {
      print('Erro: ${response.statusCode}');
      throw Exception('Erro ao carregar valores de proposta');
    }
  }
}
