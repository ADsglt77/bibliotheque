import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/UserViewModel.dart';

class AjouterUserView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomUserController = TextEditingController();
  final TextEditingController _prenomUserController = TextEditingController();
  final TextEditingController _loginUserController = TextEditingController();
  final TextEditingController _passwordUserController = TextEditingController();

  final List<String> _roles = ['admin', 'user'];

  String? _selectedRole;

  AjouterUserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text('Ajouter un Utilisateur', style: TextStyle(color: Colors.white60)),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
                children: [
                  TextFormField(
                      controller: _nomUserController,
                      decoration: InputDecoration(labelText: 'Nom de l\'utilisateur'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez saisir le nom de l\'utilisateur';
                        }
                        return null;
                      },
                  ),
                  TextFormField(
                      controller: _prenomUserController,
                      decoration: InputDecoration(labelText: 'Prénom de l\'utilisateur'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez saisir le prénom de l\'utilisateur';
                        }
                        return null;
                      },
                  ),
                  TextFormField(
                      controller: _loginUserController,
                      decoration: InputDecoration(labelText: 'Login de l\'utilisateur'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez saisir le login de l\'utilisateur';
                        }
                        return null;
                      },
                  ),
                  TextFormField(
                      controller: _passwordUserController,
                      decoration: InputDecoration(labelText: 'Mot de passe de l\'utilisateur'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez saisir le mot de passe de l\'utilisateur';
                        }
                        return null;
                      },
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    items: _roles.map((role) {
                      return DropdownMenuItem(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                    hint: Text('Sélectionner un rôle'),
                    onChanged: (value) {
                      _selectedRole = value;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Veuillez sélectionner un rôle';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Provider.of<UserViewModel>(context, listen: false)
                            .ajouterUtilisateur(
                            nomUser: _nomUserController.text,
                            prenomUser: _prenomUserController.text,
                            loginUser: _loginUserController.text,
                            mdpUser: _passwordUserController.text,
                            roleUser: _selectedRole!,
                        );
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    child: const Text('Ajouter l\'utilisateur'),
                  ),
                ],
            ),
          ),
        ),
      ),
    );
  }
}