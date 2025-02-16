class Planet {
  final int? id;
  final String name;
  final String? nickname;
  final double distance;
  final int size;

  // Construtor
  Planet({
    this.id,
    required this.name,
    this.nickname,
    required this.distance,
    required this.size,
  });

  // Método para converter o objeto Planet em um Map, para ser salvo no banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'nickname': nickname,
      'distance': distance,
      'size': size,
    };
  }
}

