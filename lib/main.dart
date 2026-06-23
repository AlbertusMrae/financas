import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/financas/presentation/providers/financas_provider.dart';
import 'features/lista_compras/presentation/providers/lista_compras_provider.dart';
import 'features/notas/presentation/providers/notas_provider.dart';
import 'injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  setupDependencies();

  runApp(const NosApp());
}

class NosApp extends StatelessWidget {
  const NosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProvider<FinancasProvider>.value(value: financasProvider),
        ChangeNotifierProvider<ListaComprasProvider>.value(
          value: listaComprasProvider,
        ),
        ChangeNotifierProvider<NotasProvider>.value(value: notasProvider),
      ],
      child: MaterialApp(
        title: 'NósApp',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
