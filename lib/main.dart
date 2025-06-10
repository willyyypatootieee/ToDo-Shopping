import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/user_profile_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'shopping_list_model.dart';
import 'screens/shopping_list_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ShoppingListModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profil Pengguna',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const UserProfileScreen(),
        '/edit': (context) => const EditProfileScreen(),
        '/shopping': (context) => const ShoppingListScreen(),
      },
    );
  }
}
