import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:movies_app/src/providers/movies_provider.dart';

import 'package:movies_app/src/screens/screens.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding.instance.addPostFrameCallback((_) {});
  SchedulerBinding.instance.addPostFrameCallback((_) {});
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => MoviesProvider(), lazy: false),
    ], child: const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light()
          .copyWith(appBarTheme: const AppBarTheme(color: Colors.lime)),
      title: 'SAHIL KHAN',
      initialRoute: 'home',
      routes: {
        'home': (context) => const HomeScreen(), // redirect to home screen
        'details': (context) =>
            const DetailsScreen() // redirect to detail screen
      },
    );
  }
}
