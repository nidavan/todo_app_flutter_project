import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'views/todo_screen.dart';

Future<void> main() async {
  // REQUIRED for async init
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ INITIALIZE SUPABASE FIRST (VERY IMPORTANT)
  await Supabase.initialize(
    url: 'https://iixtgksjbnydrwlplemh.supabase.co',
    anonKey: 'sb_publishable_QKLqbLQC-j6-E753TwpHeQ_8RxbWpum',
  );

  // ✅ THEN run app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const TodoScreen(),
    );
  }
}
