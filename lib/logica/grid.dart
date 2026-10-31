import 'dart:math';

import 'motor_2048.dart';

class Grid {
  List<List<int?>> celdas;

  Grid(this.celdas);

  // CREAR UNA CUADRICULA VACIA 4X4
  static Grid vacio() =>
      Grid(List.generate(4, (_) => List<int?>.filled(4, null)));

  // RONDA 4: MOVER IZQUIERDA
  int moverIzquierda() {
    var puntos = 0;

    for (var f = 0; f < celdas.length; f++) {
      final resultado = Motor2048.moverFilaIzquierda(celdas[f]);

      celdas[f] = resultado.fila;
      puntos += resultado.puntosGanados;
    }

    return puntos;
  }

  // RONDA 5: MOVER DERECHA
  int moverDerecha() {
    var puntos = 0;

    for (var f = 0; f < celdas.length; f++) {
      final invertida = celdas[f].reversed.toList();

      final resultado = Motor2048.moverFilaIzquierda(invertida);

      celdas[f] = resultado.fila.reversed.toList();
      puntos += resultado.puntosGanados;
    }

    return puntos;
  }

  // RONDA 6: TRANSPONER CUADRICULA
  List<List<int?>> _transponer(List<List<int?>> g) {
    final n = g.length;

    return List.generate(n, (i) => List<int?>.generate(n, (j) => g[j][i]));
  }

  // RONDA 6: MOVER ARRIBA
  int moverArriba() {
    celdas = _transponer(celdas);

    final puntos = moverIzquierda();

    celdas = _transponer(celdas);

    return puntos;
  }

  // RONDA 6: MOVER ABAJO
  int moverAbajo() {
    celdas = _transponer(celdas);

    final puntos = moverDerecha();

    celdas = _transponer(celdas);

    return puntos;
  }

  // RONDA 7: AGREGAR FICHA ALEATORIA
  void agregarFichaAleatoria({Random? aleatorio}) {
    final rnd = aleatorio ?? Random();

    final vacias = <List<int>>[];

    for (var f = 0; f < celdas.length; f++) {
      for (var c = 0; c < celdas[f].length; c++) {
        if (celdas[f][c] == null) {
          vacias.add([f, c]);
        }
      }
    }

    if (vacias.isEmpty) {
      return;
    }

    final elegida = vacias[rnd.nextInt(vacias.length)];

    final valor = rnd.nextDouble() < 0.9 ? 2 : 4;

    celdas[elegida[0]][elegida[1]] = valor;
  }

  // RONDA 8: DETECTAR CELDAS VACIAS
  bool hayCeldasVacias() {
    return celdas.expand((f) => f).any((v) => v == null);
  }

  // RONDA 8: DETECTAR MOVIMIENTOS POSIBLES
  bool hayMovimientosPosibles() {
    // VERIFICAR SI EXISTEN CELDAS VACIAS
    if (hayCeldasVacias()) {
      return true;
    }

    // VERIFICAR FUSIONES HORIZONTALES
    for (var f = 0; f < celdas.length; f++) {
      for (var c = 0; c < celdas[f].length - 1; c++) {
        if (celdas[f][c] == celdas[f][c + 1]) {
          return true;
        }
      }
    }

    // VERIFICAR FUSIONES VERTICALES
    for (var c = 0; c < celdas.length; c++) {
      for (var f = 0; f < celdas.length - 1; f++) {
        if (celdas[f][c] == celdas[f + 1][c]) {
          return true;
        }
      }
    }

    // NO EXISTEN MOVIMIENTOS POSIBLES
    return false;
  }

  // RONDA 9: DETECTAR VICTORIA
  bool haGanado(int objetivo) {
    return celdas.expand((f) => f).any((v) => v != null && v >= objetivo);
  }
}
