import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:financas/features/auth/presentation/widgets/cadastro_form.dart';

void main() {
  testWidgets('CadastroForm: senhas diferentes falham validação', (
    tester,
  ) async {
    final formKey = GlobalKey<FormState>();
    final email = TextEditingController(text: 'a@b.com');
    final senha = TextEditingController(text: 'secret');
    final confirmar = TextEditingController(text: 'outra');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CadastroForm(
            formKey: formKey,
            emailController: email,
            senhaController: senha,
            confirmarSenhaController: confirmar,
            carregando: false,
            onCriarConta: () {},
          ),
        ),
      ),
    );

    expect(formKey.currentState!.validate(), isFalse);
    await tester.pump();
    expect(find.text('As senhas não coincidem.'), findsOneWidget);
  });
}
