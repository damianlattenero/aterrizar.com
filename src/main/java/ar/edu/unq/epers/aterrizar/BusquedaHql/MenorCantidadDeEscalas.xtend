package ar.edu.unq.epers.aterrizar.BusquedaHql

/**
 * Created by damian on 4/22/16.
 */
class MenorCantidadDeEscalas extends Orden{

    override getOrderStatament() {
        "order by vuelo.cantidadTramos ASC"
    }

}