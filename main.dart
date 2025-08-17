import 'dart:io';

void main() {
  List<Map<String, dynamic>> libros = [];

  print('===== BIENVENIDO AL CRUD DE LIBROS =====');

  bool continuar = true;
  while (continuar) {
    print('Selecciona una opción:');
    print('1) Crear');
    print('2) Visualizar');
    print('3) Editar');
    print('4) Eliminar');
    print('5) Salir');

    int? opcion = int.tryParse(stdin.readLineSync() ?? '');
    if (opcion == null) {
      print('Por favor ingresa un número válido (1-5).');
      continue;
    }

    switch (opcion) {
      case 1:
        agregar(libros);
        break;
      case 2:
        visualizar(libros);
        break;
      case 3:
        actualizar(libros);
        break;
      case 4:
        eliminar(libros);
        break;
      case 5:
        continuar = false;
        print('Saliendo...');
        break;
      default:
        print('Opción no válida. Elige entre 1 y 5.');
    }
  }
}

void agregar(List<Map<String, dynamic>> libros) {
  print('');
  print('--- Crear libro ---');
  stdout.write('Título: ');
  String titulo = stdin.readLineSync() ?? '';
  stdout.write('Autor: ');
  String autor = stdin.readLineSync() ?? '';
  stdout.write('Año (número): ');
  String anioInput = stdin.readLineSync() ?? '';
  int anio = int.tryParse(anioInput) ?? 0;

  libros.add({'titulo': titulo, 'autor': autor, 'anio': anio});
  print('Libro registrado correctamente.');
  print('');
}

void visualizar(List<Map<String, dynamic>> libros) {
  print('');
  print('--- Lista de libros ---');
  if (libros.isEmpty) {
    print('No hay libros registrados.');
    return;
  }
  for (int i = 0; i < libros.length; i++) {
    print(
        '$i: Título: ${libros[i]['titulo']}, Autor: ${libros[i]['autor']}, Año: ${libros[i]['anio']}');
  }
  print('');
}

void actualizar(List<Map<String, dynamic>> libros) {
  if (libros.isEmpty) {
    print('No hay libros para editar.');
    return;
  }
  print('');
  print('--- Editar libro ---');
  visualizar(libros);
  stdout.write('Ingresa el índice del libro a actualizar: ');
  int? indice = int.tryParse(stdin.readLineSync() ?? '');
  if (indice == null || indice < 0 || indice >= libros.length) {
    print('Índice inválido.');
    return;
  }

  var libro = libros[indice];

  stdout.write('Nuevo título (enter para mantener "${libro['titulo']}"): ');
  String inputTitulo = stdin.readLineSync() ?? '';
  String titulo = inputTitulo.trim().isEmpty ? libro['titulo'] : inputTitulo.trim();

  stdout.write('Nuevo autor (enter para mantener "${libro['autor']}"): ');
  String inputAutor = stdin.readLineSync() ?? '';
  String autor = inputAutor.trim().isEmpty ? libro['autor'] : inputAutor.trim();

  stdout.write('Nuevo año (enter para mantener ${libro['anio']}): ');
  String inputAnio = stdin.readLineSync() ?? '';
  int anio;
  if (inputAnio.trim().isEmpty) {
    anio = libro['anio'];
  } else {
    anio = int.tryParse(inputAnio) ?? libro['anio'];
  }

  libros[indice] = {'titulo': titulo, 'autor': autor, 'anio': anio};
  print('El libro se actualizó correctamente.');
  print('');
}

void eliminar(List<Map<String, dynamic>> libros) {
  if (libros.isEmpty) {
    print('No hay libros para eliminar.');
    return;
  }
  print('');
  print('--- Eliminar libro ---');
  visualizar(libros);
  stdout.write('Ingresa el índice del libro a eliminar: ');
  int? indice = int.tryParse(stdin.readLineSync() ?? '');
  if (indice == null || indice < 0 || indice >= libros.length) {
    print('Índice inválido.');
    return;
  }

  // Eliminación directa (sin confirmación)
  libros.removeAt(indice);
  print('Libro eliminado correctamente.');
  print('');
}
