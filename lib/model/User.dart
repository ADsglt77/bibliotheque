class User {
  int _idUser = 0;
  String _nomUser = '';
  String _prenomUser = '';
  String _loginUser = '';
  String _mdpUser = '';
  String _roleUser = '';

  // Constructeur
  User({required int idUser, required String nomUser, required String prenomUser, required String loginUser, required String mdpUser, required String roleUser}) {
    _idUser = idUser;
    _nomUser = nomUser;
    _prenomUser = prenomUser;
    _loginUser = loginUser;
    _mdpUser = mdpUser;
    _roleUser = roleUser;
  }

  // Getters
  int get idUser => _idUser;
  String get nomUser => _nomUser;
  String get prenomUser => _prenomUser;
  String get loginUser => _loginUser;
  String get mdpUser => _mdpUser;
  String get roleUser => _roleUser;

  //Setters
  set nomUser(String nomUser) {
    _nomUser = nomUser;
  }

  set prenomUser(String prenomUser) {
    _prenomUser = prenomUser;
  }

  set loginUser(String loginUser) {
    _loginUser = loginUser;
  }

  set mdpUser(String mdpUser) {
    _mdpUser = mdpUser;
  }

  set roleUser(String roleUser) {
    _roleUser = roleUser;
  }

  Map<String, dynamic> toMap() {
    return {
      'idUser': _idUser,
      'nomUser': _nomUser,
      'prenomUser': _prenomUser,
      'loginUser': _loginUser,
      'mdpUser': _mdpUser,
      'roleUser': _roleUser,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      idUser: map['idUser'],
      nomUser: map['nomUser'],
      prenomUser: map['prenomUser'],
      loginUser: map['loginUser'],
      mdpUser: map['mdpUser'],
      roleUser: map['roleUser'],
    );
  }

  //éviter la redondance d'utilisateur

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
      other._idUser == _idUser;
  }

  @override
  int get hashCode => _idUser.hashCode;
















































}