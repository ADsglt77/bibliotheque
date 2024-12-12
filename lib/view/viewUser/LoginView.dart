import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/UserViewModel.dart';
import '../HomeScreen.dart';

class LoginView extends StatelessWidget {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion'),
        backgroundColor: Colors.blueGrey,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _loginController,
              decoration: const InputDecoration(
                labelText: 'Login',
              ),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Mot de passe',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                String? errorMessage = await userViewModel.login(
                  _loginController.text.trim(),
                  _passwordController.text.trim(),
                );
                // vérifier si le mot de passe fait bien 12 caractères Majuscule minuscule chiffre et caractère spéciale


                if (errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errorMessage),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  // Connexion reussie, on récupère le nom et le role de l'utilisateur
                  final String userName = userViewModel.userName;
                  final String userRole = userViewModel.userRole;

                  // Redirection vers HomeScreen en passant le role de l'utilisateur
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(
                        userName: userName,
                        userRole: userRole,
                      ),
                    ),
                  );
                }
              },
              child: const Text('Se connecter'),
            ),
          ],
        ),
      ),
    );
  }




















}