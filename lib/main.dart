import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/recipe_add_screen.dart';
import 'package:flutter_application_1/screens/recipe_detail_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/screens/recipe_list_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RecipeApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: (Settings) {
        if (Settings.name == '/detail') {
          final arguments = Settings.arguments as Map<String, String>;
          return MaterialPageRoute(
            builder: (context) => RecipeDetailScreen(
                userId: arguments['userid']!, recipeId: arguments['recipeid']!),
          );
        } else if (Settings.name == '/') {
          return MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          );
        } else if (Settings.name == '/list') {
          return MaterialPageRoute(
            builder: (context) => const RecipeListScreen(),
          );
        } else if (Settings.name == '/add') {
          final arguments = Settings.arguments as Map<String, String>;
          return MaterialPageRoute(
            builder: (context) =>
                RecipeAddScreen(userId: arguments['userid']!, recipe: null),
          );
        }
      },
    );
  }
}
