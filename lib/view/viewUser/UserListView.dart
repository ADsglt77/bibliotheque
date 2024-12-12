import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/UserViewModel.dart';
import 'AjouterUserView.dart';
import 'ModifierUserView.dart';

class UserListView extends StatelessWidget{
  final String userName;
  final String userRole;

  const UserListView({super.key, required this.userName, required this.userRole});

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);

    Future.microtask(() => userViewModel.chargerUtilisateurs());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Utilisateurs'),
        backgroundColor: Colors.cyan,
        actions: userRole == 'admin'
          ? [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AjouterUserView()),
                );
              },
            ),
          ]
          : [],
      ),
      body : Consumer<UserViewModel>(
        builder: (context, userViewModel, child) {
          if (userViewModel.utilisateurs.isEmpty) {
            return const Center(child: Text('Aucun utilisateur disponible.'));
          }
          return ListView.builder(
            itemCount: userViewModel.utilisateurs.length,
            itemBuilder: (context, index) {
              final user = userViewModel.utilisateurs[index];

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text('${user.nomUser} ${user.prenomUser}'),
                  subtitle: Text(user.loginUser),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ModifierUserView(user: user),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                        ),
                        onPressed: () {
                          userViewModel.supprimerUtilisateur(user.idUser!);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      )
    );
  }
}