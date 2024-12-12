import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/AuteurViewModel.dart';

class AjouterAuteurView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomAuteurController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.cyan,
          title: Text('Ajouter un Auteur', style: TextStyle(color: Colors.white60))),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key : _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomAuteurController,
                decoration: InputDecoration(labelText: 'Nom de l\'auteur'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez saisir le nom de l\'auteur';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Provider.of<AuteurViewModel>(context, listen: false)
                        .ajouterAuteur(_nomAuteurController.text);
                    Navigator.pop(context);
                  }
                },
                child: Text('Ajouter'),
              ),],
          )
        ),
      ),
    );
  }
}