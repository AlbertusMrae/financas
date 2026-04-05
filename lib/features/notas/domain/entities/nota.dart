class Nota {
  final String id;
  final String proprietarioId;
  final String? titulo;
  final String conteudo;
  final DateTime atualizadaEm;
  final DateTime criadaEm;

  const Nota({
    required this.id,
    required this.proprietarioId,
    this.titulo,
    required this.conteudo,
    required this.atualizadaEm,
    required this.criadaEm,
  });
}
