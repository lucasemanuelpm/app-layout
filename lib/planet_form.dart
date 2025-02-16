import 'package:flutter/material.dart';
import 'database_helper.dart';

class PlanetFormScreen extends StatefulWidget {
  final Map<String, dynamic>? planet; // Recebe um planeta para editar, se for o caso

  const PlanetFormScreen({super.key, this.planet});

  @override
  _PlanetFormScreenState createState() => _PlanetFormScreenState();
}

class _PlanetFormScreenState extends State<PlanetFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _nicknameController;
  late TextEditingController _distanceController;
  late TextEditingController _sizeController;

  @override
  void initState() {
    super.initState();
    // Se houver um planeta para editar, preenche os campos com as informações existentes
    _nameController = TextEditingController(text: widget.planet?['name'] ?? '');
    _nicknameController = TextEditingController(text: widget.planet?['nickname'] ?? '');
    _distanceController = TextEditingController(text: widget.planet?['distance'].toString() ?? '');
    _sizeController = TextEditingController(text: widget.planet?['size'].toString() ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nicknameController.dispose();
    _distanceController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  Future<void> _savePlanet() async {
    if (_formKey.currentState?.validate() ?? false) {
      final planet = {
        'name': _nameController.text,
        'nickname': _nicknameController.text.isEmpty ? null : _nicknameController.text,
        'distance': double.parse(_distanceController.text),
        'size': int.parse(_sizeController.text),
      };

      if (widget.planet == null) {
        // Adicionar novo planeta
        await DatabaseHelper.instance.addPlanet(planet);
      } else {
        // Editar planeta existente
        await DatabaseHelper.instance.updatePlanet(planet, widget.planet!['id']);
      }

      Navigator.pop(context); // Volta para a tela anterior
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.planet == null ? 'Cadastrar Planeta' : 'Editar Planeta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome do Planeta'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nome é obrigatório';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nicknameController,
                decoration: const InputDecoration(labelText: 'Apelido'),
              ),
              TextFormField(
                controller: _distanceController,
                decoration: const InputDecoration(labelText: 'Distância do Sol (em UA)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Distância é obrigatória';
                  }
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Digite um valor válido para a distância';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _sizeController,
                decoration: const InputDecoration(labelText: 'Tamanho (em km)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tamanho é obrigatório';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Digite um valor válido para o tamanho';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _savePlanet,
                child: Text(widget.planet == null ? 'Cadastrar' : 'Salvar Alterações'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
