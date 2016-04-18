package ar.edu.unq.epers.hibernate

import ar.edu.unq.epers.aterrizar.model.Busqueda
import ar.edu.unq.epers.aterrizar.model.CriterioPorAerolinea
import ar.edu.unq.epers.aterrizar.model.CriterioPorCategoriaDeAsiento
import ar.edu.unq.epers.aterrizar.model.CriterioPorDestino
import ar.edu.unq.epers.aterrizar.model.CriterioPorFechaDeLlegada
import ar.edu.unq.epers.aterrizar.model.CriterioPorFechaDeSalida
import ar.edu.unq.epers.aterrizar.model.CriterioPorOrigen
import ar.edu.unq.epers.aterrizar.model.Primera
import java.sql.Date
import org.junit.After
import org.junit.Assert
import org.junit.Before
import org.junit.Test

/**
 * Created by damian on 4/18/16.
 */
class TestCriterio {

    val criterio1 = new CriterioPorAerolinea() => [aerolinea = "L.A.N."]
    val criterio2 = new CriterioPorAerolinea() => [aerolinea = "Aerolineas Argentinas"]
    val criterio3 = new CriterioPorCategoriaDeAsiento() => [categoriaAsiento = new Primera]
    val criterio4 = new CriterioPorFechaDeSalida() => [fechaSalida = new Date(116,6,16)]
    val criterio5 = new CriterioPorFechaDeLlegada() => [fechaLlegada = new Date(116,07,01)]
    val criterio6 = new CriterioPorOrigen() => [origen = "Buenos Aires"]
    val criterio7 = new CriterioPorDestino() => [destino = "Chubut"]
    var Busqueda busqueda

    @Before
    def void setUp(){
    }

    @After
    def void tearDown(){

    }

    @Test
    def void criterioPorAerolinea(){

        busqueda = new Busqueda() => [criterio = criterio1]

        Assert.assertEquals("select vuelo from Aerolinea aerolinea join aerolinea.vuelos vuelo where aerolinea.nombre = L.A.N.", busqueda.getHQL)

    }

    @Test
    def void criterioPorUnaAerolineaUOtra(){

        busqueda = new Busqueda() => [criterio = criterio1.or(criterio2)]

        Assert.assertEquals("select vuelo from Aerolinea aerolinea join aerolinea.vuelos vuelo where aerolinea.nombre = L.A.N. or aerolinea.nombre = Aerolineas Argentinas", busqueda.getHQL)

    }

    @Test
    def void filtrarPorCategoriaDeAsiento(){

        busqueda = new Busqueda() => [criterio = criterio3]
        Assert.assertEquals("select vuelo from Aerolinea aerolinea join aerolinea.vuelos vuelo where vuelo.tramos as tramo join tramo.asientos as asiento where asiento.categoria.getCategoria = Primera", busqueda.getHQL)

    }

    @Test
    def void filtrarPorFechaDeSalida(){

        busqueda = new Busqueda() => [criterio = criterio4]
        Assert.assertEquals("select vuelo from Aerolinea aerolinea join aerolinea.vuelos vuelo where vuelo.tramos as tramo where tramo.salida = 2016-07-16", busqueda.getHQL)

    }

    @Test
    def void filtrarPorFechaDeLlegada(){

        busqueda = new Busqueda() => [criterio = criterio5]
        Assert.assertEquals("select vuelo from Aerolinea aerolinea join aerolinea.vuelos vuelo where vuelo.tramos as tramo where tramo.salida = 2016-08-01", busqueda.getHQL)

    }

    @Test
    def void filtrarPorOrigen(){

        busqueda = new Busqueda() => [criterio = criterio6]
        Assert.assertEquals("select vuelo from Aerolinea aerolinea join aerolinea.vuelos vuelo where vuelo.tramos as tramo where tramo.origen = Buenos Aires", busqueda.getHQL)

    }

    @Test
    def void filtrarPorDestino(){

        busqueda = new Busqueda() => [criterio = criterio7]
        Assert.assertEquals("select vuelo from Aerolinea aerolinea join aerolinea.vuelos vuelo where vuelo.tramos as tramo where tramo.destino = Chubut", busqueda.getHQL)

    }

    @Test
    def void combinarFiltrosConAndYOr(){

        busqueda = new Busqueda() => [criterio = criterio1.and(criterio3.or(criterio4.and(criterio6)))]

        Assert.assertEquals('select vuelo from Aerolinea aerolinea join aerolinea.vuelos vuelo where aerolinea.nombre = L.A.N. and vuelo.tramos as tramo join tramo.asientos as asiento where asiento.categoria.getCategoria = Primera or vuelo.tramos as tramo where tramo.salida = 2016-07-16 and vuelo.tramos as tramo where tramo.origen = Buenos Aires', busqueda.getHQL)


    }






}