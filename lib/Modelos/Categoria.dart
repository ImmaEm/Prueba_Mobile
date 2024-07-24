class Categoria {
  final String clave;
  final int fechaCreado;
  final String nombre;
  final bool activo;

  Categoria({
    required this.clave,
    required this.fechaCreado,
    required this.nombre,
    required this.activo,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      clave: json['clave'],
      fechaCreado: json['fechaCreado'],
      nombre: json['nombre'],
      activo: json['activo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clave': clave,
      'fechaCreado': fechaCreado,
      'nombre': nombre,
      'activo': activo,
    };
  }
}
