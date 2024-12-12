import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/LivreViewModel.dart';
import '../../viewmodel/AuteurViewModel.dart';
import '../../model/Auteur.dart';

class AjouterLivreView extends StatefulWidget {
  final String userName;
  final String userRole;

  const AjouterLivreView({super.key, required this.userName, required this.userRole});

  @override
  _AjouterLivreViewState createState() => _AjouterLivreViewState();
}

class _AjouterLivreViewState extends State<AjouterLivreView> {
  final _formKey = GlobalKey<FormState>();
  String _nomLivre = '';
  Auteur? _auteurSelectionne;
  String? _jacketPath;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = true;

  @override
  void initState(){
    super.initState();
    _loadAuteurs();
  }

  Future<void> _loadAuteurs() async {
    final auteurViewModel = Provider.of<AuteurViewModel>(context, listen: false);
    await auteurViewModel.chargerAuteurs();
    setState(() {
      _isLoading = false;
    });
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
    final livreViewModel = Provider.of<LivreViewModel>(context, listen: false);
    final auteurViewModel = Provider.of<AuteurViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un livre'),
        backgroundColor: Colors.blueGrey,
      ),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nom du livre'),
                  onSaved: (value) => _nomLivre = value ?? '',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer le nom du livre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<Auteur>(
                  decoration: const InputDecoration(labelText: 'Selectionner un auteur'),
                  value: _auteurSelectionne,
                  items: auteurViewModel.auteurs.map((Auteur auteur) {
                    return DropdownMenuItem<Auteur>(
                      value: auteur,
                      child: Text(auteur.nomAuteur),
                    );
                  }).toList(),
                  onChanged: (Auteur? newValue) {
                    setState(() {
                      _auteurSelectionne = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Veuillez sélectionner un auteur';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library, color: Colors.blueGrey),
                      label: const Text('Galerie'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt, color: Colors.blueGrey),
                      label: const Text('Appareil photo'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _jacketPath != null
                ? Image.file(
                  File(_jacketPath!),
                  width: 100,
                  height: 150,
                  fit: BoxFit.cover,
                )
                    : const SizedBox.shrink(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      if (_auteurSelectionne != null) {
                        livreViewModel.ajouterLivre(_nomLivre, _auteurSelectionne!.idAuteur!, _jacketPath);
                        Navigator.pop(context);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  child: const Text('Ajouter'),
                ),
              ],
            )
          )
        )
      )
    );
  }










}