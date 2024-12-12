import 'package:bibliotheque/view/viewLivre/LivreListView.dart';
import 'package:bibliotheque/view/viewUser/LoginView.dart';
import 'package:bibliotheque/view/viewUser/UserListView.dart';
import 'package:bibliotheque/viewmodel/UserViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/AuteurViewModel.dart';
import '../viewmodel/LivreViewModel.dart';
import 'viewAuteur/AuteurListView.dart';
import 'viewLivre/AjouterLivreView.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  final String userRole;

  const HomeScreen({super.key, required this.userName, required this.userRole});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final livreViewModel = Provider.of<LivreViewModel>(context, listen: false);
    livreViewModel.chargerLivres();

    Future.microtask(() {
      final livreViewModel = Provider.of<LivreViewModel>(context, listen: false);
      livreViewModel.chargerLivres();
      final auteurViewModel = Provider.of<AuteurViewModel>(context, listen: false);
      auteurViewModel.chargerAuteurs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bibliothèque Numérique'),
        backgroundColor: Colors.cyan,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.cyan,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            if (widget.userRole == 'admin')
              ListTile(
                leading: const Icon(Icons.add, color: Colors.deepPurpleAccent),
                title: const Text('Ajouter un Livre'),
                onTap: () {
                  Navigator.pop(context); // Ferme le tiroir (Drawer)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AjouterLivreView(
                          userName: widget.userName, userRole: widget.userRole),
                    ),
                  );
                },
              ),
            ListTile(
              leading: const Icon(Icons.list, color: Colors.deepPurpleAccent),
              title: Text(widget.userRole == 'admin'
                  ? 'Gérer les Auteurs'
                  : 'Voir les Auteurs'),
              onTap: () {
                Navigator.pop(context); // Ferme le tiroir (Drawer)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AuteurListView(
                        userName: widget.userName, userRole: widget.userRole),
                  ),
                );
              },
            ),
            if (widget.userRole == 'admin')
              ListTile(
                leading: const Icon(Icons.list, color: Colors.deepPurpleAccent),
                title: const Text('Gérer les Utilisateurs'),
                onTap: () {
                  Navigator.pop(context); // Ferme le tiroir (Drawer)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserListView(
                          userName: widget.userName, userRole: widget.userRole),
                    ),
                  );
                },
              ),
            const Divider(), // Séparateur pour distinguer la déconnexion
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('Se déconnecter'),
              onTap: () async {
                await Provider.of<UserViewModel>(context, listen: false).logout();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginView()),
                );
              },
            ),
          ],
        ),
      ),
      body: LivreListView(
        userName: widget.userName,
        userRole: widget.userRole,
      ),
    );
  }
}
