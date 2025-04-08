import 'package:bcrypt/bcrypt.dart';
import '../model/User.dart';
import 'Database.dart';


class UserDatabase {
  final DatabaseClient _dbClient = DatabaseClient();

  Future<List<User>> obtenirTousLesUsers() async {
    final db = await _dbClient.database;
    final List<Map<String, dynamic>> result = await db.query('USERS');

    return result.map((userMap) => User(
      idUser: userMap['idUser'],
      nomUser: userMap['nomUser'],
      prenomUser: userMap['prenomUser'],
      loginUser: userMap['loginUser'],
      mdpUser: userMap['mdpUser'],
      roleUser: userMap['roleUser'],
    ))
      .toList();
  }

  Future<int> ajouterUser({
    required String nomUser,
    required String prenomUser,
    required String loginUser,
    required String mdpUser,
    required String roleUser,
  }) async {
    final db = await _dbClient.database;

    String hashedPassword = BCrypt.hashpw(mdpUser, BCrypt.gensalt());

    return await db.insert('USERS', {
      'nomUser': nomUser,
      'prenomUser': prenomUser,
      'loginUser': loginUser,
      'mdpUser': hashedPassword,
      'roleUser': roleUser,
    });
  }

  Future<int> mettreAjourUser(int idUser, String nomUser, String prenomUser, String loginUser, String mdpUser, String roleUser) async {
    final db = await _dbClient.database;

    Map<String, dynamic> values = {
      'nomUser': nomUser,
      'prenomUser': prenomUser,
      'loginUser': loginUser,
      'mdpUser': mdpUser,
      'roleUser': roleUser,
    };

    if (mdpUser.isNotEmpty) {
      String hashedPassword = BCrypt.hashpw(mdpUser, BCrypt.gensalt());
      values['mdpUser'] = hashedPassword;
    }

    return await db.update(
      'USERS',
      values,
      where: 'idUser = ?',
      whereArgs: [idUser],
    );
  }

  Future<int> supprimerUser(int idUser) async {
    final db = await _dbClient.database;

    return await db.delete('USERS', where: 'idUser = ?', whereArgs: [idUser]);
  }

  Future<User?> verifierLogin(String login, String password) async {
    final db = await _dbClient.database;

    final List<Map<String, dynamic>> result = await db.query(
      'USERS',
      where: 'loginUser = ?',
      whereArgs: [login],
    );

    if (result.isNotEmpty) {
      final userMap = result.first;

      if (BCrypt.checkpw(password, userMap['mdpUser'])) {
        return User(
          idUser: userMap['idUser'],
          nomUser: userMap['nomUser'],
          prenomUser: userMap['prenomUser'],
          loginUser: userMap['loginUser'],
          mdpUser: userMap['mdpUser'],
          roleUser: userMap['roleUser'],
        );
      }
    }
    return null;
  }
}