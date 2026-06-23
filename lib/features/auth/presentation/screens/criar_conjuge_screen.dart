import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/papel_no_casal.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';

/// Primeiro acesso: cria linhas em `casais` e `conjuges` conforme o schema do Supabase.
/// Se o usuário informar um código de convite válido, entra no casal existente
/// em vez de criar um novo.
class CriarConjugeScreen extends StatefulWidget {
  const CriarConjugeScreen({super.key});

  @override
  State<CriarConjugeScreen> createState() => _CriarConjugeScreenState();
}

class _CriarConjugeScreenState extends State<CriarConjugeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _codigoController = TextEditingController();
  PapelNoCasal _papel = PapelNoCasal.conMelancia;
  bool _temCodigo = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _codigoController.dispose();
    super.dispose();
  }

  Future<void> _continuar() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final auth = context.read<AuthProvider>();
    final codigo = _codigoController.text.trim();

    if (_temCodigo && codigo.isNotEmpty) {
      await auth.entrarComCodigo(
        codigo: codigo,
        nome: _nomeController.text.trim(),
        papel: _papel,
      );
    } else {
      await auth.completarPerfil(
        nome: _nomeController.text.trim(),
        papel: _papel,
      );
    }

    if (!mounted) return;
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
                          if (v.isEmpty) return 'Informe seu nome.';
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
                      const SizedBox(height: 24),
                      CheckboxListTile(
                        value: _temCodigo,
                        onChanged: (v) =>
                            setState(() => _temCodigo = v ?? false),
                        title: const Text('Tenho um código de convite'),
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      if (_temCodigo) ...[
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _codigoController,
                          textCapitalization: TextCapitalization.characters,
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                            labelText: 'Código de convite',
                            hintText: 'Ex: A3KX9B',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (!_temCodigo) return null;
                            final v = value?.trim() ?? '';
                            if (v.isEmpty) return 'Informe o código.';
                            if (v.length != 6) {
                              return 'O código deve ter 6 caracteres.';
                            }
                            return null;
                          },
                        ),
                      ],
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
