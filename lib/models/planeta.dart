class Planeta {
  final int? id;
  final String name;
  final String? nickname;
  final double distance;
  final int size;

  // Construtor
  Planeta({
    this.id,
    required this.name,
    this.nickname,
    required this.distance,
    required this.size,
  });

  // Método para converter o objeto Planeta em um Map, para ser salvo no banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'nickname': nickname,
      'distance': distance,
      'size': size,
    };
  }

  // Método para converter um Map em um objeto Planeta
  factory Planeta.fromMap(Map<String, dynamic> map) {
    return Planeta(
      id: map['id'],
      name: map['name'],
      nickname: map['nickname'],
      distance: map['distance'],
      size: map['size'],
    );
  }
}
