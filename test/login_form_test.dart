import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:financas/features/auth/presentation/widgets/login_form.dart';

void main() {
  testWidgets('LoginForm: validação rejeita e-mail vazio', (tester) async {
    final formKey = GlobalKey<FormState>();
    final email = TextEditingController();
    final senha = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LoginForm(
            formKey: formKey,
            emailController: email,
            senhaController: senha,
            carregando: false,
            onEntrar: () {},
          ),
        ),
      ),
    );

    expect(formKey.currentState!.validate(), isFalse);
    await tester.pump();
    expect(find.text('Informe o e-mail.'), findsOneWidget);
  });

  testWidgets('LoginForm: validação aceita e-mail e senha preenchidos', (
    tester,
  ) async {
    final formKey = GlobalKey<FormState>();
    final email = TextEditingController(text: 'a@b.com');
    final senha = TextEditingController(text: 'secret');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LoginForm(
            formKey: formKey,
            emailController: email,
            senhaController: senha,
            carregando: false,
            onEntrar: () {},
          ),
        ),
      ),
    );

    expect(formKey.currentState!.validate(), isTrue);
  });
}
