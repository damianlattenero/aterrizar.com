package ar.edu.unq.epers.aterrizar.model


import java.util.List
import java.sql.Date

class CriterioPorFechaDeLlegada extends Criterio {
    Date fechaLlegada

    override validarVuelos(List<VueloOfertado> vuelos) {
        vuelos.filter[vuelo | vuelo.tieneFechaLlegada(fechaLlegada)].toList
    }

}