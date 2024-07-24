class Articulo {
  final int id;
  final String clave;
  final String categoria;
  final String nombre;
  final bool activo;

  Articulo({
    required this.id,
    required this.clave,
    required this.categoria,
    required this.nombre,
    this.activo = true,
  });

  factory Articulo.fromJson(Map<String, dynamic> json) {
    return Articulo(
      id: json['id'],
      clave: json['clave'],
      categoria: json['categoria'],
      nombre: json['nombre'],
      activo: json['activo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clave': clave,
      'categoria': categoria,
      'nombre': nombre,
      'activo': activo,
    };
  }
}
