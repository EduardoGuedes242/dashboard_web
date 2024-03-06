class PropostaTotalPorClassificacaoModel {
  String? pclDescricao;
  double? propostaValor;
  int? quantidade;

  PropostaTotalPorClassificacaoModel(
      {this.pclDescricao, this.propostaValor, this.quantidade});

  PropostaTotalPorClassificacaoModel.fromJson(Map<String, dynamic> json) {
    pclDescricao = json['pclDescricao'];
    propostaValor = json['propostaValor'];
    quantidade = json['quantidade'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pclDescricao'] = this.pclDescricao;
    data['propostaValor'] = this.propostaValor;
    data['quantidade'] = this.quantidade;
    return data;
  }
}
