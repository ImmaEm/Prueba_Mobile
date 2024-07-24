class Precio {
  final double valor;
  final int fecha;

  Precio({
    required this.valor,
    required this.fecha,
  });

  factory Precio.fromJson(Map<String, dynamic> json) {
    return Precio(
      valor: json['valor'],
      fecha: json['fecha'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'valor': valor,
      'fecha': fecha,
    };
  }
}
