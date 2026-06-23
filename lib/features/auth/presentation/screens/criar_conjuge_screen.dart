import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/papel_no_casal.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';

/// Primeiro acesso: cria linhas em `casais` e `conjuges` conforme o schema do Supabase.
class CriarConjugeScreen extends StatefulWidget {
  const CriarConjugeScreen({super.key});

  @override
  State<CriarConjugeScreen> createState() => _CriarConjugeScreenState();
}

class _CriarConjugeScreenState extends State<CriarConjugeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  PapelNoCasal _papel = PapelNoCasal.conMelancia;

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  Future<void> _continuar() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final auth = context.read<AuthProvider>();
    await auth.completarPerfil(
      nome: _nomeController.text.trim(),
      papel: _papel,
    );
    if (!mounted) {
      return;
    }
    if (auth.erro == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Seu perfil')),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Complete seu cadastro para usar o app.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _nomeController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Como podemos te chamar?',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          final v = value?.trim() ?? '';
                          if (v.isEmpty) {
                            return 'Informe seu nome.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Seu papel no casal',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      SegmentedButton<PapelNoCasal>(
                        segments: const [
                          ButtonSegment<PapelNoCasal>(
                            value: PapelNoCasal.conMelancia,
                            label: Text('ConMelancia'),
                          ),
                          ButtonSegment<PapelNoCasal>(
                            value: PapelNoCasal.conUva,
                            label: Text('ConUva'),
                          ),
                        ],
                        selected: {_papel},
                        onSelectionChanged: (set) {
                          setState(() => _papel = set.first);
                        },
                      ),
                      if (auth.erro != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          auth.erro!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                      const SizedBox(height: 32),
                      FilledButton(
                        onPressed: auth.carregando ? null : _continuar,
                        child: const Text('Continuar'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (auth.carregando)
            const ModalBarrier(dismissible: false, color: Color(0x33000000)),
          if (auth.carregando) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
