class Conjuge {
  final String id;
  final String nome;
  final String email;
  final String casalId;
  final String? fotoUrl;

  const Conjuge({
    required this.id,
    required this.nome,
    required this.email,
    required this.casalId,
    this.fotoUrl,
  });
}
