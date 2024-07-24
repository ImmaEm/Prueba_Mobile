class Categoria {
  final int id;
  final String clave;
  final String nombre;
  final int fechaCreado;
  final bool activo;

  Categoria({
    required this.id,
    required this.clave,
    required this.nombre,
    required this.fechaCreado,
    required this.activo,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'],
      clave: json['clave'],
      nombre: json['nombre'],
      fechaCreado: json['fechaCreado'],
      activo: json['activo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clave': clave,
      'nombre': nombre,
      'fechaCreado': fechaCreado,
      'activo': activo,
    };
  }
}
