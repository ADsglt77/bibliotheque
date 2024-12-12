import 'package:flutter/cupertino.dart';
import '../model/User.dart';
import '../repository/UserDatabase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserViewModel with ChangeNotifier {
  final UserDatabase _userDatabase = UserDatabase();
  List<User> _utilisateurs = [];
  bool _isLoading = false;
  String _userName = '';
  String _userRole = '';

  UserViewModel({
    required String userName,
    required String userRole,
  }) : _userName = userName,
       _userRole = userRole;

  List<User> get utilisateurs => _utilisateurs;
  bool get isLoading => _isLoading;
  String get userName => _userName;
  String get userRole => _userRole;

  // Récupérer la liste des utilisateurs
  Future<void> chargerUtilisateurs() async {
    _isLoading = true;
    notifyListeners();

    _utilisateurs = await _userDatabase.obtenirTousLesUsers();

    _isLoading = false;
    notifyListeners();
  }

  // Ajouter un utilisateur
  Future<void> ajouterUtilisateur({
    required String nomUser,
    required String prenomUser,
    required String loginUser,
    required String mdpUser,
    required String roleUser,
  }) async {
    await _userDatabase.ajouterUser(
      nomUser: nomUser,
      prenomUser: prenomUser,
      loginUser: loginUser,
      mdpUser: mdpUser,
      roleUser: roleUser,
    );

    await chargerUtilisateurs();
  }

  // Mettre à jour un utilisateur
  Future<void> mettreAjourUtilisateur(
    int idUser,
    String nomUser,
    String prenomUser,
    String loginUser,
    String mdpUser,
    String roleUser,
    ) async {
    await _userDatabase.mettreAjourUser(
      idUser,
      nomUser,
      prenomUser,
      loginUser,
      mdpUser,
      roleUser,
    );

    await chargerUtilisateurs();
  }

  // Supprimer un utilisateur
  Future<void> supprimerUtilisateur(int idUser) async {
    await _userDatabase.supprimerUser(idUser);
    await chargerUtilisateurs();
  }

  // Verifier le login et mettre à jour les informations de l'utilisateur connecté
  Future<String?> login(String login, String password) async {
    if (login.isEmpty || password.isEmpty) {
      return 'Veuillez remplir tous les champs';
    }

    var user = await _userDatabase.verifierLogin(login, password);

    if (user != null) {
      _userName = user.nomUser;
      _userRole = user.roleUser;
      notifyListeners();
      return null; // Pas d'erreur
    } else {
      return 'Login ou mot de passe incorrect';
    }
  }

  // Déconnecter l'utilisateur
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userName');
    notifyListeners();
  }














}