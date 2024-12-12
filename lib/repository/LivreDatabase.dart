import '../model/Auteur.dart';
import 'database.dart';

class LivreDatabase {
  final DatabaseClient _dbClient = DatabaseClient();

  Future<int> ajouterLivre(String nomLivre, int idAuteur, String? jacketPath ) async {
    final db = await _dbClient.database;
    return await db.insert('LIVRE', {
      'nomLivre': nomLivre,
      'idAuteur': idAuteur,
      'jacket': jacketPath,
    });
  }

  Future<List<Map<String, dynamic>>> obtenirTousLesLivres() async {
    final db = await _dbClient.database;
    return await db.query('LIVRE');
  }

  Future<int> mettreAjourLivre(int idLivre, String nomLivre, int? idAuteur, String? jacketPath) async {
    final db = await _dbClient.database;
    return await db.update(
        'LIVRE',
        {'nomLivre': nomLivre, 'idAuteur': idAuteur, 'jacket': jacketPath},
        where: 'idLivre = ?',
        whereArgs: [idLivre]
    );
  }

  Future<int> supprimerLivre(int idLivre) async {
    final db = await _dbClient.database;
    return await db.delete('LIVRE', where: 'idLivre = ?', whereArgs: [idLivre]);
  }

  Future<List<Map<String, dynamic>>> obtenirLivresTriesAlphabetiquement() async {
    final db = await _dbClient.database;
    return await db.query(
      'LIVRE',
      orderBy: 'nomLivre ASC', // ASC pour ordre croissant, DESC pour ordre décroissant
    );
  }

  Future<Auteur?> obtenirAuteurParId(int idAuteur) async {
    final db = await _dbClient.database;
    final List<Map<String, dynamic>> auteurMap = await db.query(
      'AUTEUR',
      where: 'idAuteur = ?',
      whereArgs: [idAuteur],
    );
    if (auteurMap.isNotEmpty) {
      return Auteur.fromMap(auteurMap.first);
    }
    return null;
  }
}