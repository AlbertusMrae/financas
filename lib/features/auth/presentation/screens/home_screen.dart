import 'package:flutter/material.dart';

/// Tela inicial após login; navegação completa (abas) virá na próxima etapa do guia.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NósApp')),
      body: const Center(child: Text('Em breve')),
    );
  }
}
