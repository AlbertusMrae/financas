import 'package:flutter/material.dart';

/// Formulário de cadastro: e-mail, senha e confirmação.
class CadastroForm extends StatefulWidget {
  const CadastroForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.senhaController,
    required this.confirmarSenhaController,
    required this.carregando,
    required this.onCriarConta,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController senhaController;
  final TextEditingController confirmarSenhaController;
  final bool carregando;
  final VoidCallback onCriarConta;

  @override
  State<CadastroForm> createState() => _CadastroFormState();
}

class _CadastroFormState extends State<CadastroForm> {
  bool _obscureSenha = true;
  bool _obscureConfirmar = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: widget.emailController,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final v = value?.trim() ?? '';
                if (v.isEmpty) {
                  return 'Informe o e-mail.';
                }
                if (!v.contains('@')) {
                  return 'E-mail inválido.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: widget.senhaController,
              obscureText: _obscureSenha,
              autofillHints: const [AutofillHints.newPassword],
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Senha',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  tooltip: _obscureSenha ? 'Mostrar senha' : 'Ocultar senha',
                  icon: Icon(
                    _obscureSenha ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() => _obscureSenha = !_obscureSenha);
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe a senha.';
                }
                if (value.length < 6) {
                  return 'Use pelo menos 6 caracteres.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: widget.confirmarSenhaController,
              obscureText: _obscureConfirmar,
              autofillHints: const [AutofillHints.newPassword],
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) {
                if (!widget.carregando) {
                  widget.onCriarConta();
                }
              },
              decoration: InputDecoration(
                labelText: 'Confirmar senha',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  tooltip: _obscureConfirmar
                      ? 'Mostrar senha'
                      : 'Ocultar senha',
                  icon: Icon(
                    _obscureConfirmar ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() => _obscureConfirmar = !_obscureConfirmar);
                  },
                ),
              ),
              validator: (value) {
                if (value != widget.senhaController.text) {
                  return 'As senhas não coincidem.';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: widget.carregando ? null : widget.onCriarConta,
              child: const Text('Criar conta'),
            ),
          ],
        ),
      ),
    );
  }
}
