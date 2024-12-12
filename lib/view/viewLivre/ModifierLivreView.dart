import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/LivreViewModel.dart';
import '../../viewmodel/AuteurViewModel.dart';
import '../../model/Livre.dart';
import '../../model/Auteur.dart';


class ModifierLivreView extends StatefulWidget {
  final Livre livre;

  const ModifierLivreView({super.key, required this.livre});

  @override
  _ModifierLivreViewState createState() => _ModifierLivreViewState();
}

class _ModifierLivreViewState extends State<ModifierLivreView> {
  final _formKey = GlobalKey<FormState>();
  String _nomLivre = '';
  Auteur? _auteurSelectionne;
  String? _jacketPath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final auteurViewModel = Provider.of<AuteurViewModel>(context, listen:false);
    auteurViewModel.chargerAuteurs();
    _nomLivre = widget.livre.nomLivre;
    _auteurSelectionne = widget.livre.auteur;
    _jacketPath = widget.livre.jacketPath;
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      final int timestamp = DateTime.now().millisecondsSinceEpoch;

      final String originalPath = pickedFile.path;
      final String directory = originalPath.substring(0, originalPath.lastIndexOf('/'));

      final String newPath = '$directory/$timestamp.png';

      final File newFile = await File(originalPath).copy(newPath);

      setState(() {
        _jacketPath = newFile.path;

        print('Image path: $_jacketPath');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final livreViewModel = Provider.of<LivreViewModel>(context);
    final auteurViewModel = Provider.of<AuteurViewModel>(context);

    if (auteurViewModel.auteurs.isEmpty) {
      return const Center(child: Text('Aucun auteur disponible.'));
    }

    List<Auteur> auteursFiltres = List.from(auteurViewModel.auteurs);

    if (_auteurSelectionne != null &&
        !auteursFiltres.any((auteur) => auteur == _auteurSelectionne)) {
      auteursFiltres.add(_auteurSelectionne!);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier le livre'),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _nomLivre,
                decoration: const InputDecoration(labelText: 'Nom du Livre'),
                onSaved: (value) => _nomLivre = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nom du livre';
                  }
                  return null;
                }
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: DropdownButtonFormField<Auteur>(
                  value: _auteurSelectionne,
                  onChanged: (Auteur? newValue) {
                    setState(() {
                      _auteurSelectionne = newValue;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Sélectionner un Auteur',
                  ),
                  items: auteursFiltres.map<DropdownMenuItem<Auteur>>((Auteur auteur) {
                    return DropdownMenuItem<Auteur>(
                      value: auteur,
                      child: Text(auteur.nomAuteur),
                    );
                  }).toList(),
                )
              ),
              const SizedBox(height: 20),
              _jacketPath != null
                ? Image.file(File(_jacketPath!), width: 100, height: 150, fit: BoxFit.cover)
                  : const SizedBox.shrink(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library, color: Colors.deepPurpleAccent),
                    label: const Text('Galerie'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt, color: Colors.deepPurpleAccent),
                    label: const Text('Appareil photo'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() && _auteurSelectionne != null) {
                    _formKey.currentState!.save();
                    livreViewModel.mettreAjourLivre(
                        widget.livre.idLivre!,
                        _nomLivre,
                        _auteurSelectionne!.idAuteur!,
                        _jacketPath);
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Veuillez remplir tous les champs')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 20)),
                child: const Text('Modifier le livre'),
              ),
            ],
          ),
        ),
      ),
    );
  }














}
