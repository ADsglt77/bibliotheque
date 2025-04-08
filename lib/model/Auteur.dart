import 'Livre.dart';

class Auteur {
  late int? _idAuteur = 0;
  late String _nomAuteur = '';
  late List<Livre> _listLivreAuteur;

  // Constructeur
  Auteur({required idAuteur,required nomAuteur, required List<Livre> listLivreAuteur}) {
    _idAuteur = idAuteur;
    _nomAuteur = nomAuteur!;
    _listLivreAuteur = listLivreAuteur ?? [];
  }

  // Getters
  int? get idAuteur =>  _idAuteur;

  set idAuteur(int? idAuteur) {
    _idAuteur = idAuteur!;
  }

  String get nomAuteur => _nomAuteur;

  //Setters
  set nomAuteur(String? nomAuteur) {
    _nomAuteur = nomAuteur!;
  }

  List<Livre> get listLivreAuteur => _listLivreAuteur;

  set listLivreAuteur(List<Livre> listLivreAuteur) {
    _listLivreAuteur = listLivreAuteur;
  }

  void ajouterLivre(Livre livre) {
    _listLivreAuteur.add(livre);
  }

  void supprimerLivre(Livre livre) {
    _listLivreAuteur.remove(livre);
  }

  Map<String, dynamic> toMap() {
    return {
      'idAuteur': _idAuteur,
      'nomAuteur': _nomAuteur,
    };
  }

  factory Auteur.fromMap(Map<String, dynamic> map) {
    return Auteur(
      idAuteur: map['idAuteur'],
      nomAuteur: map['nomAuteur'],
      listLivreAuteur: [],
    );
  }
}