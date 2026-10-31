import 'grid.dart';
import 'direccion.dart';
import 'estado_juego.dart';

class MotorJuego {
  Grid grid = Grid.vacio();

  int puntaje = 0;

  EstadoJuego estado = EstadoJuego.jugando;

  static const int objetivoVictoria = 2048;

  // CONSTRUCTOR: INICIAR CON DOS FICHAS
  MotorJuego() {
    grid.agregarFichaAleatoria();
    grid.agregarFichaAleatoria();
  }

  // RONDA 10: CONTROLAR MOVIMIENTOS
  void mover(Direccion direccion) {
    // NO PERMITIR MOVIMIENTOS SI TERMINO EL JUEGO
    if (estado != EstadoJuego.jugando) {
      return;
    }

    // GUARDAR EL TABLERO ANTES DEL MOVIMIENTO
    final antes = grid.celdas.map((f) => List<int?>.from(f)).toList();

    int puntosGanados;

    // REALIZAR MOVIMIENTO SEGUN LA DIRECCION
    switch (direccion) {
      case Direccion.izquierda:
        puntosGanados = grid.moverIzquierda();
        break;

      case Direccion.derecha:
        puntosGanados = grid.moverDerecha();
        break;

      case Direccion.arriba:
        puntosGanados = grid.moverArriba();
        break;

      case Direccion.abajo:
        puntosGanados = grid.moverAbajo();
        break;
    }

    // ACTUALIZAR PUNTAJE
    puntaje += puntosGanados;

    // COMPROBAR SI EL JUGADOR GANO
    if (grid.haGanado(objetivoVictoria)) {
      estado = EstadoJuego.ganado;
      return;
    }

    // VERIFICAR SI HUBO ALGUN MOVIMIENTO
    final huboMovimiento = !_gridsIguales(antes, grid.celdas);

    // AGREGAR FICHA SOLO SI HUBO MOVIMIENTO
    if (huboMovimiento) {
      grid.agregarFichaAleatoria();
    }

    // COMPROBAR SI EL JUGADOR PERDIO
    if (!grid.hayMovimientosPosibles()) {
      estado = EstadoJuego.perdido;
    }
  }

  // COMPARAR DOS CUADRICULAS
  bool _gridsIguales(List<List<int?>> a, List<List<int?>> b) {
    for (var f = 0; f < a.length; f++) {
      for (var c = 0; c < a[f].length; c++) {
        if (a[f][c] != b[f][c]) {
          return false;
        }
      }
    }

    return true;
  }
}
