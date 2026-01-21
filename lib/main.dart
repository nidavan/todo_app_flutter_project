import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'service/todo_repository.dart';
import 'bloc/todo_bloc.dart';
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
    return MultiProvider(
      providers: [
        // Repository
        Provider<TodoRepository>(create: (context) => TodoRepository()),

        // Bloc depends on Repository
        BlocProvider<TodoBloc>(
          create: (context) =>
              TodoBloc(context.read<TodoRepository>())..add(LoadTodosEven()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo App',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
        home: const TodoScreen(),
      ),
    );
  }
}
