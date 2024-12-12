import 'package:sqflite/sqflite.dart';
import 'Database.dart';

class AuteurDatabase {
    final DatabaseClient _dbClient = DatabaseClient();

    Future<int> ajouterAuteur(String nomAuteur) async {
        final db = await _dbClient.database;
        return await db.insert('AUTEUR', {
          'nomAuteur': nomAuteur,
        });
    }

    Future<List<Map<String, dynamic>>> obtenirTousLesAuteurs() async {
        final db = await _dbClient.database;
        return await db.query('AUTEUR');
    }

    Future<int> mettreAjourAuteur(int idAuteur, String nomAuteur) async {
        final db = await _dbClient.database;
        return await db.update(
            'AUTEUR',
            {'nomAuteur': nomAuteur,},
            where: 'idAuteur = ?',
            whereArgs: [idAuteur]);
    }
    Future<int> supprimerAuteur(int idAuteur) async {
        final db = await _dbClient.database;
        await db.delete('LIVRE', where: 'idAuteur = ?', whereArgs: [idAuteur]);
        return await db.delete('AUTEUR', where: 'idAuteur = ?', whereArgs: [idAuteur]);
    }

    Future<List<Map<String, dynamic>>> obtenirAuteursTriesAlphabetiquement() async {
        final db = await _dbClient.database;
        return await db.query(
            'AUTEUR',
            orderBy: 'nomAuteur ASC', // ASC pour ordre croissant, DESC pour ordre décroissant
        );
    }

    Future<List<Map<String, dynamic>>> obtenirLivreParAuteur(int idAuteur) async {
        final db = await _dbClient.database;
        return await db.query(
            'LIVRE',
            where: 'idAuteur = ?',
            whereArgs: [idAuteur],
        );
    }
}