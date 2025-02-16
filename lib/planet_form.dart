import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'planet.dart';

class PlanetForm extends StatefulWidget {
  final Map<String, dynamic>? planet;

  PlanetForm({this.planet});

  @override
  _PlanetFormState createState() => _PlanetFormState();
}

class _PlanetFormState extends State<PlanetForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.planet != null) {
      _nameController.text = widget.planet!['name'];
      _descriptionController.text = widget.planet!['description'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Planet Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Planet Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Criar um novo planeta com os dados do formulário
                Planet planet = Planet(
                  name: _nameController.text,
                  description: _descriptionController.text,
                );

                // Se estiver criando um novo planeta
                if (widget.planet == null) {
                  // Chama o método addPlanet
                  int result = await DatabaseHelper.instance.addPlanet(planet);
                  print('Planet added with id: $result');
                } else {
                  // Se for editar um planeta existente
                  int result = await DatabaseHelper.instance.updatePlanet(planet, widget.planet!['id']);
                  print('Planet updated with id: $result');
                }

                // Volta para a tela anterior após salvar
                Navigator.pop(context);
              },
              child: Text(widget.planet == null ? 'Add Planet' : 'Update Planet'),
            ),
          ],
        ),
      ),
    );
  }
}
