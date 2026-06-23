import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final precisaDeParceiro = auth.casal?.precisaDeParceiro ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('NósApp'),
        actions: [
          if (precisaDeParceiro)
            IconButton(
              icon: const Icon(Icons.group_add),
              tooltip: 'Convidar parceiro',
              onPressed: () => _mostrarDialogConvite(context),
            ),
        ],
      ),
      body: const Center(child: Text('Em breve')),
    );
  }

  Future<void> _mostrarDialogConvite(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    await auth.gerarCodigo();
    if (!context.mounted) return;
    if (auth.erro != null) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _ConviteDialog(),
    );
  }
}

class _ConviteDialog extends StatefulWidget {
  const _ConviteDialog();

  @override
  State<_ConviteDialog> createState() => _ConviteDialogState();
}

class _ConviteDialogState extends State<_ConviteDialog> {
  late Timer _timer;
  int _segundosRestantes = 15 * 60;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_segundosRestantes <= 1) {
        _timer.cancel();
        if (mounted) Navigator.of(context).pop();
        return;
      }
      setState(() => _segundosRestantes--);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get _tempoFormatado {
    final min = (_segundosRestantes ~/ 60).toString().padLeft(2, '0');
    final seg = (_segundosRestantes % 60).toString().padLeft(2, '0');
    return '$min:$seg';
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final codigo = auth.codigoConvite ?? '------';

    return AlertDialog(
      title: const Text('Código de convite'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Compartilhe este código com seu parceiro. Ele expira em:',
          ),
          const SizedBox(height: 16),
          Text(
            codigo,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _tempoFormatado,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: _segundosRestantes < 60
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      actions: [
        TextButton.icon(
          icon: const Icon(Icons.copy),
          label: const Text('Copiar'),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: codigo));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Código copiado!')),
            );
          },
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}
