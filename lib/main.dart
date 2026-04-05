import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

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
    return const MaterialApp(
      title: 'NósApp',
      home: Scaffold(
        body: Center(
          child: Text('NósApp'),
        ),
      ),
    );
  }
}
