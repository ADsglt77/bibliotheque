import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/AuteurViewModel.dart';
import '../HomeScreen.dart';
import '../widget/ConfirmDeleteDialog.dart';
import 'AjouterAuteurView.dart';
import 'ModifierAuteurView.dart';

class AuteurListView extends StatelessWidget {
  final String userName;
  final String userRole;

  const AuteurListView({
    super.key,
    required this.userName,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    final auteurViewModel = Provider.of<AuteurViewModel>(context);
    Future.microtask(() => auteurViewModel.chargerAuteurs());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF5B54B8),
        title: const Text(
          'Liste des Auteurs',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    HomeScreen(userName: userName, userRole: userRole),
              ),
                  (route) => false,
            );
          },
        ),
      ),
      body: auteurViewModel.auteurs.isEmpty
          ? const Center(child: Text('Aucun auteur disponible.'))
          : ListView.builder(
        itemCount: auteurViewModel.auteurs.length,
        itemBuilder: (context, index) {
          final auteur = auteurViewModel.auteurs[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(auteur.nomAuteur),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (userRole == 'admin')
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ModifierAuteurView(auteur: auteur),
                          ),
                        );
                      },
                    ),
                  if (userRole == 'admin')
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Afficher la boîte de dialogue de confirmation
                        showDialog(
                          context: context,
                          builder: (context) => ConfirmDeleteDialog(
                            title: 'Supprimer l\'Auteur',
                            content:
                            'Êtes-vous sûr de vouloir supprimer "${auteur.nomAuteur}" ?',
                            onConfirm: () {
                              Provider.of<AuteurViewModel>(context,
                                  listen: false)
                                  .supprimerAuteur(auteur.idAuteur!);
                            },
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
      // Le bouton flottant en bas à droite
      floatingActionButton: userRole == 'admin'
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AjouterAuteurView()),
          );
        },
        backgroundColor: Color(0xFF5B54B8),
        child: const Icon(
          Icons.add,
          color: Colors.white, // Icône "+" en blanc
        ),
      )
          : null, // Si l'utilisateur n'est pas admin, ne pas afficher le bouton
    );
  }
}
