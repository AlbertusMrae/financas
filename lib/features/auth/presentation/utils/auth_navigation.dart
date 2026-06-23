import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../screens/criar_conjuge_screen.dart';
import '../screens/home_screen.dart';

/// Destino após login/cadastro com sessão válida.
void navegarAposAutenticacaoComSessao(BuildContext context) {
  final auth = context.read<AuthProvider>();
  if (auth.erro != null) {
    return;
  }
  if (auth.precisaCompletarPerfil) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const CriarConjugeScreen()),
    );
    return;
  }
  Navigator.of(context).pushReplacement(
    MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
  );
}
