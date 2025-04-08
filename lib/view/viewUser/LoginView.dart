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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Ajout du titre avant les champs de formulaire
            Text(
              'CONNEXION :',  // Titre avant les champs de connexion
              style: TextStyle(
                fontSize: 30,  // Taille de police du titre
                fontWeight: FontWeight.w900,  // Mettre en gras
                color: Color(0xFF5B54B8),  // Couleur du texte
              ),
            ),
            const SizedBox(height: 20),  // Espacement entre le titre et les champs

            // Champ de connexion pour le login
            TextFormField(
              controller: _loginController,
              decoration: const InputDecoration(
                labelText: 'Login',  // Titre du champ
              ),
            ),
            const SizedBox(height: 20),  // Espacement entre les champs

            // Champ de connexion pour le mot de passe
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Mot de passe',  // Titre du champ
              ),
              obscureText: true,  // Masquer le mot de passe
            ),
            const SizedBox(height: 20.0),  // Espacement avant le bouton

            // Bouton pour se connecter
            ElevatedButton(
              onPressed: () async {
                String? errorMessage = await userViewModel.login(
                  _loginController.text.trim(),
                  _passwordController.text.trim(),
                );

                if (errorMessage != null) {
                  // Affichage de la notification (toast-like) en bas à droite
                  _showToast(context, errorMessage);
                } else {
                  final String userName = userViewModel.userName;
                  final String userRole = userViewModel.userRole;
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

  // Fonction pour afficher un toast-like notification plus petite et sur la droite
  void _showToast(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(
          fontSize: 14, // Taille plus petite du texte du SnackBar
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.red,  // Couleur de fond rouge pour signaler l'erreur
      duration: Duration(seconds: 5),  // Durée d'affichage
      behavior: SnackBarBehavior.floating,  // Permet de flotter
      margin: EdgeInsets.only(bottom: 10, left: 100, right: 10), // Positionner à droite
      shape: RoundedRectangleBorder(  // Donner un bord arrondi à la notification
        borderRadius: BorderRadius.circular(10),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
