import 'package:flutter/material.dart';
import '../model/Livre.dart';
import '../repository/LivreDatabase.dart';

class LivreViewModel extends ChangeNotifier{
  final LivreDatabase _livreDb = LivreDatabase();

  List<Livre> _livres = [];

  List<Livre> get livres => _livres;

  Future<void> chargerLivres() async {
    print("Récupération des livres...");

    final livresMap = await _livreDb.obtenirTousLesLivres();
    print("Livres récupérés: $livresMap");

    // Utiliser Future.wait pour récupérer les livres et les auteurs
    final List<Livre?> livres = await Future.wait(
        livresMap.map((livreMap) async {
          final auteur = await _livreDb.obtenirAuteurParId(livreMap['idAuteur']);

          // Vérifiez si l'auteur a été trouvé
          if (auteur == null) {
            print("Auteur non trouvé pour l'ID: ${livreMap['idAuteur']}");
            return null; // Retournez null si l'auteur n'est pas trouvé
          } else {
            print("Auteur trouvé: ${auteur.nomAuteur}");
            return Livre.fromMap(livreMap, auteur); // Créer le livre avec l'auteur trouvé
          }
        })
    );
    _livres = livres.where((livre) => livre != null).cast<Livre>().toList();
    notifyListeners();
  }

  Future<void> ajouterLivre(String nomLivre, int idAuteur, String? jacketPath) async {
    await _livreDb.ajouterLivre(nomLivre, idAuteur, jacketPath);
    await chargerLivres();
  }

    Future<void> mettreAjourLivre(int idLivre, String nomLivre, int idAuteur, String? jacketPath) async {
      await _livreDb.mettreAjourLivre(idLivre, nomLivre, idAuteur, jacketPath);
      await chargerLivres();
    }

    Future<void> supprimerLivre(int idLivre) async {
      await _livreDb.supprimerLivre(idLivre);
      await chargerLivres();
    }
}
