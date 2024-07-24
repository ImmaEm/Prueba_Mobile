class Precio {
  final double precio;

  Precio({required this.precio});

  factory Precio.fromJson(Map<String, dynamic> json) {
    return Precio(
      precio: json['precio'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'precio': precio,
    };
  }
}
