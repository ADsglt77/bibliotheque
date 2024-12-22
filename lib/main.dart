import 'package:bibliotheque/viewmodel/UserViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodel/AuteurViewModel.dart';
import 'viewmodel/LivreViewModel.dart';
import 'view/viewUser/LoginView.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuteurViewModel()),
        ChangeNotifierProvider(create: (context) => LivreViewModel()),
        ChangeNotifierProvider(create: (context) => UserViewModel(userName: '', userRole: '')),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bibliothèque Numérique',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: LoginView(),
    );
  }
}