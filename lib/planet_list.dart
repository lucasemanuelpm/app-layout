import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'planet_form.dart';

class PlanetListScreen extends StatefulWidget {
  const PlanetListScreen({super.key});

  @override
  _PlanetListScreenState createState() => _PlanetListScreenState();
}

class _PlanetListScreenState extends State<PlanetListScreen> {
  List<Map<String, dynamic>> _planets = [];

  @override
  void initState() {
    super.initState();
    _refreshPlanetList();
  }

  Future<void> _refreshPlanetList() async {
    final data = await DatabaseHelper.instance.getPlanets();
    setState(() {
      _planets = data;
    });
  }

  Future<void> _deletePlanet(int id) async {
    await DatabaseHelper.instance.deletePlanet(id);
    _refreshPlanetList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Planetas Cadastrados')),
      body: ListView.builder(
        itemCount: _planets.length,
        itemBuilder: (context, index) {
          final planet = _planets[index];
          return ListTile(
            title: Text(planet['name']),
            subtitle: Text(planet['nickname'] ?? 'Sem apelido'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlanetFormScreen(planet: planet),
                      ),
                    );
                    _refreshPlanetList();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deletePlanet(planet['id']),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PlanetFormScreen()),
          );
          _refreshPlanetList();
        },
      ),
    );
  }
}
